import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/general%20pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marefa/onboarding/onboarding1.dart';
import 'package:marefa/onboarding/userscreen.dart';
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
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      home: SplashScreen(), //Scaffold(
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
