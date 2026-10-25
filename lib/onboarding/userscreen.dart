import 'package:flutter/material.dart';
import 'package:marefa/onboarding/onboarding1.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Onboarding1()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset(
            'assets/images/logo.jpeg',
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * .6,
          ),
        ],
      ),
    );
  }
}
