
import 'package:flutter/material.dart';
import '../models/course_enums.dart';

class CourseStatusChip extends StatelessWidget {
  final CourseStatus status;

  const CourseStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    late String title;
    late Color backgroundColor;
    late Color textColor;

    switch (status) {
      case CourseStatus.published:
        title = 'Published';
        backgroundColor = const Color(0xFFE4EBDD);
        textColor = const Color(0xFF315B42);
        break;

      case CourseStatus.draft:
        title = 'Draft';
        backgroundColor = const Color.fromARGB(255, 249, 208, 205);
        textColor = const Color.fromARGB(255, 183, 14, 14);
        break;

      case CourseStatus.inReview:
        title = 'In review';
        backgroundColor = const Color(0xFFF8EBD6);
        textColor = const Color(0xFF9C651F);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
