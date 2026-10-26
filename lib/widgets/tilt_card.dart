import 'package:flutter/material.dart';

/// Tilts its child in 3D toward the pointer (hover or drag).
class TiltCard extends StatefulWidget {
  const TiltCard({
    super.key,
    required this.child,
    this.maxTilt = 0.16,
    this.borderRadius = 32,
  });

  final Widget child;
  final double maxTilt;
  final double borderRadius;

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
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
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              builder: (context, tilt, child) {
                final matrix = Matrix4.identity()
                  ..setEntry(3, 2, 0.0014)
                  ..rotateX(-tilt.dy * widget.maxTilt)
                  ..rotateY(tilt.dx * widget.maxTilt);
                return Transform(
                  alignment: Alignment.center,
                  transform: matrix,
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}
