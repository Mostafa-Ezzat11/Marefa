import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';

class InstructorTile extends StatelessWidget {
  const InstructorTile({
    super.key,
    required this.name,
    required this.title,
    this.avatarAsset,
  });

  final String name;
  final String title;
  final String? avatarAsset;

  static const double _avatarSize = 44;

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: AppColors.backgroundColor,
      child: Icon(Icons.person_rounded,
      color: AppColors.primaryColor),
    );
    final asset = avatarAsset;

    return Row(
      children: [
        ClipOval(
          child: SizedBox(
            width: _avatarSize,
            height: _avatarSize,
            child: asset == null
                ? placeholder
                : Image.asset(
                    asset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => placeholder,
                  ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.largeTextColor,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.largeTextColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
