import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/features/shared_whiteboard/bloc/shared_whiteboard_cubit.dart';
import 'package:livekit_manager/features/shared_whiteboard/data/models/stroke_model.dart';

import '../../../../core/util/my_style.dart';

Color parseColor(String colorStr) {
  if (colorStr.isEmpty) return Colors.black;
  try {
    var hex = colorStr.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return Colors.black;
  }
}

class WhiteboardPainter extends CustomPainter {
  final List<StrokeModel> strokes;

  WhiteboardPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      double strokeWidth = 3.0;
      if (stroke.style.startsWith('width:')) {
        strokeWidth = double.tryParse(stroke.style.split(':').last) ?? 3.0;
      } else if (stroke.style == 'eraser') {
        strokeWidth = 20.0;
      }

      final paint = Paint()
        ..color = parseColor(stroke.color)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (stroke.points.length == 1) {
        final pt = stroke.points.first;
        final center = Offset(pt.x * size.width, pt.y * size.height);
        final dotPaint = Paint()
          ..color = parseColor(stroke.color)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, strokeWidth / 2, dotPaint);
      } else {
        final path = Path();
        final firstPoint = stroke.points.first;
        path.moveTo(firstPoint.x * size.width, firstPoint.y * size.height);

        if (stroke.points.length == 2) {
          final secondPoint = stroke.points[1];
          path.lineTo(secondPoint.x * size.width, secondPoint.y * size.height);
        } else {
          for (var i = 1; i < stroke.points.length - 1; i++) {
            final p0 = stroke.points[i];
            final p1 = stroke.points[i + 1];

            final xc = ((p0.x + p1.x) / 2) * size.width;
            final yc = ((p0.y + p1.y) / 2) * size.height;

            path.quadraticBezierTo(
              p0.x * size.width,
              p0.y * size.height,
              xc,
              yc,
            );
          }
          final lastPoint = stroke.points.last;
          path.lineTo(lastPoint.x * size.width, lastPoint.y * size.height);
        }

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant WhiteboardPainter oldDelegate) {
    return true;
  }
}

class SharedWhiteboardWidget extends StatefulWidget {
  final String sessionId;
  final String userId;

  const SharedWhiteboardWidget({
    super.key,
    required this.sessionId,
    required this.userId,
  });

  @override
  State<SharedWhiteboardWidget> createState() => _SharedWhiteboardWidgetState();
}

class _SharedWhiteboardWidgetState extends State<SharedWhiteboardWidget> {
  String? _currentStrokeId;
  String _activeTool = 'pen'; // 'pen' or 'eraser', 'move'
  double _penWidth = 3.0; // 3.0, 6.0, 12.0

  double _startScale = 1.0;
  Offset _startOffset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;

  int _batchSize = 16; // Number of points to aggregate before broadcasting
  final double _threshold = 0.03; // normalized distance threshold
  final List<Map<String, dynamic>> _pendingPoints = [];
  double? _lastX;
  double? _lastY;

