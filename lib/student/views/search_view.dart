import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course.dart';
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

  static const List<Course> _courses = [
    Course(title: 'Flutter Development Complete Guide', price: 49.99),
    Course(title: 'Flutter UI/UX Design', price: 39.99),
    Course(title: 'Flutter State Management', price: 29.99),
    Course(title: 'Flutter API Integration', price: 0),
  ];

  late final TextEditingController _controller;
  late String _query;
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Course> get _results {
    final query = _query.trim().toLowerCase();

    final matches = _courses
        .where((course) => course.title.toLowerCase().contains(query))
        .toList();

    return switch (_filterIndex) {
      1 => matches.where((course) => course.price == 0).toList(),
      2 => matches.where((course) => course.price > 0).toList(),
      3 => matches.where((course) => course.isFavorite == true).toList(),
      _ => matches,
    };
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

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
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            FilterChipBar(
              labels: _filters,
              selectedIndex: _filterIndex,
              onSelected: (index) => setState(() => _filterIndex = index),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        'No courses found',
                        style: TextStyle(color: AppColors.primaryDarkColor),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: results.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, index) =>
                          CourseCard(course: results[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
