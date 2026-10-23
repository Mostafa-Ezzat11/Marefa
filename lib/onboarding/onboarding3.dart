import 'package:flutter/material.dart';
import 'package:marafty1/onboarding/userscreen.dart';
import 'package:marafty1/pages/login.dart';

class Onboarding3 extends StatefulWidget {
  const Onboarding3({Key? key}) : super(key: key);

  @override
  State<Onboarding3> createState() => _onboarding3();
}

class _onboarding3 extends State<Onboarding3> {
  int _currentIndex = 2;

  final int _totalDots = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
 Image.asset(
              'assets/images/onboarding3.png',
              width: 300,
              height: 350,
            ),

          

            const SizedBox(height: 30),

            // Main Text
            Text(
              "Earn certificates",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 223, 130, 16),
                height: 1.2,
              ),
            ),

            const SizedBox(height: 20),

            // Description
            Text(
             "Finish courses, get certified and show your skills\n to the world", 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _totalDots,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 12 : 8,
                  height: _currentIndex == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Color.fromARGB(255, 223, 130, 16)
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=> Login()));
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color.fromARGB(255, 51, 86, 69),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    elevation: 0,
                  ),

                  child: const Text(
                    'Get start  →',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ]
        )
        ),
  
      );
  }
}