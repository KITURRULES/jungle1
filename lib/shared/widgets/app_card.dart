import 'package:flutter/material.dart';
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
      accentColor: compact ? JungleColors.paper : JungleColors.concrete,
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
                        fontSize: compact ? 18 : 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: JungleColors.acid,
                        border: Border.fromBorderSide(
                          BorderSide(color: JungleColors.ink, width: 2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        child: Text(
                          app.category.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: JungleColors.ink,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
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
              color: JungleColors.ink,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: JungleColors.ink, thickness: 2, height: 2),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star, color: JungleColors.ink, size: 17),
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
                style: const TextStyle(
                  color: JungleColors.ink,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
        border: Border.all(color: JungleColors.ink, width: 3),
        boxShadow: [
          const BoxShadow(
            color: JungleColors.ink,
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Text(
            app.iconGlyph,
            style: TextStyle(
              color: JungleColors.paper,
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
