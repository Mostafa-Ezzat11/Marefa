
import 'course_enums.dart';
import 'course_section_model.dart';

class InstructorCourseModel {
  final String id;
  final String title;
  final String category;
  final CourseLevel level;
  final String description;

  final List<CourseSectionModel> sections;

  final bool isFree;
  final double price;

  final int studentsCount;
  final CourseStatus status;

  final String? thumbnailUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const InstructorCourseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.description,
    this.sections = const [],
    required this.isFree,
    this.price = 0,
    this.studentsCount = 0,
    required this.status,
    this.thumbnailUrl,
    this.createdAt,
    this.updatedAt,
  });

  int get sectionsCount => sections.length;

  int get lessonsCount {
    return sections.fold(
      0,
      (total, section) => total + section.lessonsCount,
    );
  }

  String get displayPrice {
    if (isFree) return 'Free';
    return '\$${price.toStringAsFixed(2)}';
  }
}
