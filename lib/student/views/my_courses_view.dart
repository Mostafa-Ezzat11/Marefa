import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course_model.dart';
import 'package:marefa/student/widgets/tab_chip.dart';

List<Course> allCourses = [
  Course(
    title: 'Flutter Development',
    progress: 45,
    color: Color(0xFF1F6B4A),
  ),
  Course(
    title: 'Python for Beginners',
    progress: 20,
    color: Color(0xFFD9680F),
  ),
  Course(
    title: 'UI/UX Design',
    progress: 0,
    color: Color(0xFF3F9F78),
  ),
  Course(
    title: 'Dart Basics',
    progress: 100,
    completed: true,
    color: Color(0xFF2A7AB8),
  ),
];

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    List<Course> enrolled = [...allCourses];
    List<Course> completed = allCourses
        .where((c) => c.completed)
        .toList();
    List<Course> shown = showCompleted ? completed : enrolled;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'My Courses',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.largeTextColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                TabChip(
                  label: 'Enrolled (${enrolled.length})',
                  selected: !showCompleted,
                  onTap: () => setState(() => showCompleted = false),
                ),
                const SizedBox(width: 8),
                TabChip(
                  label: 'Completed (${completed.length})',
                  selected: showCompleted,
                  onTap: () => setState(() => showCompleted = true),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: shown.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: 16),
                itemBuilder: (_, i) => CourseItem(course: shown[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Course card + progress bar ----------
class CourseItem extends StatelessWidget {
  final Course course;

  const CourseItem({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor),
          ),

          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: course.color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Progress: ${course.progress}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: course.progress / 100,
            minHeight: 5,
            backgroundColor: AppColors.borderColor,
            valueColor: AlwaysStoppedAnimation(
              course.completed
                  ? AppColors.primaryColor
                  : AppColors.orangeColor,
            ),
          ),
        ),
      ],
    );
  }
}
