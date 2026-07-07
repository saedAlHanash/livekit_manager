import 'dart:math';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_manager/core/api_manager/livekit_config.dart';
import 'package:livekit_manager/core/api_manager/livekit_token_service.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/router/go_router.dart';

/// صفحة إنشاء جلسة جديدة
/// تولّد كود جلسة عشوائي (حرفان + 6 أرقام) يُستخدم كـ room name في LiveKit
class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage>
    with SingleTickerProviderStateMixin {
  late String _sessionCode;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _sessionCode = _generateCode();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ─── توليد كود الجلسة: حرفان كبيران + 6 أرقام ───────────────────────────
  String _generateCode() {
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ'; // removed I,O to avoid confusion
    const digits = '0123456789';
    final rng = Random.secure();

    final l1 = letters[rng.nextInt(letters.length)];
    final l2 = letters[rng.nextInt(letters.length)];
    final nums = List.generate(6, (_) => digits[rng.nextInt(digits.length)]).join();
    return '$l1$l2$nums';
  }

  void _regenerate() {
    setState(() {
      _sessionCode = _generateCode();
      _copied = false;
    });
  }

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: _sessionCode));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  void _startSession() {
    // توليد توكن الانضمام محلياً — المضيف يملك صلاحيات كاملة
    final token = LiveKitTokenService().generateJoinToken(
      roomName: _sessionCode,
      identity: 'host_${DateTime.now().millisecondsSinceEpoch}',
      participantName: 'Host',
      videoGrants: {
        'roomAdmin': true,
        'roomCreate': true,
        'canPublish': true,
        'canSubscribe': true,
        'canPublishData': true,
      },
    );

    context.pushNamed(
      RouteName.home,
      queryParameters: {
        'url': LiveKitConfig.wssUrl,
        'token': token,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F0E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── AppBar row ──
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white70),
                  ),
                  Expanded(
                    child: DrawableText(
                      text: 'جلسة جديدة',
                      textAlign: TextAlign.center,
                      size: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // placeholder to center title
                  SizedBox(width: 48.w),
                ],
              ),

              40.verticalSpace,

              // ── Hero illustration ──
              ScaleTransition(
                scale: _pulseAnim,
                child: Container(
                  width: 120.r,
                  height: 120.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFF1DB954), Color(0xFF054239)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1DB954).withValues(alpha: 0.35),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.videocam_rounded,
                    color: Colors.white,
                    size: 54.sp,
                  ),
                ),
              ),

              32.verticalSpace,

              Text(
                'كود الجلسة',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white54,
                  letterSpacing: 1.5,
                ),
              ),

              12.verticalSpace,

              // ── Session Code Card ──
              _SessionCodeCard(
                code: _sessionCode,
                copied: _copied,
                onCopy: _copyCode,
                onRefresh: _regenerate,
              ),

              20.verticalSpace,

              // ── Info hint ──
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF054239).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFF1DB954).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: const Color(0xFF1DB954), size: 18.sp),
                    10.horizontalSpace,
                    Expanded(
                      child: DrawableText(
                        text:
                            'شارك هذا الكود مع المشاركين ليتمكنوا من الانضمام إلى الجلسة',
                        size: 12.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              40.verticalSpace,

              // ── Start button ──
              _StartButton(onTap: _startSession),

              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Session Code Card
// ─────────────────────────────────────────────────────────────────────────────

class _SessionCodeCard extends StatelessWidget {
  const _SessionCodeCard({
    required this.code,
    required this.copied,
    required this.onCopy,
    required this.onRefresh,
  });

  final String code;
  final bool copied;
  final VoidCallback onCopy;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: Container(
        key: ValueKey(code),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D2821), Color(0xFF031810)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFF1DB954).withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Code display — spaced for readability: "AB" + " " + "123456"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CodeChunk(text: code.substring(0, 2), isLetters: true),
                SizedBox(width: 8.w),
                DrawableText(
                  text: '·',
                  size: 28.sp,
                  color: Colors.white30,
                ),
                SizedBox(width: 8.w),
                _CodeChunk(text: code.substring(2), isLetters: false),
              ],
            ),

            20.verticalSpace,

            // Action row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Copy button
                _ActionChip(
                  icon: copied
                      ? Icons.check_circle_rounded
                      : Icons.copy_rounded,
                  label: copied ? 'تم النسخ!' : 'نسخ الكود',
                  color: copied
                      ? AppColorManager.green
                      : const Color(0xFF1DB954),
                  onTap: onCopy,
                ),

                16.horizontalSpace,

                // Regenerate button
                _ActionChip(
                  icon: Icons.refresh_rounded,
                  label: 'كود جديد',
                  color: AppColorManager.secondColor,
                  onTap: onRefresh,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeChunk extends StatelessWidget {
  const _CodeChunk({required this.text, required this.isLetters});

  final String text;
  final bool isLetters;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isLetters ? 40.sp : 36.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: isLetters ? 6.0 : 8.0,
        color: isLetters
            ? const Color(0xFF1DB954)
            : Colors.white,
        fontFamily: 'monospace',
        shadows: isLetters
            ? [
                Shadow(
                  color: const Color(0xFF1DB954).withValues(alpha: 0.6),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16.sp),
            8.horizontalSpace,
            DrawableText(
              text: label,
              size: 13.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Start Session Button
// ─────────────────────────────────────────────────────────────────────────────

class _StartButton extends StatelessWidget {
  const _StartButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1DB954), Color(0xFF0E8C3A)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1DB954).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26.sp),
            10.horizontalSpace,
            DrawableText(
              text: 'ابدأ الجلسة',
              size: 17.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
