import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../constants.dart';


/// Simple animated bar chart. The highest bar is highlighted.
class EarningsBarChart extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final double barAreaHeight;

  const EarningsBarChart({
    super.key,
    required this.labels,
    required this.values,
    this.barAreaHeight = 150,
  }) : assert(labels.length == values.length);

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce(math.max);
    final highlightIndex = values.indexOf(maxValue);

    return SizedBox(
      height: barAreaHeight + 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final isHighlighted = i == highlightIndex;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    height: barAreaHeight * values[i] / maxValue,
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? AppColors.primaryColor
                          : AppColors.primaryColor.withAlpha(90),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[i],
                    maxLines: 1,
                    style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
