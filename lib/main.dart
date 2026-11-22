import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marefa/onboarding/onboarding1.dart';
import 'package:marefa/student/views/student_home_view.dart';
import 'package:marefa/student/views/student_main_view.dart';
import 'package:marefa/teacher/views/teacher_home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Marefa());
}

class Marefa extends StatelessWidget {
  const Marefa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'OpenSans',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StudentMainView(), //Scaffold(
    );
  }
}
