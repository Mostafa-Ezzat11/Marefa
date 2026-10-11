import 'package:flutter/material.dart';
import 'package:marefa/student/views/payment_successful_view.dart.dart';

void main() {
  runApp(Marefa());
}

class Marefa extends StatelessWidget {
  const Marefa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(fontFamily: 'PlusJakartaSans'),
      home: Scaffold(
        body: PaymentSuccessfulView(),
        // body: Center(
        //   child: Text(
        //     'Welcome my team ✌️',
        //     style: TextStyle(fontSize: 25),
        //   ),
        // ),
      ),
    );
  }
}
