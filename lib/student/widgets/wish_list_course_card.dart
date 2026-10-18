import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';

class WishListCourseCard extends StatelessWidget {
  final String courseName;
  final double price;
  final Color imageColor;

  const WishListCourseCard({
    super.key,
    required this.courseName,
    required this.price,
    required this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5D7C5), width: 1),
      ),
      child: Row(
        children: [
          // Course Image
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: imageColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 8),

          // Course Name and Favorite Icon
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  courseName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.largeTextColor,
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: const Icon(
                    Icons.favorite,
                    size: 12,
                    color: Color(0xFF718078),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // Course Price
          Text(
            '${price.toString()} \$',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
