class CoursePdfModel {
  final String name;
  final String size;
  final String? description;

  const CoursePdfModel({
    required this.name,
    required this.size,
    this.description,
  });
}
