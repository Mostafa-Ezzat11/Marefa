import 'course_lesson_model.dart';

class CourseSectionModel {
  final String id;
  final String title;
  final String description;
  final int orderIndex;
  final List<CourseLessonModel> lessons;

  const CourseSectionModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.orderIndex,
    this.lessons = const [],
  });

  int get lessonsCount => lessons.length;
}
