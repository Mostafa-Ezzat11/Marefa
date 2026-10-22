import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';

/// A small rounded label such as "Beginner", "12 hours" or "Paid".
class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.primaryColor.withValues(alpha: 0.12)
            : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted ? Colors.transparent : AppColors.borderColor,
        ),
      ),

      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: highlighted
              ? AppColors.primaryColor
              : AppColors.largeTextColor,
        ),
      ),

    );
  }
}
