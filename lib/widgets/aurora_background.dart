import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A slowly drifting aurora built from layered radial gradients.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({
    super.key,
    this.child,
    this.showStars = true,
    this.intensity = 1,
  });

  final Widget? child;
  final bool showStars;
  final double intensity;

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 26),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: _AuroraPainter(
                _controller.value,
                widget.intensity,
              ),
            ),
          ),
        ),
        if (widget.showStars)
          const IgnorePointer(child: RepaintBoundary(child: StarField())),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter(this.t, this.intensity);

  final double t;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final w = size.width;
    final h = size.height;
    final angle = t * 2 * math.pi;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF06070F), Color(0xFF0B0822), Color(0xFF05060F)],
        ).createShader(rect),
    );

    void blob(Offset center, double radius, Color color, double opacity) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: opacity * intensity),
              color.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }

    blob(
      Offset(
        w * (0.24 + 0.12 * math.sin(angle)),
        h * (0.16 + 0.08 * math.cos(angle * 1.3)),
      ),
      w * 0.78,
      AppColors.violet,
      0.65,
    );
    blob(
      Offset(
        w * (0.82 + 0.1 * math.cos(angle * 0.8)),
        h * (0.32 + 0.1 * math.sin(angle)),
      ),
      w * 0.66,
      AppColors.pink,
      0.48,
    );
    blob(
      Offset(
        w * (0.34 + 0.2 * math.cos(angle * 1.1)),
        h * (0.82 + 0.05 * math.sin(angle * 0.7)),
      ),
      w * 0.72,
      AppColors.cyan,
      0.34,
    );
    blob(
      Offset(
        w * (0.9 + 0.06 * math.sin(angle * 1.4)),
        h * (0.92 + 0.05 * math.cos(angle)),
      ),
      w * 0.5,
      AppColors.amber,
      0.18,
    );
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.intensity != intensity;
}

/// A subtle field of twinkling, slowly rising stars.
class StarField extends StatefulWidget {
  const StarField({super.key, this.starCount = 70});

  final int starCount;

  @override
  State<StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<StarField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    final random = math.Random(7);
    _stars = List.generate(widget.starCount, (index) {
      return _Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: 0.5 + random.nextDouble() * 1.6,
        phase: random.nextDouble() * math.pi * 2,
        speed: (random.nextBool() ? 1.0 : 2.0) * 0.5,
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _StarPainter(_controller.value, _stars),
      ),
    );
  }
}

class _Star {
  const _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.phase,
    required this.speed,
  });

  final double x;
  final double y;
  final double radius;
  final double phase;
  final double speed;
}

class _StarPainter extends CustomPainter {
  _StarPainter(this.t, this.stars);

  final double t;
  final List<_Star> stars;

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle =
          0.25 + 0.6 * (0.5 + 0.5 * math.sin(t * math.pi * 2 * 3 + star.phase));
      final y = (star.y - t * star.speed) % 1;
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: twinkle * 0.8);
      canvas.drawCircle(
        Offset(star.x * size.width, y * size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.stars != stars;
}
