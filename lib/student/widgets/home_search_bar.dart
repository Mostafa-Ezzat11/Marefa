import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.showFilterIcon = false,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  /// When true, the field doesn't open the keyboard; use with [onTap].
  final bool readOnly;

  /// Shows the filter icon on the right.
  final bool showFilterIcon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.25),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 14, color: AppColors.largeTextColor),
        cursorColor: AppColors.primaryColor,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.largeTextColor,
          ),
          suffixIcon: showFilterIcon
              ? const Icon(Icons.tune_rounded, color: AppColors.largeTextColor)
              : null,
          hintText: 'Search courses...',
          hintStyle: TextStyle(
            color: AppColors.largeTextColor.withValues(alpha: 0.65),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
