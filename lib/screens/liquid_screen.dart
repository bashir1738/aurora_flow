import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/animated_number.dart';
import '../widgets/aurora_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/liquid_blob.dart';
import '../widgets/progress_ring.dart';
import '../widgets/reveal.dart';
import '../widgets/shimmer_text.dart';

class LiquidScreen extends StatefulWidget {
  const LiquidScreen({super.key});

  @override
  State<LiquidScreen> createState() => _LiquidScreenState();
}

class _LiquidScreenState extends State<LiquidScreen> {
  static const _palettes = <List<Color>>[
    AppColors.aurora,
    AppColors.sunset,
    AppColors.ocean,
  ];

  int _palette = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _palettes[_palette];

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
            children: [
              Row(
                children: [
                  GlassCard(
                    radius: 18,
                    padding: const EdgeInsets.all(10),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.cyan.withValues(alpha: 0.12),
                      border: Border.all(
                        color: AppColors.cyan.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'LIQUID LAB',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.cyan,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Reveal(
                child: ShimmerText(
                  'Liquid\nmotion',
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 44,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Reveal(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'Organic shapes drawn from pure math. One sine wave at a '
                  'time, coloured by a rotating sweep gradient.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 14),
              Reveal(
                delay: const Duration(milliseconds: 200),
                child: Center(
                  child: LiquidBlob(
                    key: ValueKey(_palette),
                    size: 250,
                    colors: colors,
                    period: const Duration(seconds: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedNumber(
                          value: 87,
                          suffix: '%',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'HYDRATION',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Reveal(
                delay: const Duration(milliseconds: 280),
                child: Center(
                  child: GradientButton(
                    label: 'Shuffle palette',
                    icon: Icons.auto_awesome_rounded,
                    colors: colors,
                    onTap: () {
                      setState(() => _palette = (_palette + 1) % _palettes.length);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Reveal(
                delay: const Duration(milliseconds: 360),
                child: Row(
                  children: [
                    GlassCard(
                      radius: 26,
                      padding: const EdgeInsets.all(16),
                      child: ProgressRing(
                        value: 0.82,
                        size: 104,
                        stroke: 9,
                        colors: colors,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedNumber(
                              value: 82,
                              suffix: '%',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'FLOW',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 8,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        radius: 26,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sweep gradient',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'The fill rotates with the same clock that '
                              'deforms the edge, so highlight and shape stay '
                              'in sync.',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Reveal(
                delay: const Duration(milliseconds: 440),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blob family',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LiquidBlob(
                              size: 84,
                              colors: colors,
                              period: const Duration(seconds: 11),
                            ),
                            const SizedBox(width: 18),
                            LiquidBlob(
                              size: 68,
                              colors: colors.reversed.toList(),
                              period: const Duration(seconds: 7),
                            ),
                            const SizedBox(width: 18),
                            LiquidBlob(
                              size: 92,
                              colors: colors,
                              period: const Duration(seconds: 14),
                            ),
                            const SizedBox(width: 18),
                            LiquidBlob(
                              size: 56,
                              colors: colors.reversed.toList(),
                              period: const Duration(seconds: 9),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Same algorithm, different phase, period and palette.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
