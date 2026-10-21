import 'package:flutter/material.dart';
import 'package:marefa/student/views/course_videos_view.dart';
import 'package:marefa/student/views/home_view.dart';
import 'package:marefa/student/views/my_courses_view.dart';
import 'package:marefa/student/views/payment_successful_view.dart.dart';
import 'package:marefa/student/views/wish_list_view.dart';
import 'package:marefa/student/widgets/bottom_nav.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int navIndex = 0;

  final pages = const [
    HomeView(),
    MyCoursesPage(),
    WishListView(),
    CourseVideosView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: navIndex, children: pages),
      bottomNavigationBar: BottomNav(
        index: navIndex,
        onChanged: (i) => setState(() => navIndex = i),
      ),
    );
  }
}