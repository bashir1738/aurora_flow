import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/pressable.dart';
import '../widgets/primary_button.dart';
import '../widgets/reveal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenTab,
    required this.onOpenPalette,
  });

  final ValueChanged<int> onOpenTab;
  final VoidCallback onOpenPalette;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final worlds = <_World>[
      _World(
        icon: Icons.gesture_rounded,
        title: 'Motion',
        subtitle: 'A field of flowing lines',
        onTap: () => onOpenTab(1),
      ),
      _World(
        icon: Icons.circle_outlined,
        title: 'Pulse',
        subtitle: 'Breathe with a quiet circle',
        onTap: () => onOpenTab(2),
      ),
      _World(
        icon: Icons.layers_outlined,
        title: 'Depth',
        subtitle: 'A stack that leans with you',
        onTap: () => onOpenTab(3),
      ),
      _World(
        icon: Icons.palette_outlined,
        title: 'Palette',
        subtitle: 'Three solid colour sets',
        onTap: onOpenPalette,
      ),
    ];

    return SafeArea(
      bottom: false,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
        children: [
          Reveal(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Aurora Flow',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(width: 12),
                Text('04 WORLDS', style: theme.textTheme.labelSmall),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Reveal(
            delay: const Duration(milliseconds: 80),
            child: Text(
              'Design in\nmotion',
              style: theme.textTheme.displayLarge?.copyWith(fontSize: 44),
            ),
          ),
          const SizedBox(height: 18),
          Reveal(
            delay: const Duration(milliseconds: 140),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'A small playground of motion, rhythm and depth. '
                'Built by hand with Flutter.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Reveal(
            delay: const Duration(milliseconds: 200),
            child: PrimaryButton(
              label: 'Open palette',
              icon: Icons.arrow_forward_rounded,
              onTap: onOpenPalette,
            ),
          ),
          const SizedBox(height: 48),
          Reveal(
            delay: const Duration(milliseconds: 260),
            child: Row(
              children: [
                Text('Worlds', style: theme.textTheme.titleLarge),
                const Spacer(),
                Text('TAP TO ENTER', style: theme.textTheme.labelSmall),
              ],
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < worlds.length; i++)
            Reveal(
              delay: Duration(milliseconds: 300 + i * 60),
              offset: const Offset(0.04, 0),
              child: Column(
                children: [
                  _WorldRow(world: worlds[i]),
                  if (i != worlds.length - 1)
                    const Divider(height: 1, color: AppColors.border),
                ],
              ),
            ),
          const SizedBox(height: 32),
          Reveal(
            delay: const Duration(milliseconds: 620),
            child: Text(
              'Hand-built with CustomPainter and implicit animations.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _World {
  const _World({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _WorldRow extends StatelessWidget {
  const _WorldRow({required this.world});

  final _World world;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Pressable(
      onTap: world.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Icon(world.icon, size: 20, color: AppColors.textMuted),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(world.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(world.subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_outward_rounded,
              size: 17,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
