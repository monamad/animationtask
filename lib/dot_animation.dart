import 'package:flutter/material.dart';

class DotAnimation {
  final Animation<double> _sizeAnimation;
  final Animation<Color?> _colorAnimation;
  final AnimationController _controller;
  DotAnimation(this._sizeAnimation, this._colorAnimation, this._controller);
  factory DotAnimation.create(
    AnimationController controller,
    double beginSize,
    double endSize,
    Color beginColor,
    Color endColor,
  ) {
    final sizeAnimation = Tween<double>(begin: beginSize, end: endSize).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0, 1, curve: Curves.easeOutBack),
      ),
    );
    final colorAnimation = ColorTween(
      begin: beginColor,
      end: endColor,
    ).animate(CurvedAnimation(parent: controller, curve: Interval(0, .8)));

    return DotAnimation(sizeAnimation, colorAnimation, controller);
  }

  Animation<double> get sizeAnimation => _sizeAnimation;
  Animation<Color?> get colorAnimation => _colorAnimation;
  AnimationController get controller => _controller;
}
