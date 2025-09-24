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
      home: const AnimationChainDemo(),
    );
  }
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
