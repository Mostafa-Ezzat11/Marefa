import 'dart:ui';

class Course {
  final String title;
  final int progress;
  final bool completed;
  final Color color;

  const Course({
    required this.title,
    required this.progress,
    required this.color,
    this.completed = false,
  });
}
