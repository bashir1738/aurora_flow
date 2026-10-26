import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/animated_number.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/reveal.dart';

class PulseScreen extends StatefulWidget {
  const PulseScreen({super.key});

  @override
  State<PulseScreen> createState() => _PulseScreenState();
}

class _PulseScreenState extends State<PulseScreen> {
  bool _running = true;

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
              'EXPERIMENT 02 · BREATH',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.pink,
                letterSpacing: 2.4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Reveal(
            delay: const Duration(milliseconds: 60),
            child: Text(
              'Pulse',
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
              'A calm orb that swells with every breath, trailing soft '
              'waves of light behind it.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          Reveal(
            delay: const Duration(milliseconds: 200),
            child: SizedBox(
              height: 390,
              child: GlassCard(
                padding: EdgeInsets.zero,
                radius: 36,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.violet.withValues(alpha: 0.16),
                    AppColors.pink.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: _BreathingStage(running: _running),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Reveal(
            delay: const Duration(milliseconds: 320),
            child: Row(
              children: const [
                Expanded(
                  child: _VitalCard(value: 72, label: 'BPM now'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _VitalCard(value: 4, suffix: 's', label: 'Inhale'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _VitalCard(value: 6, suffix: 's', label: 'Exhale'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Reveal(
            delay: const Duration(milliseconds: 400),
            child: GradientButton(
              label: _running ? 'Pause breathing' : 'Resume breathing',
              icon: _running
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              onTap: () => setState(() => _running = !_running),
              colors: const [AppColors.pink, AppColors.violet],
              expand: true,
            ),
          ),
          const SizedBox(height: 16),
          Reveal(
            delay: const Duration(milliseconds: 480),
            child: GlassCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.self_improvement_rounded,
                    color: AppColors.cyan,
                    size: 20,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'The glow, the scale and the wave trails all share one '
                      'clock, which is why the whole scene inhales together.',
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

class _BreathingStage extends StatefulWidget {
  const _BreathingStage({required this.running});

  final bool running;

  @override
  State<_BreathingStage> createState() => _BreathingStageState();
}

class _BreathingStageState extends State<_BreathingStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );
    if (widget.running) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant _BreathingStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.running == widget.running) return;
    if (widget.running) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
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
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _WavePainter(_controller.value),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final breath =
                0.5 - 0.5 * math.cos(_controller.value * math.pi * 2);
            return Center(
              child: Transform.scale(
                scale: 0.94 + 0.07 * breath,
                child: _Orb(glow: breath),
              ),
            );
          },
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.running ? AppColors.cyan : AppColors.textMuted,
                  boxShadow: [
                    if (widget.running)
                      BoxShadow(
                        color: AppColors.cyan.withValues(alpha: 0.8),
                        blurRadius: 9,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.running ? 'BREATHING' : 'PAUSED',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: widget.running
                      ? AppColors.cyan
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 22,
          child: Text(
            'IN 4s     HOLD 2s     OUT 6s',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.5,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.glow});

  final double glow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 238,
            height: 238,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Container(
            width: 198,
            height: 198,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.pink.withValues(alpha: 0.10 + glow * 0.1),
              ),
            ),
          ),
          Container(
            width: 168,
            height: 168,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-0.32, -0.38),
                radius: 0.95,
                colors: [
                  Color(0xFFFFB7D4),
                  AppColors.pink,
                  AppColors.violet,
                ],
                stops: [0, 0.45, 1],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.violet.withValues(alpha: 0.4 + glow * 0.3),
                  blurRadius: 48 + glow * 34,
                  spreadRadius: 4 + glow * 10,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 24,
                  left: 30,
                  child: Container(
                    width: 52,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.4),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: const Icon(
                      Icons.air_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final colors = [AppColors.cyan, AppColors.pink, AppColors.violet];

    for (var i = 0; i < 3; i++) {
      final path = Path();
      final phase = t * math.pi * 2 + i * 1.9;
      final amplitude = size.height * (0.035 + i * 0.018);
      final baseY = size.height * (0.5 + (i - 1) * 0.1);

      for (double x = -10; x <= size.width + 10; x += 6) {
        final y = baseY +
            math.sin((x / size.width) * math.pi * 2 * 1.3 + phase) *
                amplitude +
            math.sin((x / size.width) * math.pi * 2 * 2.7 - phase * 0.8) *
                amplitude *
                0.4;
        if (x == -10) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      final color = colors[i];
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..shader = LinearGradient(
            colors: [
              color.withValues(alpha: 0),
              color.withValues(alpha: 0.55 - i * 0.12),
              color.withValues(alpha: 0),
            ],
            stops: const [0, 0.5, 1],
          ).createShader(rect),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.t != t;
}

class _VitalCard extends StatelessWidget {
  const _VitalCard({
    required this.value,
    required this.label,
    this.suffix = '',
  });

  final double value;
  final String label;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedNumber(
            value: value,
            suffix: suffix,
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 23),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10.5),
          ),
        ],
      ),
    );
  }
}
