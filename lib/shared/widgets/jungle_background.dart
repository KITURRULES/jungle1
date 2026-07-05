import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/jungle_theme.dart';

class JungleBackground extends StatelessWidget {
  const JungleBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF07130F), Color(0xFF0B241C), Color(0xFF171915)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _CanopyPainterLayer()),
          Positioned.fill(child: SafeArea(child: child)),
        ],
      ),
    );
  }
}

class _CanopyPainterLayer extends StatelessWidget {
  const _CanopyPainterLayer();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CanopyPainter());
  }
}

class _CanopyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final leafPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = JungleColors.teal.withValues(alpha: 0.14);

    paint.color = JungleColors.canopy.withValues(alpha: 0.38);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.12, size.height * 0.1),
        width: size.width * 0.78,
        height: size.height * 0.35,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.88, size.height * 0.2),
        width: size.width * 0.74,
        height: size.height * 0.38,
      ),
      paint..color = JungleColors.vine.withValues(alpha: 0.3),
    );

    for (var i = 0; i < 18; i++) {
      final x = (i * 73 % 100) / 100 * size.width;
      final y = (i * 41 % 100) / 100 * size.height;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(math.sin(i) * 0.9);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: 18 + (i % 4) * 8,
            height: 46 + (i % 3) * 13,
          ),
          const Radius.circular(28),
        ),
        leafPaint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
