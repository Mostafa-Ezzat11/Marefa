import 'package:flutter/material.dart';

void main() {
  runApp(Marefa());
}

class Marefa extends StatelessWidget {
  const Marefa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'Welcome my team ❤️',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
