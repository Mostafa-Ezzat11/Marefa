import 'package:flutter/material.dart';
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
      home: MainShell(), //Scaffold(
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
