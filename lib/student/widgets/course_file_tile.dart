import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course_file_model.dart';

// Colors used only by file tiles; kept here so the shared AppColors stays untouched.
const Color _pdfBackground = Color(0xFFF6D9D9);
const Color _pdfForeground = Color(0xFFB3363A);
const Color _zipBackground = Color(0xFFF1E8C8);
const Color _zipForeground = Color(0xFF7A6A1F);

/// One file row: type badge, name, "TYPE · size" and a download status icon.
class CourseFileTile extends StatelessWidget {
  const CourseFileTile({super.key, required this.file, this.onTap});

  final CourseFileModel file;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _TypeBadge(type: file.type),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.largeTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      file.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.largeTextColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _DownloadStatus(isDownloaded: file.isDownloaded),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final CourseFileType type;

  (Color, Color) get _colors => switch (type) {
    CourseFileType.pdf => (_pdfBackground, _pdfForeground),
    CourseFileType.zip => (_zipBackground, _zipForeground),
    CourseFileType.doc => (
    AppColors.primaryColor.withValues(alpha: 0.15),
    AppColors.primaryColor,
    ),
  };

  @override
  Widget build(BuildContext context) {

    final (background, foreground) = _colors;

    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        type.badge,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: foreground,
        ),
      ),
    );
  }
}

class _DownloadStatus extends StatelessWidget {
  const _DownloadStatus({required this.isDownloaded});

  final bool isDownloaded;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isDownloaded ? 'Downloaded' : 'Not downloaded',
      child: ExcludeSemantics(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDownloaded
                ? AppColors.primaryColor
                : AppColors.primaryColor.withValues(alpha: 0.15),
          ),
          child: Icon(
            isDownloaded ? Icons.check_rounded : Icons.download_rounded,
            size: 20,
            color: isDownloaded ? Colors.white : AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}