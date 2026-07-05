import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/jungle_theme.dart';
import '../../features/catalog/domain/app_model.dart';
import 'glass_panel.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.app, this.compact = false});

  final JungleAppModel app;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      onTap: () => context.go('/apps/${app.id}'),
      padding: EdgeInsets.all(compact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIcon(app: app, size: compact ? 44 : 56),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      app.category,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: JungleColors.moss,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            app.tagline,
            maxLines: compact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: JungleColors.mist.withValues(alpha: 0.78),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.star, color: JungleColors.amber, size: 17),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${app.rating.toStringAsFixed(1)} (${app.reviewCount})',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${app.sizeMb.toStringAsFixed(1)} MB',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: JungleColors.mist.withValues(alpha: 0.62),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.05, end: 0);
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.app,
    this.size = 56,
    this.heroEnabled = true,
  });

  final JungleAppModel app;
  final double size;
  final bool heroEnabled;

  @override
  Widget build(BuildContext context) {
    final colors = app.bannerGradient.map(_hexToColor).toList();
    final icon = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colors.last.withValues(alpha: 0.32),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Text(
            app.iconGlyph,
            style: TextStyle(
              color: JungleColors.mist,
              fontSize: size * 0.48,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );

    if (!heroEnabled) {
      return icon;
    }

    return Hero(tag: 'app-icon-${app.id}', child: icon);
  }
}

Color _hexToColor(String hex) {
  final value = hex.replaceFirst('#', '');
  return Color(int.parse('FF$value', radix: 16));
}
