import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/reveal.dart';
import '../widgets/tilt_card.dart';

class DepthScreen extends StatefulWidget {
  const DepthScreen({super.key});

  @override
  State<DepthScreen> createState() => _DepthScreenState();
}

class _DepthScreenState extends State<DepthScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_DepthStar> _stars;

  @override
  void initState() {
    super.initState();
    final random = math.Random(11);
    _stars = List.generate(64, (index) {
      return _DepthStar(
        x: random.nextDouble(),
        y: random.nextDouble() * 0.62,
        radius: 0.5 + random.nextDouble() * 1.5,
        phase: random.nextDouble() * math.pi * 2,
        layer: index % 3,
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 150),
        children: [
          Reveal(
            child: Text(
              'EXPERIMENT 03 · PARALLAX',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.amber,
                letterSpacing: 2.4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Reveal(
            delay: const Duration(milliseconds: 60),
            child: Text(
              'Depth',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Reveal(
            delay: const Duration(milliseconds: 120),
            child: Text(
              'A layered horizon that drifts at different speeds — and leans '
              'toward your pointer.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          Reveal(
            delay: const Duration(milliseconds: 200),
            child: SizedBox(
              height: 440,
              child: TiltCard(
                borderRadius: 36,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) => CustomPaint(
                          painter: _DepthPainter(
                            t: _controller.value,
                            stars: _stars,
                          ),
                        ),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xE605060F)],
                          stops: [0.52, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 18,
                      right: 18,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.background.withValues(alpha: 0.5),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.open_with_rounded,
                              size: 12,
                              color: AppColors.textPrimary,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'DRAG TO TILT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 22,
                      right: 22,
                      bottom: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parallax fields',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 26,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Four depths. One camera. Infinite drift.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Reveal(
            delay: const Duration(milliseconds: 320),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Layer stack',
                        style: theme.textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Text(
                        'MULTIPLIER',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _LayerRow(
                    label: 'Foreground hills',
                    multiplier: '1.0×',
                    color: AppColors.cyan,
                    progress: 1,
                  ),
                  const SizedBox(height: 12),
                  const _LayerRow(
                    label: 'Midground hills',
                    multiplier: '0.6×',
                    color: AppColors.pink,
                    progress: 0.62,
                  ),
                  const SizedBox(height: 12),
                  const _LayerRow(
                    label: 'Background hills',
                    multiplier: '0.3×',
                    color: AppColors.violet,
                    progress: 0.34,
                  ),
                  const SizedBox(height: 12),
                  const _LayerRow(
                    label: 'Stars & moons',
                    multiplier: '0.1×',
                    color: AppColors.amber,
                    progress: 0.14,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Reveal(
            delay: const Duration(milliseconds: 420),
            child: GlassCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.threed_rotation_rounded,
                    color: AppColors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'The card applies a perspective matrix driven by your '
                      'pointer, so the artwork and the horizon respond as one '
                      'solid object.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DepthStar {
  const _DepthStar({
    required this.x,
    required this.y,
    required this.radius,
    required this.phase,
    required this.layer,
  });

  final double x;
  final double y;
  final double radius;
  final double phase;
  final int layer;
}

class _DepthPainter extends CustomPainter {
  _DepthPainter({required this.t, required this.stars});

  final double t;
  final List<_DepthStar> stars;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;
    final angle = t * math.pi * 2;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF141235), Color(0xFF0A0A20), Color(0xFF05060F)],
          stops: [0, 0.55, 1],
        ).createShader(rect),
    );

    void glow(Offset center, double radius, Color color, double alpha) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }

    glow(
      Offset(w * (0.28 + 0.07 * math.sin(angle)), h * 0.34),
      w * 0.42,
      AppColors.violet,
      0.5,
    );
    glow(
      Offset(w * (0.78 + 0.05 * math.cos(angle)), h * 0.24),
      w * 0.34,
      AppColors.pink,
      0.4,
    );

    for (final star in stars) {
      final drift = 0.012 * (star.layer + 1);
      final x = (star.x + drift * math.sin(angle + star.phase)) % 1;
      final y = (star.y + 0.01 * math.cos(angle * 0.8 + star.phase)) % 1;
      final twinkle =
          0.25 + 0.6 * (0.5 + 0.5 * math.sin(angle * 2 + star.phase));
      canvas.drawCircle(
        Offset(x * w, y * h),
        star.radius,
        Paint()
          ..color = Colors.white.withValues(alpha: twinkle * 0.85),
      );
    }

    final moonCenter = Offset(w * 0.73, h * 0.2);
    glow(moonCenter, 92, AppColors.cyan, 0.28);
    canvas.drawCircle(
      moonCenter,
      30,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.35),
          colors: [Color(0xFFF8F5FF), Color(0xFFBFB7F2)],
        ).createShader(Rect.fromCircle(center: moonCenter, radius: 30)),
    );

    const hillColors = [AppColors.violet, AppColors.pink, AppColors.cyan];
    const baseStops = [0.60, 0.71, 0.82];
    const amplitudes = [14.0, 22.0, 30.0];
    const speeds = [0.35, 0.7, 1.15];
    const alphas = [0.20, 0.24, 0.20];

    for (var i = 0; i < 3; i++) {
      final path = Path();
      final baseY = h * baseStops[i];
      final phase = angle * speeds[i] + i * 1.4;

      for (double x = -8; x <= w + 8; x += 8) {
        final y = baseY +
            math.sin((x / w) * math.pi * 2 * 1.15 + phase) *
                amplitudes[i] +
            math.sin((x / w) * math.pi * 2 * 2.6 - phase * 0.7) *
                amplitudes[i] *
                0.45;
        if (x == -8) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.lineTo(w + 8, h);
      path.lineTo(-8, h);
      path.close();

      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              hillColors[i].withValues(alpha: alphas[i]),
              Color(0xFF05060F).withValues(alpha: 0.9),
            ],
          ).createShader(rect),
      );
    }

    final crest = Path();
    final baseY = h * baseStops[2];
    for (double x = -8; x <= w + 8; x += 8) {
      final phase = angle * speeds[2] + 2 * 1.4;
      final y = baseY +
          math.sin((x / w) * math.pi * 2 * 1.15 + phase) * amplitudes[2] +
          math.sin((x / w) * math.pi * 2 * 2.6 - phase * 0.7) *
              amplitudes[2] *
              0.45;
      if (x == -8) {
        crest.moveTo(x, y);
      } else {
        crest.lineTo(x, y);
      }
    }
    canvas.drawPath(
      crest,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..shader = LinearGradient(
          colors: [
            AppColors.cyan.withValues(alpha: 0),
            AppColors.cyan.withValues(alpha: 0.7),
            AppColors.cyan.withValues(alpha: 0),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _DepthPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.stars != stars;
}

class _LayerRow extends StatelessWidget {
  const _LayerRow({
    required this.label,
    required this.multiplier,
    required this.color,
    required this.progress,
  });

  final String label;
  final String multiplier;
  final Color color;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.7),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 118,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11.5,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Stack(
              children: [
                Container(
                  height: 5,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.5), color],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 34,
          child: Text(
            multiplier,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.5,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
