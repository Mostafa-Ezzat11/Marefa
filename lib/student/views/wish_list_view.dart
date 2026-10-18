import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/widgets/wish_list_course_card.dart';

class WishListView extends StatelessWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'My Wishlist',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.largeTextColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),

            WishListCourseCard(
              courseName: 'Machine Learning Basics',
              price: 50,
              imageColor: AppColors.primaryDarkColor,
            ),

            WishListCourseCard(
              courseName: 'Machine Learning Basics',
              price: 50,
              imageColor: AppColors.primaryColor,
            ),

            WishListCourseCard(
              courseName: 'Machine Learning Basics',
              price: 50,
              imageColor: AppColors.orangeColor,
            ),
          ],
        ),
      ),
    );
  }
}
