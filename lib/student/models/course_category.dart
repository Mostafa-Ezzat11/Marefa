import 'package:flutter/material.dart';

class CourseCategory {
  const CourseCategory({
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  final String name;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
}