import 'package:flutter/material.dart';
//import 'package:marefa/teacher/screens/earnings_page.dart';
//import 'package:marefa/teacher/screens/payout_methods_page.dart';
import 'package:marefa/teacher/screens/teacher_home_page.dart';
import 'constants.dart';


void main() => runApp(const MarefaApp());

class MarefaApp extends StatelessWidget {
  const MarefaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marefa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      ),
      home:TeacherHomePage(),
    );
  }
}