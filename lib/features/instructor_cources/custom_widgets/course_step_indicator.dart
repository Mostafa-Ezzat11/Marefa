
import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';


class CourseStepIndicator extends StatelessWidget {
  final int currentStep;

  const CourseStepIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    const steps = [
      '1. Information',
      '2. Curriculum',
      '3. Publish',
    ];

    return Row(
      children: List.generate(steps.length, (index) {
        final isCurrent = index == currentStep;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == steps.length - 1 ? 0 : 6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.primaryDarkColor
                        : const Color(0xFFE4E4D9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isCurrent
                        ? AppColors.largeTextColor
                        : const Color(0xFF85877D),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
