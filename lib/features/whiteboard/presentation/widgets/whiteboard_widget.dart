import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_manager/features/whiteboard/data/models/stroke_model.dart';
import 'package:livekit_manager/features/whiteboard/logic/whiteboard_cubit.dart';

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

        for (var i = 1; i < stroke.points.length; i++) {
          final pt = stroke.points[i];
          path.lineTo(pt.x * size.width, pt.y * size.height);
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

class WhiteboardWidget extends StatefulWidget {
  final String sessionId;
  final String userId;

  const WhiteboardWidget({
    super.key,
    required this.sessionId,
    required this.userId,
  });

  @override
  State<WhiteboardWidget> createState() => _WhiteboardWidgetState();
}

class _WhiteboardWidgetState extends State<WhiteboardWidget> {
  String? _currentStrokeId;
  String _activeTool = 'pen'; // 'pen' or 'eraser'
  double _penWidth = 3.0;     // 3.0, 6.0, 12.0

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WhiteboardCubit>();
    return BlocBuilder<WhiteboardCubit, WhiteboardState>(
      builder: (context, state) {
        final allStrokes = <StrokeModel>[
          ...state.finalizedStrokes.values,
          ...state.liveStrokes.values,
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            final canvasWidth = constraints.maxWidth;
            final canvasHeight = constraints.maxHeight;

            return Stack(
              children: [
                // Whiteboard canvas container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Listener(
                    onPointerDown: (event) {
                      final localPos = event.localPosition;
                      final normX = localPos.dx / canvasWidth;
                      final normY = localPos.dy / canvasHeight;

                      final strokeId = _generateUuid();
                      _currentStrokeId = strokeId;

                      final drawColor = _activeTool == 'eraser' ? '#FFFFFF' : state.userColor;
                      final style = _activeTool == 'eraser' ? 'width:20.0' : 'width:$_penWidth';

                      cubit.addLocalPoint(
                        strokeId,
                        drawColor,
                        normX,
                        normY,
                        DateTime.now().millisecondsSinceEpoch,
                        style: style,
                      );
                    },
                    onPointerMove: (event) {
                      final strokeId = _currentStrokeId;
                      if (strokeId == null) return;

                      final localPos = event.localPosition;
                      final normX = (localPos.dx / canvasWidth).clamp(0.0, 1.0);
                      final normY = (localPos.dy / canvasHeight).clamp(0.0, 1.0);

                      final drawColor = _activeTool == 'eraser' ? '#FFFFFF' : state.userColor;
                      final style = _activeTool == 'eraser' ? 'width:20.0' : 'width:$_penWidth';

                      cubit.addLocalPoint(
                        strokeId,
                        drawColor,
                        normX,
                        normY,
                        DateTime.now().millisecondsSinceEpoch,
                        style: style,
                      );
                    },
                    onPointerUp: (event) {
                      final strokeId = _currentStrokeId;
                      if (strokeId == null) return;

                      cubit.finalizeLocalStroke(strokeId);
                      _currentStrokeId = null;
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: double.infinity,
                      child: CustomPaint(
                        painter: WhiteboardPainter(strokes: allStrokes),
                      ),
                    ),
                  ),
                ),

                // Floating toolbar overlay
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          const SizedBox(width: 8),
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
                          IconButton(
                            icon: const Icon(Icons.undo, color: Colors.black87),
                            tooltip: 'تراجع',
                            onPressed: () => cubit.undo(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator()),
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
    final random = Random();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40;
    values[8] = (values[8] & 0x3f) | 0x80;
    final buffer = StringBuffer();
    for (var i = 0; i < 16; i++) {
      if (i == 4 || i == 6 || i == 8 || i == 10) buffer.write('-');
      buffer.write(values[i].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
