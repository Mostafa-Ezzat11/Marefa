// enum CourseFileType {
//   pdf('PDF', 'PDF'),
//   zip('ZIP', 'ZIP'),
//   //Badge = DOC  <-->  File Extension = DOCX
//   doc('DOC', 'DOCX');
//
//   const CourseFileType(this.badge, this.fileExtension);
//
//   /// Short text shown inside the square badge.
//   final String badge;
//
//   /// Extension shown in the subtitle (e.g. "DOCX · 340 KB").
//   final String fileExtension;
// }
//
// class CourseFileModel {
//   const CourseFileModel({
//     required this.name,
//     required this.type,
//     required this.sizeInKb,
//     this.isDownloaded = false,
//     this.section,
//   });
//
//   final String name;
//   final CourseFileType type;
//   final int sizeInKb;
//   final bool isDownloaded;
//
//   /// Section the file belongs to (e.g. "Section 1 · Basics").
//   /// Null means the file belongs to the whole course.
//   final String? section;
//
//   String get sizeLabel => formatSize(sizeInKb);
//   bool get isDownloading => !isDownloaded && downloadProgress != null;
//
//
//   String get subtitle => '${type.fileExtension} · $sizeLabel';
//
//   static String formatSize(int kb) {
//     if (kb < 1024) return '$kb KB';
//     final mb = kb / 1024;
//     return '${mb.toStringAsFixed(mb >= 10 ? 0 : 1)} MB';
//   }
// }
//
// // =========== OK =========
enum CourseFileType {
  pdf('PDF', 'PDF'),
  zip('ZIP', 'ZIP'),
  //   //Badge = DOC  <-->  File Extension = DOCX
  doc('DOC', 'DOCX');
  const CourseFileType(this.badge, this.fileExtension);

  /// Short text shown inside the square badge.
  final String badge;

  /// Text shown in the subtitle (e.g. "DOCX · 340 KB", "Video · 24 MB").
  final String fileExtension;
}

class CourseFileModel {
  const CourseFileModel({
    required this.name,
    required this.type,
    required this.sizeInKb,
    this.isDownloaded = false,
    this.downloadProgress,
    this.section,
  });

  final String name;
  final CourseFileType type;
  final int sizeInKb;
  final bool isDownloaded;

  /// 0.0 to 1.0 while the file is downloading, otherwise null.
  final double? downloadProgress;

  /// Section the file belongs to (e.g. "Section 1 · Basics").
  /// Null means the file belongs to the whole course.
  final String? section;

  bool get isDownloading => !isDownloaded && downloadProgress != null;

  String get sizeLabel => formatSize(sizeInKb);

  String get subtitle => '${type.fileExtension} · $sizeLabel';

  static String formatSize(int kb) {
    if (kb < 1024) return '$kb KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(mb >= 10 ? 0 : 1)} MB';
  }
}