import 'package:flutter/material.dart';
import 'package:marefa/student/views/my_profile_view.dart';
import 'package:marefa/student/views/student_home_view.dart';
import 'package:marefa/student/views/my_courses_view.dart';
import 'package:marefa/student/views/wish_list_view.dart';
import 'package:marefa/student/widgets/bottom_nav.dart';

class StudentMainView extends StatefulWidget {
  const StudentMainView({super.key});
  @override
  State<StudentMainView> createState() => _StudentMainViewState();
}

class _StudentMainViewState extends State<StudentMainView> {
  int navIndex = 0;

  final pages = const [
    StudentHomeView(),
    MyCoursesPage(),
    WishListView(),
    MyProfileView(),
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
