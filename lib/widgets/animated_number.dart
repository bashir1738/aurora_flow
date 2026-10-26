import 'package:flutter/material.dart';

/// Counts up from zero to [value] with an ease-out curve.
class AnimatedNumber extends StatelessWidget {
  const AnimatedNumber({
    super.key,
    required this.value,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.decimals = 0,
    this.duration = const Duration(milliseconds: 1800),
  });

  final double value;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final int decimals;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) {
        return Text(
          '$prefix${_format(animated)}$suffix',
          style: style,
        );
      },
    );
  }

  String _format(double v) {
    final fixed = v.toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final integer = parts.first;
    final grouped = integer.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]},',
    );
    return parts.length > 1 ? '$grouped.${parts.last}' : grouped;
  }
}
