import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A quiet animated field of sine lines.
class LineField extends StatefulWidget {
  const LineField({
    super.key,
    this.color = AppColors.ink,
    this.lineCount = 4,
  });

  final Color color;
  final int lineCount;

  @override
  State<LineField> createState() => _LineFieldState();
}

class _LineFieldState extends State<LineField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _LineFieldPainter(
            t: _controller.value,
            color: widget.color,
            lineCount: widget.lineCount,
          ),
        ),
      ),
    );
  }
}

class _LineFieldPainter extends CustomPainter {
  _LineFieldPainter({
    required this.t,
    required this.color,
    required this.lineCount,
  });

  final double t;
  final Color color;
  final int lineCount;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final w = size.width;
    final h = size.height;
    final centerY = h / 2;
    final phase = t * math.pi * 2;
    final spacing = h * 0.11;

    for (var i = 0; i < lineCount; i++) {
      final baseY = centerY + (i - (lineCount - 1) / 2) * spacing;
      final amplitude = h * (0.06 + i * 0.012);
      final path = Path();

      for (double x = 0; x <= w; x += 3) {
        final y = baseY +
            math.sin((x / w) * math.pi * 2 * 1.1 + phase + i * 0.7) *
                amplitude +
            math.sin((x / w) * math.pi * 2 * 2.4 - phase * 0.7 + i) *
                amplitude *
                0.28;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = color.withValues(alpha: 0.62 - i * 0.09),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineFieldPainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.color != color ||
      oldDelegate.lineCount != lineCount;
}
