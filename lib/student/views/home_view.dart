import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course.dart';
import 'package:marefa/student/models/course_category.dart';
import 'package:marefa/student/widgets/category_item.dart';
import 'package:marefa/student/widgets/course_card.dart';
import 'package:marefa/student/widgets/section_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const List<CourseCategory> _categories = [
    CourseCategory(
      name: 'Programming',
      icon: Icons.desktop_windows_outlined,
      iconColor: AppColors.primaryDarkColor,
      backgroundColor: Color(0xFFE0EAE2),
    ),
    CourseCategory(
      name: 'Design',
      icon: Icons.draw_outlined,
      iconColor: AppColors.primaryColor,
      backgroundColor: Color(0xFFD5E5D9),
    ),
    CourseCategory(
      name: 'Business',
      icon: Icons.work_outline_rounded,
      iconColor: AppColors.orangeColor,
      backgroundColor: Color(0xFFF5E5D3),
    ),
    CourseCategory(
      name: 'Marketing',
      icon: Icons.campaign_outlined,
      iconColor: Color(0xFFB84A4A),
      backgroundColor: Color(0xFFF3DEDA),
    ),
  ];

  static const List<Course> _courses = [
    Course(
      title: 'Web Development Complete Guide',
      image: 'assets/images/course_visual_storytelling.png',
      price: 49.99,
    ),
    Course(title: 'Flutter UI/UX Design', price: 39.99),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const HomeSearchBar(onChanged: null),
            const SizedBox(height: 16),
            const HeroBanner(),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Categories'),
            const SizedBox(height: 16),
            Row(
              children: [
                for (final category in _categories)
                  Expanded(child: CategoryItem(category: category)),
              ],
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Popular Courses'),
            const SizedBox(height: 12),
            for (final course in _courses)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CourseCard(course: course),
              ),
          ],
        ),
      ),
    );
  }
}

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key, this.imageAsset, this.onExplore});

  final String? imageAsset;
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    final asset = imageAsset;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 170,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDarkColor,
              AppColors.primaryColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            if (asset != null) ...[
              Positioned.fill(
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ] else
              Positioned(
                right: 16,
                bottom: 8,
                child: Icon(
                  Icons.psychology_alt_rounded,
                  size: 110,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Learn New Skills\nBuild Your Future',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onExplore,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.15,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Explore Courses',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDarkColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.largeTextColor,
        ),
        cursorColor: AppColors.primaryColor,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.largeTextColor,
          ),
          hintText: 'Search courses...',
          hintStyle: TextStyle(
            color: AppColors.largeTextColor,
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
