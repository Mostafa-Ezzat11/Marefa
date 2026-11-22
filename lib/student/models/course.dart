import 'package:marefa/student/models/lesson_model.dart';
import 'package:marefa/student/models/course_file_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  const Course({
    this.id = '',
    required this.title,
    required this.price,
    this.categoryId,
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
  final String id;
  final String title;
  final double price;
  final String? categoryId;

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
  factory Course.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;

    return Course(
      id: doc.id,
      title: data['title'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      categoryId: data['categoryId'],
      image: data['imageUrl'],
      description: data['description'],
      instructorName: data['instructorName'],
      instructorTitle: data['instructorTitle'],
      instructorImage: data['instructorImage'],
      rating: (data['rating'] as num?)?.toDouble(),
      reviewCount: (data['reviewCount'] as num?)?.toInt(),
      level: data['level'],
      durationHours: (data['durationHours'] as num?)?.toInt(),
      sectionCount: (data['sectionCount'] as num?)?.toInt(),
    );
  }
}