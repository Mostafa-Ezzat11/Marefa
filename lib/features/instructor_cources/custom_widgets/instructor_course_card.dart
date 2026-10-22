import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import '../models/instructor_course_model.dart';
import '../models/course_enums.dart';
import 'course_status_chip.dart';
import '../screens/instructor_course_details_screen.dart';

class InstructorCourseCard extends StatelessWidget {
  final InstructorCourseModel course;

  const InstructorCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: BorderRadius.circular(19),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return InstructorCourseDetailsScreen(course: course);
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFEFA),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CourseStatusChip(status: course.status),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Course menu coming soon')),
                    );
                  },
                  icon: const Icon(Icons.more_horiz, size: 20),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildThumbnail(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF30473A),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${course.lessonsCount} lessons · '
                        '${course.studentsCount} students · '
                        '${course.displayPrice}',
                        maxLines: 2,
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
            const SizedBox(height: 9),

            Row(
              children: [
                Expanded(
                  child: Text(
                    _getFooterText(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF85877D),
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('coming soon')),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryDarkColor,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    course.status == CourseStatus.inReview
                        ? Icons.assignment_outlined
                        : Icons.edit_outlined,
                    size: 12,
                  ),
                  label: Text(
                    course.status == CourseStatus.published
                        ? 'Edit course'
                        : course.status == CourseStatus.draft
                        ? 'Continue editing'
                        : 'View status',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Image.network(
          course.thumbnailUrl!,
          width: 66,
          height: 66,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _placeholderThumbnail();
          },
        ),
      );
    }

    return _placeholderThumbnail();
  }

  Widget _placeholderThumbnail() {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: const Color(0xFFE4EBDD),
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Icon(
        Icons.menu_book_rounded,
        color: AppColors.primaryColor,
        size: 30,
      ),
    );
  }

  String _getFooterText() {
    if (course.status == CourseStatus.published) {
      return 'Updated recently';
    }

    if (course.status == CourseStatus.draft) {
      return 'Saved recently';
    }

    return 'Submitted for review';
  }
}
