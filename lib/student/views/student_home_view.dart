import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/general%20pages/services/auth_service.dart';
import 'package:marefa/student/models/course.dart';
import 'package:marefa/student/models/course_category.dart';
import 'package:marefa/student/services/course_service.dart';
import 'package:marefa/student/views/search_view.dart';
import 'package:marefa/student/widgets/category_item.dart';
import 'package:marefa/student/widgets/course_card.dart';
import 'package:marefa/student/widgets/hero_banner.dart';
import 'package:marefa/student/widgets/home_search_bar.dart';
import 'package:marefa/student/widgets/section_header.dart';
import 'package:marefa/teacher/widgets/home_header.dart';



class StudentHomeView extends StatefulWidget {
  const StudentHomeView({super.key});

  @override
  State<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<StudentHomeView> {


  static const List<CourseCategory> _categories = [
    CourseCategory(
      id: 'programming',
      name: 'Programming',
      icon: Icons.desktop_windows_outlined,
      iconColor: AppColors.primaryDarkColor,
      backgroundColor: Color(0xFFE0EAE2),
    ),
    CourseCategory(
      id: 'design',
      name: 'Design',
      icon: Icons.draw_outlined,
      iconColor: AppColors.primaryColor,
      backgroundColor: Color(0xFFD5E5D9),
    ),
    CourseCategory(
      id: 'business',
      name: 'Business',
      icon: Icons.work_outline_rounded,
      iconColor: AppColors.orangeColor,
      backgroundColor: Color(0xFFF5E5D3),
    ),
    CourseCategory(
      id: 'marketing',
      name: 'Marketing',
      icon: Icons.campaign_outlined,
      iconColor: Color(0xFFB84A4A),
      backgroundColor: Color(0xFFF3DEDA),
    ),
    CourseCategory(
      id: 'maths',
      name: 'Maths',
      icon: Icons.calculate_outlined,
      iconColor: Color(0xFF8C7A32),
      backgroundColor: Color(0xFFF5EED5),
    ),
  ];
  String? _selectedCategoryId;

  final CourseService _courseService = CourseService();
  late Future<List<Course>> _coursesFuture;

  late Future<String> _userNameFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _courseService.fetchCourses();
    _userNameFuture = AuthService.instance.getStudentName();

  }

  Widget _buildCoursesSection() {
    return FutureBuilder<List<Course>>(
      future: _coursesFuture,

      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error
        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                const Text('Something went wrong!'),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _coursesFuture = _courseService.fetchCourses();
                    });
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        final allCourses = snapshot.data ?? [];

        final courses = _selectedCategoryId == null
            ? allCourses
            : allCourses
                  .where((course) => course.categoryId == _selectedCategoryId)
                  .toList();
        // Empty
        if (courses.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('No courses available yet.'),
            ),
          );
        }

        // Success
        return Column(
          children: [
            for (final course in courses)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CourseCard(course: course),
              ),
          ],
        );
      },
    );
  }

  Widget _buildGreeting() {
    return FutureBuilder<String>(
      future: _userNameFuture,
      builder: (_, snapshot) {
        final userName =  snapshot.data ?? 'Student';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName! 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.largeTextColor,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Keep Studying. Keep Learning.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            HomeHeader(onNotificationTap: () {}),

            _buildGreeting(),

            const SizedBox(height: 16),

            HomeSearchBar(
              readOnly: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SearchView()),
              ),
            ),

            const SizedBox(height: 16),

            const HeroBanner(),

            const SizedBox(height: 24),

            Text(
              'Categories',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.largeTextColor,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (_, index) {
                  final category = _categories[index];

                  return CategoryItem(
                    category: category,
                    isSelected: _selectedCategoryId == category.id,
                    onTap: () {
                      setState(() {
                        if (_selectedCategoryId == category.id) {
                          _selectedCategoryId = null;
                        } else {
                          _selectedCategoryId = category.id;
                        }
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            const SectionHeader(title: 'Popular Courses'),

            const SizedBox(height: 12),

            _buildCoursesSection(),
          ],
        ),
      ),
    );
  }
}


