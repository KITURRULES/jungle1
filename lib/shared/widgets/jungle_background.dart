import 'package:flutter/material.dart';

import '../../core/theme/jungle_theme.dart';

class JungleBackground extends StatelessWidget {
  const JungleBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: JungleColors.paper),
      child: Stack(
        children: [
          const Positioned.fill(child: _BrutalistGridLayer()),
          Positioned.fill(child: SafeArea(child: child)),
        ],
      ),
    );
  }
}

class _BrutalistGridLayer extends StatelessWidget {
  const _BrutalistGridLayer();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BrutalistGridPainter());
  }
}

class _BrutalistGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = JungleColors.ink.withValues(alpha: 0.07)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final blockPaint = Paint()..style = PaintingStyle.fill;
    blockPaint.color = JungleColors.acid.withValues(alpha: 0.88);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.68, 44, size.width * 0.24, 82),
      blockPaint,
    );
    blockPaint.color = JungleColors.volt.withValues(alpha: 0.72);
    canvas.drawRect(
      Rect.fromLTWH(18, size.height * 0.68, size.width * 0.34, 64),
      blockPaint,
    );
    blockPaint.color = JungleColors.warning.withValues(alpha: 0.68);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.58, size.height * 0.78, 96, 96),
      blockPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
