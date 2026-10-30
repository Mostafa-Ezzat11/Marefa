import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course.dart';
import 'package:marefa/student/models/course_category.dart';
import 'package:marefa/student/views/search_view.dart';
import 'package:marefa/student/widgets/category_item.dart';
import 'package:marefa/student/widgets/course_card.dart';
import 'package:marefa/student/widgets/hero_banner.dart';
import 'package:marefa/student/widgets/home_search_bar.dart';
import 'package:marefa/student/widgets/section_header.dart';

class StudentHomeView extends StatefulWidget {
  const StudentHomeView({super.key});

  @override
  State<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<StudentHomeView> {
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
    CourseCategory(
      name: 'Maths',
      icon: Icons.calculate_outlined,
      iconColor: Color(0xFF8C7A32),
      backgroundColor: Color(0xFFF5EED5),
    ),
  ];

  static const List<Course> _courses = [
    Course(
      title: 'Web Development Complete Guide',
      image: 'assets/images/course_visual_storytelling.png',
      price: 49.99,
    ),
    Course(
      image: 'assets/images/course_visual_storytelling.png',
      instructorImage: 'assets/images/payment_successfuly.png',
      title: 'Flutter Development Complete Guide',
      price: 49.99,
      reviewCount: 12000,
      level: 'Expert',
      durationHours: 1,
      instructorName: 'Youssif Shawky',
      instructorTitle: 'Senior Flutter Developer',
      description:
          'Learn Flutter from scratch and build real-world apps with modern techniques.',
      sectionCount: 4,
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
            HomeSearchBar(
              readOnly: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SearchView()),
              ),
            ),
            const SizedBox(height: 16),
            const HeroBanner(),
            const SizedBox(height: 24),
            const Text(
              'Categories',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.largeTextColor,
              ),
            ),
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
