import 'package:flutter/material.dart';
import '../../contents/colors.dart';
import '../../contents/textstyles.dart';
import '../../core/extensions/extensions.dart';

/// Design System Compliant Search Bar
/// Follows the design system guidelines exactly
class DesignSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onFilterTap;

  const DesignSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
  });

  @override
  State<DesignSearchBar> createState() => _DesignSearchBarState();
}

class _DesignSearchBarState extends State<DesignSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Using extensions.dart directly
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: AppTextStyles.bodyMedium(
          color: AppColors.primaryDark,
        ).copyWith(
          fontSize: context.responsive(14),
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.bodyMedium(
            color: AppColors.primaryDark.withValues(alpha: 0.5),
          ).copyWith(
            fontSize: context.responsive(14),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.grey,
            size: context.responsive(24),
          ),
          suffixIcon: widget.onFilterTap != null
              ? IconButton(
                  icon: Icon(
                    Icons.tune_rounded,
                    color: AppColors.grey,
                    size: context.responsive(20),
                  ),
                  onPressed: widget.onFilterTap,
                )
              : widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: AppColors.grey,
                        size: context.responsive(20),
                      ),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onChanged?.call('');
                      },
                    )
                  : null,
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.lightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.secondaryPurple,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.responsive(16),
            vertical: context.responsive(12),
          ),
        ),
      ),
    );
  }
}
