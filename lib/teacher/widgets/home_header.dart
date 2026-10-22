import 'package:flutter/material.dart';
import '../../constants.dart';

/// Top bar: logo + app name on the left, notification bell on the right.
class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const HomeHeader({super.key, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.menu_book_rounded,
              color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        const Text(
          'Marefa',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDarkColor,
          ),
        ),
        const Text(
          '.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.orangeColor,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onNotificationTap,
          icon: const Icon(Icons.notifications_none_rounded,
              color: AppColors.largeTextColor),
        ),
      ],
    );
  }
}
