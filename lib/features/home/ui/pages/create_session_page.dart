import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_manager/core/api_manager/livekit_config.dart';
import 'package:livekit_manager/core/api_manager/livekit_token_service.dart';
import 'package:livekit_manager/core/theme/app_colors.dart';
import 'package:livekit_manager/core/theme/app_spacing.dart';
import 'package:livekit_manager/core/widgets/app_page_scaffold.dart';
import 'package:livekit_manager/router/go_router.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> with SingleTickerProviderStateMixin {
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
    _pulseAnim = Tween<double>(begin: 0.98, end: 1.03).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  String _generateCode() {
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
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
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('جلسة جديدة'),
      ),
      body: AppPageScaffold(
        maxWidth: 760,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScaleTransition(
                  scale: _pulseAnim,
                  child: Container(
                    width: 112.r,
                    height: 112.r,
                    margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.lg),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primaryContainer,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.24),
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Icon(Icons.video_camera_front_rounded, size: 52.sp, color: theme.colorScheme.primary),
                  ),
                ),
                Text('كود الجلسة', style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'شارك هذا الكود مع المشاركين للانضمام إلى الجلسة.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                _SessionCodeCard(
                  code: _sessionCode,
                  copied: _copied,
                  onCopy: _copyCode,
                  onRefresh: _regenerate,
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: AppSpacing.card,
                  decoration: BoxDecoration(
                    color: semantic.info.withValues(alpha: 0.08),
                    borderRadius: AppRadius.medium,
                    border: Border.all(color: semantic.info.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: semantic.info),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'يمكنك توليد كود جديد قبل بدء الجلسة. بعد البدء سيتم فتح غرفة LiveKit مباشرة.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  onPressed: _startSession,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('ابدأ الجلسة'),
                  style: FilledButton.styleFrom(minimumSize: Size.fromHeight(56.h)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      child: Container(
        key: ValueKey(code),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: AppRadius.large,
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: AppShadows.lifted,
        ),
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: FittedBox(
                child: Text(
                  '${code.substring(0, 2)} · ${code.substring(2)}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onCopy,
                  icon: Icon(copied ? Icons.check_circle_rounded : Icons.copy_rounded),
                  label: Text(copied ? 'تم النسخ' : 'نسخ الكود'),
                  style: FilledButton.styleFrom(
                    backgroundColor: copied ? semantic.success.withValues(alpha: 0.14) : null,
                    foregroundColor: copied ? semantic.success : null,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('كود جديد'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
