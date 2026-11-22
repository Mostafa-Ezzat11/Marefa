import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course_category.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    this.onTap,
    this.isSelected = false,
  });

  final CourseCategory category;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: category.backgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: isSelected
                  ? Border.all(
                      color: category.iconColor.withValues(alpha: 1),
                      width: 3,
                    )
                  : null,
            ),
            child: Icon(category.icon, color: category.iconColor, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: AppColors.largeTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
