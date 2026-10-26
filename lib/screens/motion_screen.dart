import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/particle_field.dart';
import '../widgets/reveal.dart';

class MotionScreen extends StatefulWidget {
  const MotionScreen({super.key});

  @override
  State<MotionScreen> createState() => _MotionScreenState();
}

class _MotionScreenState extends State<MotionScreen> {
  bool _connect = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 150),
        children: [
          const Reveal(child: _Eyebrow('EXPERIMENT 01 · PARTICLES')),
          const SizedBox(height: 8),
          Reveal(
            delay: const Duration(milliseconds: 60),
            child: Text(
              'Motion',
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
              'Eighty points of light drift forever through the dark. '
              'Nearby stars reach for each other.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          Reveal(
            delay: const Duration(milliseconds: 200),
            child: AspectRatio(
              aspectRatio: 0.92,
              child: GlassCard(
                padding: EdgeInsets.zero,
                radius: 36,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ParticleField(
                        particleCount: 80,
                        connect: _connect,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x6605060F)],
                            stops: [0.55, 1],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 18,
                        left: 18,
                        child: _Pill(
                          label: 'LIVE FIELD',
                          color: AppColors.cyan,
                          pulsing: true,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: Row(
                          children: const [
                            _MiniStat(value: '80', label: 'particles'),
                            SizedBox(width: 26),
                            _MiniStat(value: '32s', label: 'loop'),
                            Spacer(),
                            Icon(
                              Icons.gesture_rounded,
                              color: AppColors.textMuted,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Reveal(
            delay: const Duration(milliseconds: 320),
            child: GlassCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Constellation lines',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Connect particles that wander close',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  _GlowSwitch(
                    value: _connect,
                    onChanged: (value) => setState(() => _connect = value),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Reveal(
            delay: const Duration(milliseconds: 400),
            child: GlassCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.violet,
                    size: 20,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Each particle owns a velocity, a twinkle phase and a '
                      'colour. The whole field is painted every frame on a '
                      'single canvas.',
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

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.cyan,
            letterSpacing: 2.4,
          ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
    this.pulsing = false,
  });

  final String label;
  final Color color;
  final bool pulsing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.background.withValues(alpha: 0.55),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulsing) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.8),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

class _GlowSwitch extends StatelessWidget {
  const _GlowSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
        width: 54,
        height: 32,
        padding: const EdgeInsets.all(3),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
            colors: value
                ? const [AppColors.violet, AppColors.pink]
                : [
                    Colors.white.withValues(alpha: 0.14),
                    Colors.white.withValues(alpha: 0.07),
                  ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: value ? 0.28 : 0.12),
          ),
        ),
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
