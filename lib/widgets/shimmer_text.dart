import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Text with a light band that sweeps across it forever.
class ShimmerText extends StatefulWidget {
  const ShimmerText(this.text, {super.key, required this.style, this.duration});

  final String text;
  final TextStyle? style;
  final Duration? duration;

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(seconds: 4),
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
        final slide = _controller.value * 4 - 1.5;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment(slide - 1, -0.4),
            end: Alignment(slide + 1, 0.4),
            colors: const [
              Color(0xFFF4F1FF),
              AppColors.cyan,
              AppColors.pink,
              Color(0xFFF4F1FF),
            ],
            stops: const [0, 0.35, 0.6, 1],
          ).createShader(rect),
          child: Text(widget.text, style: widget.style),
        );
      },
    );
  }
}
