import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';

/// Five stars filled according to [rating] (supports half stars).
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.color = AppColors.orangeColor,
  });

  final double rating;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Rating ${rating.toStringAsFixed(1)} out of 5',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final IconData icon;
            if (rating >= index + 1) {
              icon = Icons.star_rounded;
            } else if (rating >= index + 0.5) {
              icon = Icons.star_half_rounded;
            } else {
              icon = Icons.star_outline_rounded;
            }
            return Icon(icon, size: size, color: color);
          }),
        ),
      ),
    );
  }
}
