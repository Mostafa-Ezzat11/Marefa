import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course.dart';
import 'package:marefa/student/models/lesson_model.dart';
import 'package:marefa/student/widgets/info_chip.dart';
import 'package:marefa/student/widgets/instructor_tile.dart';
import 'package:marefa/student/widgets/lesson_card.dart';

class CourseDetailsView extends StatelessWidget {
  const CourseDetailsView({super.key, required this.course, this.onAddToCart});

  final Course course;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {

    final mutedText = AppColors.largeTextColor.withValues(alpha: 0.6);
    final rating = course.rating;
    final level = course.level;
    final duration = course.durationLabel;
    final instructorName = course.instructorName;
    final description = course.description;
    final sectionCount = course.sectionCount;

    final lessons = [
      LessonModel(id: 1, title: 'Introduction', duration: '5 min'),
      LessonModel(id: 2, title: 'Getting Started', duration: '10 min'),
      LessonModel(id: 3, title: 'Core Concepts', duration: '15 min'),
      LessonModel(id: 4, title: 'Practical Example', duration: '12 min'),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          //  image of course
          _Header(imageAsset: course.image),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: AppColors.largeTextColor,
                    ),
                  ),

            //RATING AND REVIEWS

                  // if (rating != null && course.hasRating) ...[
                  //   const SizedBox(height: 10),
                  //   Row(
                  //     children: [
                  //       RatingStars(rating: rating),
                  //       const SizedBox(width: 8),
                  //       Text(
                  //         '(${course.formattedReviewCount} reviews)',
                  //         style: TextStyle(fontSize: 12, color: mutedText),
                  //       ),
                  //     ],
                  //   ),
                  // ],

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

                  if (sectionCount != null) ...[
                    const SizedBox(height: 20),

                    Text(
                      'Curriculum (${lessons.length} lessons)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.largeTextColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...lessons.asMap().entries.map((entry) {
                      final index = entry.key;
                      final lesson = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: LessonCard(
                          lesson: lesson,
                          isSelected: index == 0,
                        ),
                      );
                    }),
                  ],

                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: GestureDetector(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: onAddToCart,
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
      ),
    );
  }
}

/// Course image (or a placeholder) with a back button on top.
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
