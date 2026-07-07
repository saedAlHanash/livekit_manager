import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'app_pressable.dart';

class AppListCard extends StatelessWidget {
  const AppListCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPressable(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.card,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: AppRadius.medium,
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: AppRadius.small,
              ),
              child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            trailing ?? Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
