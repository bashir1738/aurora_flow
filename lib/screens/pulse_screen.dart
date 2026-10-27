import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
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
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 140),
        children: [
          Reveal(child: Text('PULSE', style: theme.textTheme.labelSmall)),
          const SizedBox(height: 12),
          Reveal(
            delay: const Duration(milliseconds: 60),
            child: Text(
              'Pulse',
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
              'A quiet circle that swells with every breath.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 28),
          Reveal(
            delay: const Duration(milliseconds: 180),
            child: Container(
              height: 380,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: _BreathingStage(running: _running),
            ),
          ),
          const SizedBox(height: 20),
          Reveal(
            delay: const Duration(milliseconds: 240),
            child: Row(
              children: [
                Text('Inhale 4s', style: theme.textTheme.bodySmall),
                const SizedBox(width: 18),
                Text('Hold 2s', style: theme.textTheme.bodySmall),
                const SizedBox(width: 18),
                Text('Exhale 6s', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Reveal(
            delay: const Duration(milliseconds: 300),
            child: PrimaryButton(
              label: _running ? 'Pause' : 'Resume',
              icon: _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
              onTap: () => setState(() => _running = !_running),
              expand: true,
            ),
          ),
          const SizedBox(height: 32),
          Reveal(
            delay: const Duration(milliseconds: 360),
            child: const Divider(height: 1, color: AppColors.border),
          ),
          const SizedBox(height: 20),
          Reveal(
            delay: const Duration(milliseconds: 400),
            child: Text(
              'The rings and the solid centre share one clock, so the whole '
              'scene inhales together.',
              style: theme.textTheme.bodySmall,
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
        Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final breath =
                  0.5 - 0.5 * math.cos(_controller.value * math.pi * 2);
              return SizedBox(
                width: 270,
                height: 270,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.96 + 0.04 * breath,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.97 + 0.03 * breath,
                      child: Container(
                        width: 172,
                        height: 172,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.ink.withValues(alpha: 0.14),
                          ),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.92 + 0.1 * breath,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 24,
          child: Text(
            widget.running ? 'BREATHING' : 'PAUSED',
            textAlign: TextAlign.center,
            style: const TextStyle(
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
