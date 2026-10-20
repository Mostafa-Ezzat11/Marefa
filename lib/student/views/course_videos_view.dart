import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/lesson_model.dart';
import 'package:marefa/student/widgets/lesson_card.dart';

class CourseVideosView extends StatelessWidget {
  const CourseVideosView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity, height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryDarkColor,
                borderRadius: BorderRadius.circular(12),
              ),
              height: 180,
              width: 330,
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),

            Divider(),

            LessonCard(
              lesson: LessonModel(
                id: 1,
                title: 'introduction',
                duration: '15:6',
              ),
            ),

            LessonCard(
              lesson: LessonModel(
                id: 2,
                title: 'State Managment',
                duration: '16:45',
              ),
            ),

            LessonCard(
              lesson: LessonModel(
                id: 3,
                title: 'Navigation ',
                duration: '14:36',
              ),
              isSelected: true,
            ),

            LessonCard(
              lesson: LessonModel(
                id: 4,
                title: 'Widgets',
                duration: '12:33',
              ),
            ),
          ],
        ),
      ),
    );
  }
}