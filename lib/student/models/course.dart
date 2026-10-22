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
  });

  // Course information
  final String title;
  final double price;

  // Course progress and status
  final bool completed;
  final bool isFavorite;

  // Course appearance

  /// Optional asset path (thumbnail in lists, header on the details screen).
  /// When null, a placeholder is shown.
  final String? image;

  /// Optional highlight label shown above the title (e.g. "2x best").
  final String? tag;

  // Ratings (null when the course has none to show)
  final double? rating;
  final int? reviewCount;

  // Details screen information (all optional: lists don't need them)
  final String? level;
  final int? durationHours;
  final String? instructorName;
  final String? instructorTitle;

  /// Optional asset path for the instructor's photo.
  final String? instructorImage;
  final String? description;
  final int? sectionCount;

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