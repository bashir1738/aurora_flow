import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A drifting particle system with optional constellation lines.
class ParticleField extends StatefulWidget {
  const ParticleField({
    super.key,
    this.particleCount = 70,
    this.connect = false,
    this.colors = const [AppColors.cyan, AppColors.violet, AppColors.pink],
  });

  final int particleCount;
  final bool connect;
  final List<Color> colors;

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final random = math.Random(21);
    _particles = List.generate(widget.particleCount, (index) {
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        vx: const [0.4, 0.7, 1.0, 1.3][random.nextInt(4)],
        vy: const [0.3, 0.6, 0.9][random.nextInt(3)],
        radius: 0.8 + random.nextDouble() * 2.2,
        phase: random.nextDouble() * math.pi * 2,
        color: widget.colors[index % widget.colors.length],
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 32),
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
          painter: _ParticlePainter(
            t: _controller.value,
            particles: _particles,
            connect: widget.connect,
          ),
        ),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.phase,
    required this.color,
  });

  final double x;
  final double y;
  final double vx;
  final double vy;
  final double radius;
  final double phase;
  final Color color;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.t,
    required this.particles,
    required this.connect,
  });

  final double t;
  final List<_Particle> particles;
  final bool connect;

  @override
  void paint(Canvas canvas, Size size) {
    final positions = <Offset>[];
    for (final particle in particles) {
      final x = (particle.x + particle.vx * t) % 1;
      final y = (particle.y + particle.vy * t) % 1;
      final position = Offset(x * size.width, y * size.height);
      positions.add(position);

      final twinkle =
          0.35 + 0.65 * (0.5 + 0.5 * math.sin(t * math.pi * 2 * 4 + particle.phase));
      canvas.drawCircle(
        position,
        particle.radius,
        Paint()..color = particle.color.withValues(alpha: twinkle),
      );
      canvas.drawCircle(
        position,
        particle.radius * 4,
        Paint()
          ..shader = RadialGradient(
            colors: [
              particle.color.withValues(alpha: 0.22 * twinkle),
              particle.color.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(center: position, radius: particle.radius * 4),
          ),
      );
    }

    if (!connect) return;

    final maxDistance = size.shortestSide * 0.2;
    final linePaint = Paint()
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < positions.length; i++) {
      for (var j = i + 1; j < positions.length; j++) {
        final distance = (positions[i] - positions[j]).distance;
        if (distance < maxDistance) {
          linePaint.color = Colors.white.withValues(
            alpha: (1 - distance / maxDistance) * 0.18,
          );
          canvas.drawLine(positions[i], positions[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.connect != connect ||
      oldDelegate.particles != particles;
}
