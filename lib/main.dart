import 'package:flutter/material.dart';
import 'package:marefa/general%20pages/LogiGSignUpselection.dart';
import 'package:marefa/general%20pages/login.dart';
import 'package:marefa/general%20pages/security.dart';
import 'package:marefa/onboarding/onboarding1.dart';

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
      home: Logigsignupselection(), //Scaffold(
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
