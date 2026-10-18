import 'dart:ui';

class Course {
  final String title;
  final int progress;
  final bool completed;
  final Color color;
  final bool isFavorite;

  const Course({
    required this.title,
    required this.progress,
    required this.color,
    this.completed = false,
    this.isFavorite = false,
  });
}
