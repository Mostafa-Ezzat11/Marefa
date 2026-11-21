import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course_file_model.dart';
import 'package:marefa/student/widgets/course_file_tile.dart';

// Dark orange used for text on the soft orange banner.
// Kept here so the shared AppColors stays untouched.
const Color _darkOrange = Color(0xFF9A4F0C);

/// "Course Files" tab: info banner, download summary and files grouped
/// by section.
class CourseFilesTab extends StatelessWidget {
  const CourseFilesTab({
    super.key,
    required this.files,
    this.onDownload,
    this.onDownloadAll,
  });

  final List<CourseFileModel> files;

  /// When null, a "coming soon" SnackBar is shown instead.
  final ValueChanged<CourseFileModel>? onDownload;
  final VoidCallback? onDownloadAll;

  static const String _wholeCourseLabel = 'Course Materials';

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Downloads will be available soon')),
      );
  }

  void _handleDownload(BuildContext context, CourseFileModel file) {
    final callback = onDownload;
    if (callback == null) {
      _showComingSoon(context);
      return;
    }
    callback(file);
  }

  void _handleDownloadAll(BuildContext context) {
    final callback = onDownloadAll;
    if (callback == null) {
      _showComingSoon(context);
      return;
    }
    callback();
  }

  Map<String, List<CourseFileModel>> _groupBySection() {
    final groups = <String, List<CourseFileModel>>{};
    for (final file in files) {
      groups.putIfAbsent(file.section ?? _wholeCourseLabel, () => []).add(file);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupBySection();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const _InfoBanner(),
        const SizedBox(height: 12),
        _DownloadSummaryCard(
          files: files,
          onDownloadAll: () => _handleDownloadAll(context),
        ),
        for (final entry in groups.entries) ...[
          const SizedBox(height: 20),
          _SectionLabel(entry.key),
          const SizedBox(height: 12),
          for (final file in entry.value)
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
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.orangeColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.push_pin_outlined,
              size: 20,
              color: AppColors.orangeColor,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Files for the whole course',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _darkOrange,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Not tied to a single video. Available anytime.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: _darkOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadSummaryCard extends StatelessWidget {
  const _DownloadSummaryCard({
    required this.files,
    required this.onDownloadAll,
  });

  final List<CourseFileModel> files;
  final VoidCallback onDownloadAll;

  @override
  Widget build(BuildContext context) {
    final totalKb = files.fold<int>(0, (sum, file) => sum + file.sizeInKb);
    final downloaded = files.where((file) => file.isDownloaded).length;
    final count = files.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryColor, AppColors.primaryDarkColor],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count file${count == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${CourseFileModel.formatSize(totalKb)} · $downloaded downloaded',
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: onDownloadAll,
            icon: const Icon(
              Icons.download_rounded,
              size: 18,
              color: AppColors.primaryColor,
            ),
            label: const Text('Download all'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.largeTextColor,
              elevation: 0,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.largeTextColor,
      ),
    );
  }
}