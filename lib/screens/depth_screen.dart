import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reveal.dart';

class DepthScreen extends StatelessWidget {
  const DepthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const layers = <_Layer>[
      _Layer('Foreground', '1.0×'),
      _Layer('Midground', '0.6×'),
      _Layer('Background', '0.3×'),
      _Layer('Horizon', '0.1×'),
    ];

    return SafeArea(
      bottom: false,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 140),
        children: [
          Reveal(child: Text('DEPTH', style: theme.textTheme.labelSmall)),
          const SizedBox(height: 12),
          Reveal(
            delay: const Duration(milliseconds: 60),
            child: Text(
              'Depth',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 36,
                letterSpacing: -1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Reveal(
            delay: const Duration(milliseconds: 120),
            child: Text(
              'Three flat planes that shift at different speeds as you drag.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 28),
          Reveal(
            delay: const Duration(milliseconds: 180),
            child: Container(
              height: 400,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: const _ParallaxStage(),
            ),
          ),
          const SizedBox(height: 14),
          Reveal(
            delay: const Duration(milliseconds: 240),
            child: Text('Drag to tilt', style: theme.textTheme.bodySmall),
          ),
          const SizedBox(height: 36),
          Reveal(
            delay: const Duration(milliseconds: 300),
            child: const Divider(height: 1, color: AppColors.border),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < layers.length; i++)
            Reveal(
              delay: Duration(milliseconds: 340 + i * 50),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Text(
                          layers[i].label,
                          style: theme.textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          layers[i].multiplier,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (i != layers.length - 1)
                    const Divider(height: 1, color: AppColors.border),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Layer {
  const _Layer(this.label, this.multiplier);

  final String label;
  final String multiplier;
}

class _ParallaxStage extends StatefulWidget {
  const _ParallaxStage();

  @override
  State<_ParallaxStage> createState() => _ParallaxStageState();
}

class _ParallaxStageState extends State<_ParallaxStage> {
  Offset _target = Offset.zero;

  void _update(Offset position, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final nx = ((position.dx / size.width) * 2 - 1).clamp(-1.0, 1.0);
    final ny = ((position.dy / size.height) * 2 - 1).clamp(-1.0, 1.0);
    setState(() => _target = Offset(nx, ny));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return MouseRegion(
          onHover: (event) => _update(event.localPosition, size),
          onExit: (_) => setState(() => _target = Offset.zero),
          child: GestureDetector(
            onPanUpdate: (details) => _update(details.localPosition, size),
            onPanEnd: (_) => setState(() => _target = Offset.zero),
            onPanCancel: () => setState(() => _target = Offset.zero),
            child: TweenAnimationBuilder<Offset>(
              tween: Tween<Offset>(end: _target),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOut,
              builder: (context, tilt, _) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _Plane(
                      inset: 22,
                      color: AppColors.surfaceMuted,
                      shift: tilt * 7,
                    ),
                    _Plane(
                      inset: 46,
                      color: AppColors.surface,
                      shift: tilt * 14,
                    ),
                    _Plane(
                      inset: 70,
                      color: AppColors.ink,
                      shift: tilt * 22,
                      foreground: true,
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _Plane extends StatelessWidget {
  const _Plane({
    required this.inset,
    required this.color,
    required this.shift,
    this.foreground = false,
  });

  final double inset;
  final Color color;
  final Offset shift;
  final bool foreground;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(inset),
        child: Transform.translate(
          offset: shift,
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: foreground ? color : AppColors.border),
            ),
            child: Text(
              foreground ? 'Foreground' : '',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: foreground ? Colors.white : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
