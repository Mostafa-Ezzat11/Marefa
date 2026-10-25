import 'package:flutter/material.dart';
import 'package:marefa/teacher/models/activity_item.dart';
import 'package:marefa/teacher/models/stat_item.dart';
import '../../constants.dart';
import '../widgets/activity_tile.dart';
import '../widgets/home_header.dart';
import '../widgets/section_header.dart';
import '../widgets/stats_grid.dart';
import '../widgets/primary_button.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  // Replace with real data from your API / state management.
  static const _stats = [
    StatItem(
      icon: Icons.groups_rounded,
      color: AppColors.primaryColor,
      value: '1,240',
      label: 'Total Students',
    ),
    StatItem(
      icon: Icons.menu_book_rounded,
      color: Color(0xFF3F7CE0),
      value: '12',
      label: 'Total Courses',
    ),
    StatItem(
      icon: Icons.check_circle_rounded,
      color: Color(0xFF2EAD6B),
      value: '8',
      label: 'Published Courses',
    ),
    StatItem(
      icon: Icons.play_lesson_rounded,
      color: AppColors.orangeColor,
      value: '96',
      label: 'Total Lessons',
    ),
  ];

  static const _activities = [
    ActivityItem(
      icon: Icons.person_add_alt_1_rounded,
      color: AppColors.primaryColor,
      title: 'Student enrolled',
      subtitle: 'Ben joined Design Project – Columns',
      time: '1m ago',
    ),
    ActivityItem(
      icon: Icons.assignment_turned_in_rounded,
      color: Color(0xFF3F7CE0),
      title: 'New assignment submitted',
      subtitle: 'UI Design Project – Columns',
      time: '1h ago',
    ),
    ActivityItem(
      icon: Icons.public_rounded,
      color: AppColors.orangeColor,
      title: 'Course published',
      subtitle: 'Flutter for Beginners',
      time: '3h ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 16),
              _buildGreeting(),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Create Course',
                icon: Icons.add_circle_outline_rounded,
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              const StatsGrid(items: _stats),
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Recent Activity',
                actionText: 'View all',
                onActionTap: () {},
              ),
              const SizedBox(height: 12),
              _buildActivities(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, Ahmed! 👋',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.largeTextColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Keep inspiring. Keep teaching.',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildActivities() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _activities.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, index) =>
          ActivityTile(item: _activities[index]),
    );
  }
}
