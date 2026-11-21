import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course_file_model.dart';
import 'package:marefa/student/widgets/course_file_tile.dart';

/// "Course Materials" section for the course details screen.
class CourseMaterialsSection extends StatelessWidget {
  const CourseMaterialsSection({
    super.key,
    required this.files,
    this.onDownload,
  });

  final List<CourseFileModel> files;

  /// When null, a "coming soon" SnackBar is shown instead.
  final ValueChanged<CourseFileModel>? onDownload;

  void _handleDownload(BuildContext context, CourseFileModel file) {
    final callback = onDownload;
    if (callback != null) {
      callback(file);
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Downloads will be available soon')),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Materials',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.largeTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Download additional learning resources',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.largeTextColor.withValues(alpha: 0.6),
          ),
        ),

        const SizedBox(height: 12),

        for (final file in files)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CourseFileTile(
              file: file,
              onTap: file.isDownloaded
                  ? null
                  : () => _handleDownload(context, file),
            ),
          ),
      ],
    );
  }
}
