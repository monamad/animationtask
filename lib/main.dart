import 'package:animationtask/dot_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Animation Chain',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LearnAnimations(),
    );
  }
}

class LearnAnimations extends StatefulWidget {
  const LearnAnimations({super.key});

  @override
  State<LearnAnimations> createState() => _LearnAnimationsState();
}

class _LearnAnimationsState extends State<LearnAnimations>
    with TickerProviderStateMixin {
  late final AnimationController _controllerDot1;
  late final AnimationController _controllerDot2;
  late final AnimationController _controllerDot3;
  final Duration duration = const Duration(milliseconds: 600);
  late DotAnimation dot1;
  late DotAnimation dot2;
  late DotAnimation dot3;
  final double dotSize = 8;
  final double maxDotSize = 25;
  final Color beginColor = Colors.blue.withValues(alpha: 0.3);
  final Color endColor = Colors.blue;

  @override
  void initState() {
    _controllerDot1 = AnimationController(duration: duration, vsync: this);
    _controllerDot2 = AnimationController(duration: duration, vsync: this);
    _controllerDot3 = AnimationController(duration: duration, vsync: this);
    dot1 = DotAnimation.create(
      _controllerDot1,
      dotSize,
      maxDotSize,
      beginColor,
      endColor,
    );
    dot2 = DotAnimation.create(
      _controllerDot2,
      dotSize,
      maxDotSize,
      beginColor,
      endColor,
    );
    dot3 = DotAnimation.create(
      _controllerDot3,
      dotSize,
      maxDotSize,
      beginColor,
      endColor,
    );
    startAnimation();

    dot1.controller.addListener(_dot1SizeListener);
    dot2.controller.addListener(_dot2SizeListener);
    dot3.controller.addStatusListener(_dot3SizeListener);
    super.initState();
  }

  void _dot1SizeListener() {
    if (dot1.sizeAnimation.value >= maxDotSize) {
      dot2.controller.forward();
    }
  }

  void _dot2SizeListener() {
    if (dot2.sizeAnimation.value >= maxDotSize) {
      dot3.controller.forward();
    }
  }

  void _dot3SizeListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      dot1.controller.reset();
      dot2.controller.reset();
      dot3.controller.reset();
      dot1.controller.forward();
    }
  }

  void startAnimation() {
    dot1.controller.forward();
  }

  @override
  void dispose() {
    dot1.sizeAnimation.removeListener(_dot1SizeListener);
    dot2.sizeAnimation.removeListener(_dot2SizeListener);
    dot3.sizeAnimation.removeStatusListener(_dot3SizeListener);

    _controllerDot1.dispose();
    _controllerDot2.dispose();
    _controllerDot3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(alignment: Alignment(-0.129, 0.0), child: buildDot(dot1)),
            Align(alignment: Alignment(0.0, 0.0), child: buildDot(dot2)),

            Align(alignment: Alignment(0.129, 0.0), child: buildDot(dot3)),
          ],
        ),
      ),
    );
  }
}

Widget buildDot(DotAnimation dotAnimation) {
  return AnimatedBuilder(
    animation: dotAnimation.controller,
    builder: (context, child) {
      return Container(
        width: dotAnimation.sizeAnimation.value,
        height: dotAnimation.sizeAnimation.value,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dotAnimation.colorAnimation.value,
        ),
      );
    },
  );
}

class AnimationChainDemo extends StatelessWidget {
  const AnimationChainDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Advanced Animation Chain')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            LoadingDotsAnimation(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class LoadingDotsAnimation extends StatefulWidget {
  const LoadingDotsAnimation({super.key});

  @override
  State<LoadingDotsAnimation> createState() => _LoadingDotsAnimationState();
}

class _LoadingDotsAnimationState extends State<LoadingDotsAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;

  static const int dotCount = 3;
  static const Duration animationDuration = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _scaleAnimations = List.generate(dotCount, (index) {
      final double startTime = index * 0.3;
      final double endTime = startTime + 0.4;

      return Tween<double>(begin: 0.5, end: 1.5).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(startTime, endTime, curve: Curves.easeInOut),
        ),
      );
    });

    _opacityAnimations = List.generate(dotCount, (index) {
      final double startTime = index * 0.3;
      final double endTime = startTime + 0.4;

      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(startTime, endTime, curve: Curves.easeInOut),
        ),
      );
    });

    _startAnimation();
  }

  void _startAnimation() {
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(dotCount, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Opacity(
                  opacity: _opacityAnimations[index].value,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: _getDotColor(index),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Color _getDotColor(int index) {
    const colors = [Colors.blue, Colors.blue, Colors.blue];
    return colors[index % colors.length];
  }
}
