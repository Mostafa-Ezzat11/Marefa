//Important:
//1- add favorite to the course by student hive

import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course.dart';
import 'package:marefa/student/services/course_service.dart';
import 'package:marefa/student/services/favorite_service.dart';
import 'package:marefa/student/widgets/course_card.dart';
import 'package:marefa/student/widgets/filter_chip_bar.dart';
import 'package:marefa/student/widgets/home_search_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, this.initialQuery = ''});

  /// Text the search field starts with.
  final String initialQuery;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  static const List<String> _filters = ['All', 'Free', 'Paid', 'Favorite'];

  final CourseService _courseService = CourseService();

  late final TextEditingController _controller;

  late Future<List<Course>> _coursesFuture;

  late String _query;
  int _filterIndex = 0;
  final FavoriteService _favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();

    _query = widget.initialQuery;
    _controller = TextEditingController(text: widget.initialQuery);

    _coursesFuture = _courseService.fetchCourses();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ================= SEARCH & FILTER =================
  List<Course> _getResults(List<Course> allCourses, Set<String> favoriteIds) {
    final query = _query.trim().toLowerCase();

    final matches = allCourses.where((course) {
      return course.title.toLowerCase().contains(query);
    }).toList();

    return switch (_filterIndex) {
      1 => matches.where((course) => course.price == 0).toList(),
      2 => matches.where((course) => course.price > 0).toList(),
      3 => matches.where((course) => favoriteIds.contains(course.id)).toList(),
      _ => matches,
    };
  }

  // ================= COURSES SECTION =================

  Widget buildCoursesSection() {
    return FutureBuilder<List<Course>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        //  Error
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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

        return StreamBuilder<List<String>>(
          stream: _favoriteService.watchFavoriteCourseIds(),
          builder: (context, favoriteSnapshot) {
            //Has Error

            if (favoriteSnapshot.hasError) {
              return const Center(child: Text('Failed to load favorites'));
            }

            // waiting
            if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final favoriteIds = favoriteSnapshot.data!.toSet();

            final results = _getResults(allCourses, favoriteIds);

            if (results.isEmpty) {
              return const Center(
                child: Text(
                  'No courses found',
                  style: TextStyle(color: AppColors.primaryDarkColor),
                ),
              );
            }

            //Success
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: results.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                return CourseCard(course: results[index]);
              },
            );
          },
        );
      },
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: HomeSearchBar(
                controller: _controller,
                showFilterIcon: true,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
            ),

            FilterChipBar(
              labels: _filters,
              selectedIndex: _filterIndex,
              onSelected: (index) {
                setState(() {
                  _filterIndex = index;
                });
              },
            ),

            const SizedBox(height: 16),

            Expanded(child: buildCoursesSection()),
          ],
        ),
      ),
    );
  }
}
