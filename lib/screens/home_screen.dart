import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/animated_number.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/liquid_blob.dart';
import '../widgets/reveal.dart';
import '../widgets/shimmer_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenTab,
    required this.onOpenLiquid,
  });

  final ValueChanged<int> onOpenTab;
  final VoidCallback onOpenLiquid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final features = <_Feature>[
      _Feature(
        icon: Icons.blur_on_rounded,
        title: 'Motion',
        subtitle: 'A field of drifting particles',
        colors: const [AppColors.cyan, AppColors.violet],
        onTap: () => onOpenTab(1),
      ),
      _Feature(
        icon: Icons.favorite_rounded,
        title: 'Pulse',
        subtitle: 'Breathe with a living orb',
        colors: const [AppColors.pink, AppColors.violet],
        onTap: () => onOpenTab(2),
      ),
      _Feature(
        icon: Icons.layers_rounded,
        title: 'Depth',
        subtitle: 'Parallax layers you can tilt',
        colors: const [AppColors.amber, AppColors.pink],
        onTap: () => onOpenTab(3),
      ),
      _Feature(
        icon: Icons.water_drop_rounded,
        title: 'Liquid lab',
        subtitle: 'Morphing blobs and rings',
        colors: const [AppColors.violet, AppColors.cyan],
        onTap: onOpenLiquid,
      ),
    ];

    return SafeArea(
      bottom: false,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 150),
        children: [
          const Reveal(child: _Header()),
          const SizedBox(height: 26),
          Reveal(
            delay: const Duration(milliseconds: 90),
            child: _HeroCard(onOpenLiquid: onOpenLiquid),
          ),
          const SizedBox(height: 16),
          Reveal(
            delay: const Duration(milliseconds: 180),
            child: Row(
              children: const [
                Expanded(
                  child: _StatCard(
                    value: 12.4,
                    decimals: 1,
                    suffix: 'k',
                    label: 'Frames drawn',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _StatCard(value: 60, label: 'Smooth fps'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _StatCard(value: 6, label: 'Live worlds'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Reveal(
            delay: const Duration(milliseconds: 320),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Motion worlds',
                  style: theme.textTheme.titleLarge,
                ),
                const Spacer(),
                Text(
                  'TAP TO ENTER',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < features.length; i++) ...[
            Reveal(
              delay: Duration(milliseconds: 380 + i * 80),
              offset: const Offset(0.08, 0),
              child: _FeatureCard(feature: features[i]),
            ),
            if (i != features.length - 1) const SizedBox(height: 12),
          ],
          const SizedBox(height: 28),
          Reveal(
            delay: const Duration(milliseconds: 760),
            child: GlassCard(
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.cyan,
                    size: 22,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Every animation here is hand-built with '
                      'CustomPainter, implicit animations and a few '
                      'well-behaved controllers.',
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.violet, AppColors.pink],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.violet.withValues(alpha: 0.4),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'AF',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AURORA FLOW',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.cyan,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 3),
              Text('Welcome back', style: theme.textTheme.titleMedium),
            ],
          ),
        ),
        const _BellButton(),
      ],
    );
  }
}

class _BellButton extends StatelessWidget {
  const _BellButton();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 18,
      padding: const EdgeInsets.all(10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size: 22,
          ),
          Positioned(
            top: -1,
            right: -1,
            child: _PulseDot(size: 8),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.size});

  final double size;

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
      builder: (context, _) {
        final glow = 0.5 + 0.5 * math.sin(_controller.value * math.pi * 2);
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.pink,
            boxShadow: [
              BoxShadow(
                color: AppColors.pink.withValues(alpha: 0.35 + glow * 0.4),
                blurRadius: 6 + glow * 8,
                spreadRadius: 1 + glow * 2,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onOpenLiquid});

  final VoidCallback onOpenLiquid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      radius: 32,
      padding: const EdgeInsets.all(24),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.violet.withValues(alpha: 0.32),
          AppColors.pink.withValues(alpha: 0.12),
          AppColors.cyan.withValues(alpha: 0.06),
        ],
      ),
      borderColor: Colors.white.withValues(alpha: 0.16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -54,
            right: -48,
            child: Opacity(
              opacity: 0.85,
              child: LiquidBlob(
                size: 176,
                period: const Duration(seconds: 12),
                colors: const [AppColors.pink, AppColors.violet],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.cyan.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.cyan.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _PulseDot(size: 6),
                    const SizedBox(width: 8),
                    Text(
                      'KINETIC UI · 2026',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.cyan,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ShimmerText(
                'Design\nin motion',
                style: theme.textTheme.displayLarge?.copyWith(fontSize: 42),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(right: 36),
                child: Text(
                  'A tiny playground of light, liquid and momentum. '
                  'Made with pure Flutter.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 22),
              GradientButton(
                label: 'Open liquid lab',
                icon: Icons.water_drop_rounded,
                onTap: onOpenLiquid,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    this.decimals = 0,
    this.suffix = '',
  });

  final double value;
  final String label;
  final int decimals;
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
            decimals: decimals,
            suffix: suffix,
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 23),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10.5),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  const _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      onTap: feature.onTap,
      padding: const EdgeInsets.all(14),
      radius: 24,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: feature.colors,
              ),
              boxShadow: [
                BoxShadow(
                  color: feature.colors.last.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(feature.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(feature.subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_outward_rounded,
            size: 18,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}
