import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course.dart';
import 'package:marefa/student/models/course_file_model.dart';
import 'package:marefa/student/models/lesson_model.dart';
import 'package:marefa/student/services/course_service.dart';
import 'package:marefa/student/services/favorite_service.dart';
import 'package:marefa/student/widgets/content_tab_switcher.dart';
import 'package:marefa/student/widgets/course_materials_section.dart';
import 'package:marefa/student/widgets/info_chip.dart';
import 'package:marefa/student/widgets/instructor_tile.dart';
import 'package:marefa/student/widgets/lesson_card.dart';

class CourseDetailsView extends StatefulWidget {
  const CourseDetailsView({super.key, required this.course, this.onAddToCart});

  final Course course;
  final VoidCallback? onAddToCart ;

  @override
  State<CourseDetailsView> createState() => _CourseDetailsViewState();
}

//////////////////////////////////////////////////////////////////////////

class _CourseDetailsViewState extends State<CourseDetailsView> {
  final CourseService _courseService = CourseService();

  late Future<({List<LessonModel> lessons, List<CourseFileModel> files})>
  _contentFuture;

  final FavoriteService _favoriteService = FavoriteService();

  bool _isFavorite = false;
  bool _isFavoriteLoading = true;
  bool _isFavoriteUpdating = false;

  @override
  void initState() {
    super.initState();

    _contentFuture = _courseService.fetchCourseContent(widget.course.id);
    _loadFavoriteStatus();
  }

  /// 0 = Videos, 1 = Course Files.
  int _switcherTabIndex = 0;

  /// Stores the selected lesson index.
  int _selectedLessonIndex = 0;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final mutedText = AppColors.largeTextColor.withValues(alpha: 0.6);
    final level = course.level;
    final duration = course.durationLabel;
    final instructorName = course.instructorName;
    final description = course.description;

    return Scaffold(
      body: Column(
        children: [
          // Image of course
          _Header(imageAsset: course.image),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            color: AppColors.largeTextColor,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      IconButton(
                        onPressed: _isFavoriteLoading || _isFavoriteUpdating
                            ? null
                            : _toggleFavorite,
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite
                              ? Colors.red
                              : AppColors.largeTextColor,
                          size: 26,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      if (level != null)
                        InfoChip(label: level, highlighted: true),
                      if (duration != null) InfoChip(label: duration),
                      InfoChip(label: course.priceLabel),
                    ],
                  ),

                  if (instructorName != null) ...[
                    const SizedBox(height: 20),
                    InstructorTile(
                      name: instructorName,
                      title: course.instructorTitle ?? '',
                      avatarAsset: course.instructorImage,
                    ),
                  ],

                  if (description != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: mutedText,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Switcher Header
                  _buildCourseContent(),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed:(){},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text('Unlock Your Potential • ${course.formattedPrice}'),
            ),
          ),
        ),
      ),
    );
  }

  //==========    Methods    ============

  Future<void> _loadFavoriteStatus() async {
    try {
      final isFavorite = await _favoriteService.isFavorite(widget.course.id);

      if (!mounted) return;

      setState(() {
        _isFavorite = isFavorite;
        _isFavoriteLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isFavoriteLoading = false;
      });

      debugPrint('Failed to load favorite status: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isFavoriteUpdating) return;

    final previousValue = _isFavorite;
    final newValue = !previousValue;

    setState(() {
      _isFavorite = newValue;
      _isFavoriteUpdating = true;
    });

    try {
      if (newValue) {
        await _favoriteService.addFavorite(widget.course.id);
      } else {
        await _favoriteService.removeFavorite(widget.course.id);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isFavorite = previousValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update favorites. Please try again.'),
        ),
      );

      debugPrint('Favorite update error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isFavoriteUpdating = false;
        });
      }
    }
  }

  Widget _buildCourseContent() {
    return FutureBuilder<
      ({List<LessonModel> lessons, List<CourseFileModel> files})
    >(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                const Text(
                  'Failed to load course content',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _contentFuture = _courseService.fetchCourseContent(
                        widget.course.id,
                      );
                    });
                  },
                  child: const Text(
                    'Try Again',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }

        final lessons = snapshot.data!.lessons;
        final files = snapshot.data!.files;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentTabSwitcher(
              selectedIndex: _switcherTabIndex,
              onChanged: (index) {
                setState(() => _switcherTabIndex = index);
              },
              videoCount: lessons.length,
              fileCount: files.length,
            ),

            const SizedBox(height: 16),

            if (_switcherTabIndex == 0)
              if (lessons.isEmpty)
                const Center(child: Text('No lessons available yet.'))
              else
                for (var i = 0; i < lessons.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLessonIndex = i;
                        });
                      },
                      child: LessonCard(
                        lesson: lessons[i],
                        isSelected: _selectedLessonIndex == i,
                      ),
                    ),
                  )
            else if (files.isEmpty)
              const Center(child: Text('No files available yet.'))
            else
              CourseMaterialsSection(files: files),
          ],
        );
      },
    );
  }

}

// Course image (or a placeholder) with a back button on top.
class _Header extends StatelessWidget {
  const _Header({this.imageAsset});

  final String? imageAsset;

  static const double _imageHeight = 180;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final asset = imageAsset;

    return SizedBox(
      height: _imageHeight + topInset,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryDarkColor, AppColors.primaryColor],
              ),
            ),
          ),
          if (asset != null)
            Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            )
          else
            const Center(
              child: Icon(
                Icons.school_outlined,
                size: 72,
                color: Colors.white24,
              ),
            ),
          Positioned(
            top: topInset + 8,
            left: 12,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black26,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//==========    OK    ============
