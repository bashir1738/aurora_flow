import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A morphing, gradient-filled blob that never stops moving.
class LiquidBlob extends StatefulWidget {
  const LiquidBlob({
    super.key,
    this.size = 180,
    this.colors = AppColors.aurora,
    this.period = const Duration(seconds: 9),
    this.amplitude = 1,
    this.child,
  });

  final double size;
  final List<Color> colors;
  final Duration period;
  final double amplitude;
  final Widget? child;

  @override
  State<LiquidBlob> createState() => _LiquidBlobState();
}

class _LiquidBlobState extends State<LiquidBlob>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _BlobPainter(
            t: _controller.value,
            colors: widget.colors,
            amplitude: widget.amplitude,
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({
    required this.t,
    required this.colors,
    required this.amplitude,
  });

  final double t;
  final List<Color> colors;
  final double amplitude;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final baseRadius = size.shortestSide * 0.36;
    final angle = t * math.pi * 2;

    canvas.drawCircle(
      center,
      baseRadius * 1.5,
      Paint()
        ..shader = RadialGradient(
          colors: [
            colors.first.withValues(alpha: 0.35),
            colors.first.withValues(alpha: 0),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: baseRadius * 1.5),
        ),
    );

    final path = Path();
    const steps = 110;
    for (var i = 0; i <= steps; i++) {
      final theta = (i / steps) * math.pi * 2;
      final wobble = math.sin(theta * 3 + angle) * 0.07 +
          math.sin(theta * 5 - angle * 1.4) * 0.035 +
          math.sin(theta * 7 + angle * 0.7) * 0.02;
      final radius = baseRadius * (1 + wobble * amplitude);
      final point = center +
          Offset(math.cos(theta) * radius, math.sin(theta) * radius);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = SweepGradient(
          colors: [...colors, colors.first],
          transform: GradientRotation(angle),
        ).createShader(Offset.zero & size),
    );

    canvas.drawCircle(
      center.translate(-baseRadius * 0.28, -baseRadius * 0.34),
      baseRadius * 0.34,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.45),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(
          Rect.fromCircle(
            center: center.translate(-baseRadius * 0.28, -baseRadius * 0.34),
            radius: baseRadius * 0.34,
          ),
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.colors != colors ||
      oldDelegate.amplitude != amplitude;
}
