// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CircularImageAnimation extends StatefulWidget {
  const CircularImageAnimation({
    super.key,
    this.wigetAnimation,
  });

  final Widget? wigetAnimation;
  @override
  State<CircularImageAnimation> createState() => _CircularImageAnimationState();
}

class _CircularImageAnimationState extends State<CircularImageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    animationController.forward();
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(animationController),
      child: widget.wigetAnimation,
    );
  }
}
