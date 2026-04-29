// lib/core/widgets/cartoon_character.dart

import 'package:flutter/material.dart';
import '../../contents/colors.dart';

// Cute Cartoon Character Widget (inspired by Headspace design)
class CartoonCharacter extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final IconData icon;
  final bool animated;

  const CartoonCharacter({
    super.key,
    this.size = 80,
    this.backgroundColor = AppColors.accentPink,
    this.icon = Icons.favorite_rounded,
    this.animated = true,
  });

  @override
  State<CartoonCharacter> createState() => _CartoonCharacterState();
}

class _CartoonCharacterState extends State<CartoonCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.animated) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.backgroundColor.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              color: AppColors.white,
              size: widget.size * 0.5,
            ),
          ),
        );
      },
    );
  }
}

