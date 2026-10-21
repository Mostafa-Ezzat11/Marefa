
import 'course_enums.dart';

class CourseLessonModel {
  final String id;
  final String title;
  final String description;
  final LessonContentType contentType;
  final String contentUrl;
  final String? fileName;
  final int orderIndex;

  const CourseLessonModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.contentType,
    required this.contentUrl,
    this.fileName,
    required this.orderIndex,
  });
}
