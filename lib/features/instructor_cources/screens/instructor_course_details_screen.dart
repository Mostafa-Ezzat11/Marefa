import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/features/instructor_cources/custom_widgets/course_action_button.dart';
import '../models/instructor_course_model.dart';
import '../models/course_enums.dart';
import '../custom_widgets/course_status_chip.dart';

class InstructorCourseDetailsScreen extends StatelessWidget {
  final InstructorCourseModel course;

  const InstructorCourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),

              _buildCourseImage(),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCourseInfo(),

                    const SizedBox(height: 22),

                    _buildStatistics(),

                    const SizedBox(height: 24),

                    _buildDescription(),

                    const SizedBox(height: 24),

                    _buildCourseContent(),

                    const SizedBox(height: 25),

                    _buildButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: AppColors.primaryDarkColor,
          ),

          Expanded(
            child: Text(
              "Course Details",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.largeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Course image
  Widget _buildCourseImage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(
        color: const Color(0xFFDCE8E0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                course.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
              ),
            )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return const Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: 65,
        color: AppColors.primaryColor,
      ),
    );
  }

  // Course information
  Widget _buildCourseInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: AppColors.largeTextColor,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          '${course.category}  •  '
          '${_getLevelName()}  •  '
          '${course.lessonsCount} lessons',
          style: const TextStyle(fontSize: 12, color: Color(0xFF85877D)),
        ),

        const SizedBox(height: 12),

        CourseStatusChip(status: course.status),
      ],
    );
  }

  String _getLevelName() {
    if (course.level == CourseLevel.beginner) {
      return 'Beginner';
    } else if (course.level == CourseLevel.intermediate) {
      return 'Intermediate';
    } else {
      return 'Advanced';
    }
  }

  // Statistics
  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _buildStatisticCard(
            icon: Icons.people_outline,
            value: course.studentsCount.toString(),
            title: 'Students',
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _buildStatisticCard(
            icon: Icons.play_lesson_outlined,
            value: course.lessonsCount.toString(),
            title: 'Lessons',
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _buildStatisticCard(
            icon: Icons.folder_outlined,
            value: course.sectionsCount.toString(),
            title: 'Sections',
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticCard({
    required IconData icon,
    required String value,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDarkColor,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Color(0xFF85877D)),
          ),
        ],
      ),
    );
  }

  // Course description
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.largeTextColor,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          course.description.isEmpty
              ? 'No description added yet.'
              : course.description,
          style: const TextStyle(
            fontSize: 13,
            height: 1.7,
            color: Color(0xFF62675F),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFEFA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: AppColors.primaryColor,
                size: 24,
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Course Price',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.largeTextColor,
                  ),
                ),
              ),

              Text(
                course.displayPrice,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDarkColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Sections and lessons
  Widget _buildCourseContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Content',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.largeTextColor,
          ),
        ),

        const SizedBox(height: 12),

        if (course.sections.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFEFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: const Text(
              'No sections or lessons added yet.',
              style: TextStyle(fontSize: 12, color: Color(0xFF85877D)),
            ),
          )
        else
          for (var section in course.sections)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFEFA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (section.lessons.isEmpty)
                    const Text(
                      'No lessons in this section.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF85877D)),
                    ),

                  for (var lesson in section.lessons)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(
                            lesson.contentType == LessonContentType.video
                                ? Icons.play_circle_outline
                                : Icons.description_outlined,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              lesson.title,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.largeTextColor,
                              ),
                            ),
                          ),

                          Text(
                            lesson.contentType == LessonContentType.video
                                ? 'Video'
                                : 'Document',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF85877D),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
      ],
    );
  }

  // Action buttons

  Widget _buildButtons(BuildContext context) {
    return CourseActionButton(
      text: 'Edit Course',
      icon: Icons.edit_outlined,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('coming soon')),
        );
      },
    );
  }
}
