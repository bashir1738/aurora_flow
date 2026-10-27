import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/line_field.dart';
import '../widgets/reveal.dart';

class MotionScreen extends StatelessWidget {
  const MotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 140),
        children: [
          Reveal(child: Text('MOTION', style: theme.textTheme.labelSmall)),
          const SizedBox(height: 12),
          Reveal(
            delay: const Duration(milliseconds: 60),
            child: Text(
              'Motion',
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
              'Four sine lines drift across a single canvas. '
              'No particles, no noise.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 28),
          Reveal(
            delay: const Duration(milliseconds: 180),
            child: Container(
              height: 360,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: const LineField(),
            ),
          ),
          const SizedBox(height: 14),
          Reveal(
            delay: const Duration(milliseconds: 240),
            child: Row(
              children: [
                Text('4 lines', style: theme.textTheme.bodySmall),
                const Spacer(),
                Text('12s loop', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Reveal(
            delay: const Duration(milliseconds: 300),
            child: const Divider(height: 1, color: AppColors.border),
          ),
          const SizedBox(height: 20),
          Reveal(
            delay: const Duration(milliseconds: 340),
            child: Text(
              'Every line is a single sine function. Their phases move at '
              'slightly different speeds, which is enough to make the field '
              'feel alive.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
