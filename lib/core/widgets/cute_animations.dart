// lib/core/widgets/cute_animations.dart

import 'package:flutter/material.dart';
import '../../contents/colors.dart';

// Sparkle Animation Widget
class SparkleAnimation extends StatefulWidget {
  final int count;
  final double size;
  final Color color;
  final Duration duration;

  const SparkleAnimation({
    super.key,
    this.count = 5,
    this.size = 20,
    this.color = AppColors.accentPurple,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<SparkleAnimation> createState() => _SparkleAnimationState();
}

class _SparkleAnimationState extends State<SparkleAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _rotations;
  late List<Animation<double>> _scales;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.count,
      (index) => AnimationController(
        duration: Duration(
          milliseconds: widget.duration.inMilliseconds + (index * 300),
        ),
        vsync: this,
      ),
    );

    _rotations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.linear),
      );
    }).toList();

    _scales = _controllers.map((controller) {
      return TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.2), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.5), weight: 1),
      ]).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    for (var controller in _controllers) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.count, (index) {
        return Positioned(
          left: (index * 25.0) % 100,
          top: (index * 30.0) % 150,
          child: AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotations[index].value * 2 * 3.14159,
                child: Transform.scale(
                  scale: _scales[index].value,
                  child: Icon(
                    Icons.star_rounded,
                    size: widget.size,
                    color: widget.color.withValues(alpha: 0.4 + (_scales[index].value * 0.3)),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

// Walking Cat Animation Widget
class WalkingCatAnimation extends StatefulWidget {
  final double size;
  final Duration duration;

  const WalkingCatAnimation({
    super.key,
    this.size = 40,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<WalkingCatAnimation> createState() => _WalkingCatAnimationState();
}

class _WalkingCatAnimationState extends State<WalkingCatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _position = Tween<double>(begin: -50, end: 50).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _bounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
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
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_position.value, _bounce.value),
          child: Transform.scale(
            scale: _position.value < 0 ? 1.0 : -1.0,
            child: Icon(
              Icons.pets_rounded,
              size: widget.size,
              color: AppColors.accentPink,
            ),
          ),
        );
      },
    );
  }
}

// Floating Hearts Animation
class FloatingHeartsAnimation extends StatefulWidget {
  final int count;
  final Duration duration;

  const FloatingHeartsAnimation({
    super.key,
    this.count = 3,
    this.duration = const Duration(milliseconds: 3000),
  });

  @override
  State<FloatingHeartsAnimation> createState() => _FloatingHeartsAnimationState();
}

class _FloatingHeartsAnimationState extends State<FloatingHeartsAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _positions;
  late List<Animation<double>> _opacities;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.count,
      (index) => AnimationController(
        duration: Duration(
          milliseconds: widget.duration.inMilliseconds + (index * 500),
        ),
        vsync: this,
      ),
    );

    _positions = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: -100.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    _opacities = _controllers.map((controller) {
      return TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 0.3),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.7),
      ]).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    for (var controller in _controllers) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.count, (index) {
        return Positioned(
          left: (index * 30.0) % 80,
          bottom: 0,
          child: AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _positions[index].value),
                child: Opacity(
                  opacity: _opacities[index].value,
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 16,
                    color: AppColors.accentPink.withValues(alpha: 0.6),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

