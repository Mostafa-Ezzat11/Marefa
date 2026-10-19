import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';

class TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const TabChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor
              : AppColors.primaryColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}