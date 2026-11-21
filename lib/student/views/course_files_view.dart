import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course_file_model.dart';
import 'package:marefa/student/widgets/course_file_tile.dart';
import 'package:marefa/student/widgets/filter_chip_bar.dart';
import 'package:marefa/student/widgets/home_search_bar.dart';

class CourseFilesView extends StatefulWidget {
  const CourseFilesView({
    super.key,
    required this.courseTitle,
    required this.files,
    this.onDownload,
    this.onDownloadAll,
  });

  final String courseTitle;
  final List<CourseFileModel> files;

  /// When null, a "coming soon" SnackBar is shown instead.
  final ValueChanged<CourseFileModel>? onDownload;
  final VoidCallback? onDownloadAll;

  @override
  State<CourseFilesView> createState() => _CourseFilesViewState();
}

class _CourseFilesViewState extends State<CourseFilesView> {
  static const List<String> _filters = ['All', 'PDF', 'Docs', 'Zip'];
  static const String _wholeCourseLabel = 'Course Materials';

  final TextEditingController _searchController = TextEditingController();
  int _filter = 0;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 2 Methods for Filtering
  bool _matchesFilter(CourseFileModel file) => switch (_filter) {
    1 => file.type == CourseFileType.pdf,
    2 => file.type == CourseFileType.doc,
    3 => file.type == CourseFileType.zip,
    _ => true,
  };

  Map<String, List<CourseFileModel>> _visibleGroups() {
    final query = _query.trim().toLowerCase();
    final groups = <String, List<CourseFileModel>>{};
    for (final file in widget.files) {
      if (!_matchesFilter(file)) continue;
      if (!file.name.toLowerCase().contains(query)) continue;
      // .putIfAbsent means that is the key doesn't exist so make the key and add it to the empty list, if not use the existing list
      groups.putIfAbsent(file.section ?? _wholeCourseLabel, () => []).add(file);
    }
    return groups;
  }

  /// 2 Methods for Downloading
  void _showComingSoon() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Downloads will be available soon')),
      );
  }

  void _handleDownload(CourseFileModel file) {
    final callback = widget.onDownload;
    if (callback == null) {
      _showComingSoon();
      return;
    }
    callback(file);
  }

  @override
  Widget build(BuildContext context) {
    final groups = _visibleGroups();
    final mutedText = AppColors.largeTextColor.withValues(alpha: 0.6);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            const Text(
              'Course Files',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.largeTextColor,
              ),
            ),

            Text(
              widget.courseTitle,
              style: TextStyle(fontSize: 13, color: mutedText),
            ),

            const SizedBox(height: 16),

            HomeSearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
            ),

            const SizedBox(height: 14),

            FilterChipBar(
              labels: _filters,
              selectedIndex: _filter,
              onSelected: (index) => setState(() => _filter = index),
            ),

            if (groups.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(
                  child: Text(
                    'No files found',
                    style: TextStyle(color: mutedText,fontSize: 24),
                  ),
                ),
              )
            else
              for (final entry in groups.entries) ...[
                const SizedBox(height: 20),

                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.largeTextColor,
                  ),
                ),

                const SizedBox(height: 12),

                for (final file in entry.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CourseFileTile(
                      file: file,
                      onTap: file.isDownloaded || file.isDownloading
                          ? null
                          : () => _handleDownload(file),
                    ),
                  ),
              ],
          ],
        ),
      ),
    );
  }
}

///=================    OK    ================