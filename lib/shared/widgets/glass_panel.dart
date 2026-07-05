import 'package:flutter/material.dart';

import '../../core/theme/jungle_theme.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.accentColor = JungleColors.paper,
    this.shadowColor = JungleColors.ink,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color accentColor;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      transform: Matrix4.translationValues(0, 0, 0),
      decoration: BoxDecoration(
        color: accentColor,
        border: Border.all(color: JungleColors.ink, width: 3),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(7, 7),
            blurRadius: 0,
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}
