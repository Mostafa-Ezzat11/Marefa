import 'package:flutter/material.dart';
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

      home: MainShell(),
    );
  }
}
