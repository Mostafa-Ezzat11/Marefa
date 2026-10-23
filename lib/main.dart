import 'package:flutter/material.dart';
import 'package:marefa/teacher/views/add_course_basic_info_view.dart';
import 'package:marefa/teacher/views/add_course_content_view.dart';
import 'package:marefa/teacher/views/teacher_home_page.dart';
import 'teacher/views/instructor_courses_view.dart';
import 'package:marefa/student/views/home_view.dart';
import 'package:marefa/student/views/main_shell_view.dart';

void main() {
  runApp(Marefa());
}

class Marefa extends StatelessWidget {
  const Marefa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(fontFamily: 'OpenSans'),
      home: AddCourseContentview(), //Scaffold(
      //   body: PaymentSuccessfulView(),
      //   // body: Center(
      //   //   child: Text(
      //   //     'Welcome my team ✌️',
      //   //     style: TextStyle(fontSize: 25),
      //   //   ),
      //   // ),
      // ),
    );
  }
}
