import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/pressable.dart';
import '../widgets/reveal.dart';

class PaletteScreen extends StatefulWidget {
  const PaletteScreen({super.key});

  @override
  State<PaletteScreen> createState() => _PaletteScreenState();
}

class _PaletteScreenState extends State<PaletteScreen> {
  static const _palettes = <_Palette>[
    _Palette('Aurora', AppColors.aurora),
    _Palette('Sunset', AppColors.sunset),
    _Palette('Ocean', AppColors.ocean),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = _palettes[_index];

    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
              const Spacer(),
              Text('PALETTE', style: theme.textTheme.labelSmall),
            ],
          ),
          const SizedBox(height: 28),
          Reveal(
            child: Text(
              'Palette',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 36,
                letterSpacing: -1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Reveal(
            delay: const Duration(milliseconds: 80),
            child: Text(
              'Three solid colour sets. No blending, no effects.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 28),
          Reveal(
            delay: const Duration(milliseconds: 140),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 220,
                child: Row(
                  children: [
                    for (final color in active.colors)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeOut,
                          color: color,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Reveal(
            delay: const Duration(milliseconds: 200),
            child: Text(active.name, style: theme.textTheme.bodySmall),
          ),
          const SizedBox(height: 36),
          for (var i = 0; i < _palettes.length; i++)
            Reveal(
              delay: Duration(milliseconds: 260 + i * 60),
              child: Column(
                children: [
                  Pressable(
                    onTap: () => setState(() => _index = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          for (final color in _palettes[i].colors) ...[
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.border),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          const SizedBox(width: 10),
                          Text(
                            _palettes[i].name,
                            style: theme.textTheme.titleMedium,
                          ),
                          const Spacer(),
                          if (i == _index)
                            const Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: AppColors.ink,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (i != _palettes.length - 1)
                    const Divider(height: 1, color: AppColors.border),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Palette {
  const _Palette(this.name, this.colors);

  final String name;
  final List<Color> colors;
}