  void _eraseNearbyStroke(double normX, double normY, List<StrokeModel> strokes, SharedWhiteboardCubit cubit) {
    String? hitStrokeId;

    for (final stroke in strokes) {
      for (final pt in stroke.points) {
        final dist = sqrt(pow(pt.x - normX, 2) + pow(pt.y - normY, 2));
        if (dist < _threshold) {
          hitStrokeId = stroke.strokeId;
          break;
        }
      }
      if (hitStrokeId != null) break;
    }

    if (hitStrokeId != null) {
      cubit.deleteStroke(hitStrokeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SharedWhiteboardCubit>();
    return BlocBuilder<SharedWhiteboardCubit, SharedWhiteboardState>(
      builder: (context, state) {
        final allStrokes = <StrokeModel>[
          ...state.finalizedStrokes.values,
          ...state.liveStrokes.values,
        ];

        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      decoration: MyStyle.outlineBoxWhite1,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final canvasWidth = constraints.maxWidth;
                            final canvasHeight = constraints.maxHeight;

                            return Stack(
                              children: [
                                // Whiteboard canvas area
                                IgnorePointer(
                                  ignoring: !state.hasWritePermission && _activeTool != 'move',
                                  child: Listener(
                                    onPointerDown: (event) {
                                      final localPos = event.localPosition;
                                      if (_activeTool == 'move') {
                                        _startScale = state.backgroundScale;
                                        _startOffset = Offset(state.backgroundX, state.backgroundY);
                                        _initialFocalPoint = localPos;
                                        return;
                                      }
                                      final cx =
                                          (localPos.dx - state.backgroundX * canvasWidth) / state.backgroundScale;
                                      final cy =
                                          (localPos.dy - state.backgroundY * canvasHeight) / state.backgroundScale;
                                      final normX = cx / canvasWidth;
                                      final normY = cy / canvasHeight;

                                      if (_activeTool == 'eraser') {
                                        _eraseNearbyStroke(normX, normY, allStrokes, cubit);
                                      } else {
                                        final strokeId = _generateUuid();
                                        _currentStrokeId = strokeId;
                                        _pendingPoints.clear();
                                        _lastX = normX;
                                        _lastY = normY;

                                        cubit.addLocalPoint(
                                          strokeId,
                                          state.userColor,
                                          normX,
                                          normY,
                                          DateTime.now().millisecondsSinceEpoch,
                                          style: 'width:$_penWidth',
                                        );
                                      }
                                    },
                                    onPointerMove: (event) {
                                      final localPos = event.localPosition;
                                      if (_activeTool == 'move') {
                                        final dx = localPos.dx - _initialFocalPoint.dx;
                                        final dy = localPos.dy - _initialFocalPoint.dy;
                                        final newX = _startOffset.dx * canvasWidth + dx;
                                        final newY = _startOffset.dy * canvasHeight + dy;
                                        cubit.updateBackgroundTransform(
                                          _startScale,
                                          newX / canvasWidth,
                                          newY / canvasHeight,
                                        );
                                        return;
                                      }
                                      final cx =
                                          (localPos.dx - state.backgroundX * canvasWidth) / state.backgroundScale;
                                      final cy =
                                          (localPos.dy - state.backgroundY * canvasHeight) / state.backgroundScale;
                                      final normX = (cx / canvasWidth).clamp(0.0, 1.0);
                                      final normY = (cy / canvasHeight).clamp(0.0, 1.0);

                                      if (_activeTool == 'eraser') {
                                        _eraseNearbyStroke(normX, normY, allStrokes, cubit);
                                      } else {
                                        final strokeId = _currentStrokeId;
                                        if (strokeId == null) return;

                                        if (_lastX != null && _lastY != null) {
                                          final dx = normX - _lastX!;
                                          final dy = normY - _lastY!;
                                          if (dx * dx + dy * dy < 0.000004) return;
                                        }
                                        _lastX = normX;
                                        _lastY = normY;

                                        final timestamp = DateTime.now().millisecondsSinceEpoch;

                                        cubit.addPointLocally(
                                          strokeId,
                                          state.userColor,
                                          normX,
                                          normY,
                                          timestamp,
                                          style: 'width:$_penWidth',
                                        );

                                        _pendingPoints.add({'x': normX, 'y': normY, 't': timestamp});

                                        if (_pendingPoints.length >= _batchSize) {
                                          cubit.broadcastPointsBatch(
                                            strokeId,
                                            state.userColor,
                                            List<Map<String, dynamic>>.from(_pendingPoints),
                                            style: 'width:$_penWidth',
                                          );
                                          _pendingPoints.clear();
                                        }
                                      }
                                    },
                                    onPointerUp: (event) {
                                      if (_activeTool == 'move') return;
                                      final strokeId = _currentStrokeId;
                                      if (strokeId != null) {
                                        if (_activeTool != 'eraser') {
                                          if (_pendingPoints.isNotEmpty) {
                                            cubit.broadcastPointsBatch(
                                              strokeId,
                                              state.userColor,
                                              List<Map<String, dynamic>>.from(_pendingPoints),
                                              style: 'width:$_penWidth',
                                            );
                                            _pendingPoints.clear();
                                          }
                                          cubit.finalizeLocalStroke(strokeId);
                                        }
                                      }
                                      _currentStrokeId = null;
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Stack(
                                        children: [
                                          Transform(
                                            transform:
                                                Matrix4.translationValues(
                                                  state.backgroundX * canvasWidth,
                                                  state.backgroundY * canvasHeight,
                                                  0.0,
                                                ) *
                                                Matrix4.diagonal3Values(
                                                  state.backgroundScale,
                                                  state.backgroundScale,
                                                  1.0,
                                                ),
                                            alignment: Alignment.topLeft,
                                            child: Stack(
                                              children: [
                                                if (state.backgroundUrl.isNotEmpty)
                                                  Positioned.fill(
                                                    child: ImageMultiType(
                                                      url: state.backgroundUrl,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                Positioned.fill(
                                                  child: CustomPaint(
                                                    painter: WhiteboardPainter(strokes: allStrokes),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.isLoading) const Center(child: CircularProgressIndicator()),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Toolbar area (No longer floating)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Connection Indicator
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: state.connectionState.getColor,
                              ),
                            ),
                            if (state.hasWritePermission) ...[
                              IconButton(
                                icon: Icon(
                                  _activeTool == 'pen' ? Icons.brush : Icons.brush_outlined,
                                  color: _activeTool == 'pen' ? parseColor(state.userColor) : Colors.grey,
                                ),
                                tooltip: 'القلم',
                                onPressed: () {
                                  setState(() {
                                    _activeTool = 'pen';
                                  });
                                },
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: Icon(
                                  _activeTool == 'eraser' ? Icons.cleaning_services : Icons.cleaning_services_outlined,
                                  color: _activeTool == 'eraser' ? Colors.blue : Colors.grey,
                                ),
                                tooltip: 'الممحاة',
                                onPressed: () {
                                  setState(() {
                                    _activeTool = 'eraser';
                                  });
                                },
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: Icon(
                                  _activeTool == 'move' ? Icons.open_with : Icons.open_with_outlined,
                                  color: _activeTool == 'move' ? Colors.orange : Colors.grey,
                                ),
                                tooltip: 'التحريك والتكبير',
                                onPressed: () {
                                  setState(() {
                                    _activeTool = 'move';
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              if (_activeTool == 'move') ...[
                                IconButton(
                                  icon: const Icon(Icons.zoom_in, color: Colors.indigo),
                                  tooltip: 'تكبير',
                                  onPressed: () {
                                    final newScale = (state.backgroundScale + 0.25).clamp(0.5, 8.0);
                                    cubit.updateBackgroundTransform(
                                      newScale,
                                      state.backgroundX,
                                      state.backgroundY,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.zoom_out, color: Colors.indigo),
                                  tooltip: 'تصغير',
                                  onPressed: () {
                                    final newScale = (state.backgroundScale - 0.25).clamp(0.5, 8.0);
                                    cubit.updateBackgroundTransform(
                                      newScale,
                                      state.backgroundX,
                                      state.backgroundY,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.restart_alt, color: Colors.red),
                                  tooltip: 'إعادة ضبط العرض',
                                  onPressed: () {
                                    cubit.updateBackgroundTransform(1.0, 0.0, 0.0);
                                  },
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 24,
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Container(
                                height: 24,
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(width: 8),
                              if (_activeTool == 'pen') ...[
                                _buildThicknessButton(3.0, 'نحيف'),
                                _buildThicknessButton(6.0, 'متوسط'),
                                _buildThicknessButton(12.0, 'عريض'),
                                const SizedBox(width: 8),
                                Container(
                                  height: 24,
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(width: 8),
                              ],
                              if (cubit.userType.toLowerCase() == 'teacher' ||
                                  cubit.userType.toLowerCase() == 'manager') ...[
                                IconButton(
                                  icon: const Icon(Icons.add_photo_alternate, color: Colors.blue),
                                  tooltip: 'إضافة خلفية',
                                  onPressed: () async {
                                    final result = await FilePicker.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
                                      allowMultiple: false,
                                    );
                                    if (result != null && result.files.first.bytes != null) {
                                      final file = result.files.first;
                                      cubit.uploadAndSetBackground(file.bytes!, file.extension ?? 'jpg');
                                    }
                                  },
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                                  tooltip: 'مسح اللوحة',
                                  onPressed: () => cubit.clearAllBoard(),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.settings, color: Colors.blueGrey),
                                  tooltip: 'إعدادات اللوحة',
                                  onPressed: () => _showSettingsDialog(context),
                                ),
                              ],
                              IconButton(
                                icon: const Icon(Icons.undo, color: Colors.black87),
                                tooltip: 'تراجع',
                                onPressed: () => cubit.undo(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('إعدادات لوح الرسم'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('حجم التخزين المؤقت لنقاط الخط (Buffer Size): $_batchSize'),
                  Slider(
                    value: _batchSize.toDouble(),
                    min: 5,
                    max: 50,
                    divisions: 45,
                    onChanged: (v) {
                      setDialogState(() {
                        _batchSize = v.round();
                      });
                      setState(() {});
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('موافق'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildThicknessButton(double width, String tooltip) {
    final isSelected = _penWidth == width;
    return GestureDetector(
      onTap: () {
        setState(() {
          _penWidth = width;
        });
      },
      child: Tooltip(
        message: tooltip,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.grey.shade200 : Colors.transparent,
          ),
          child: CircleAvatar(
            radius: width / 2 + 1,
            backgroundColor: isSelected ? Colors.black87 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  String _generateUuid() {
    return Random().nextInt(2147483647).toString();
  }
}
