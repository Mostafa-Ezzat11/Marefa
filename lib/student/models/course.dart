class Course {
  const Course({
    required this.title,
    required this.price,
    this.completed = false,
    this.isFavorite = false,
    this.image,
  });

  // Course information
  final String title;
  final double price;

  // Course progress and status
  final bool completed;
  final bool isFavorite;

  // Course appearance

  /// Optional asset path. When null, a placeholder is shown.
  final String? image;

  // Formatted values
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

// String get formattedReviewCount => reviewCount >= 1000
// ? '${(reviewCount / 1000).toStringAsFixed(1)}k'
//     : '$reviewCount';
}