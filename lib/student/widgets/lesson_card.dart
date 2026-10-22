import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/lesson_model.dart';

class LessonCard extends StatelessWidget {
  LessonCard({super.key, required this.lesson, this.isSelected = false});

  final LessonModel lesson;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : null,
        border: BoxBorder.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        'Lesson ${lesson.id}: ${lesson.title} . ${lesson.duration}',
        style: TextStyle(
          fontSize: 16,
          color: isSelected ? Colors.white : null,
        ),
      ),
    );
  }
}
