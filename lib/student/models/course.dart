import 'package:marefa/student/models/lesson_model.dart';
import 'package:marefa/student/models/course_file_model.dart';

class Course {
  const Course({
    required this.title,
    required this.price,
    this.completed = false,
    this.isFavorite = false,
    this.image,
    this.tag,
    this.rating,
    this.reviewCount,
    this.level,
    this.durationHours,
    this.instructorName,
    this.instructorTitle,
    this.instructorImage,
    this.description,
    this.sectionCount,
    this.lessons = const [],
    this.files = const [],
  });

  // Course information
  final String title;
  final double price;

  // Course progress and status
  final bool completed;
  final bool isFavorite;

  // Course appearance
  final String? image;
  final String? tag;

  // Ratings
  final double? rating;
  final int? reviewCount;

  // Details view information
  final String? level;
  final int? durationHours;
  final String? instructorName;
  final String? instructorTitle;
  final String? instructorImage;
  final String? description;
  final int? sectionCount;

  // Course content
  final List<LessonModel> lessons;
  final List<CourseFileModel> files;

  // Formatted values
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  String get priceLabel => price == 0 ? 'Free' : 'Paid';

  String? get durationLabel =>
      durationHours == null ? null : '$durationHours hours';

// bool get hasRating => rating != null && reviewCount != null;

// String get formattedReviewCount {
//   final count = reviewCount ?? 0;
//   if (count < 1000) return '$count';
//   final thousands = (count / 1000).toStringAsFixed(1);
//   final trimmed = thousands.endsWith('.0')
//       ? thousands.substring(0, thousands.length - 2)
//       : thousands;
//   return '${trimmed}k';
// }
}