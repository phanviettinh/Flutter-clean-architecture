import 'dart:math';
import 'package:flutter/material.dart';

class ThemeRevealOverlay extends StatefulWidget {
  final Offset center;
  final bool darkMode;
  final Widget child;

  const ThemeRevealOverlay({
    super.key,
    required this.center,
    required this.darkMode,
    required this.child,
  });

  @override
  State<ThemeRevealOverlay> createState() => _ThemeRevealOverlayState();
}

class _ThemeRevealOverlayState extends State<ThemeRevealOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxRadius = sqrt(size.width * size.width + size.height * size.height);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipPath(
          clipper: _CircleClipper(
            center: widget.center,
            radius: _animation.value * maxRadius,
          ),
          child: Container(
            color: widget.darkMode
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.background,
          ),
        );
      },
    );
  }
}

class _CircleClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  _CircleClipper({required this.center, required this.radius});

  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(_CircleClipper oldClipper) => radius != oldClipper.radius;
}
