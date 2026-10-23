import 'package:flutter/material.dart';
import 'package:marafty1/onboarding/onboarding3.dart';
//import 'package:my_app/usersscren.dart/onboarding3.dart';
import 'package:marafty1/onboarding/userscreen.dart';

class Onboarding2 extends StatefulWidget {
  const Onboarding2({Key? key}) : super(key: key);

  @override
  State<Onboarding2> createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
  int _currentIndex = 1;

  final int _totalDots = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Image
            Image.asset(
              'assets/images/onboarding2.png',
              width: 300,
              height: 350,
            ),

            const SizedBox(height: 30),

            // Main Text
           const Text(
                "Learn at your own \n pace",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:  Color.fromARGB(255, 51, 86, 69),
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  height: 1.2,
                ),
              ),
            

            const SizedBox(height: 20),

            // Description
            Text(
          " Watch lessons, track progress and pick up right \nwhere you stopped.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 40),

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
                        ? Color.fromARGB(255, 51, 86, 69)
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)  => const Onboarding3(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 51, 86, 69),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    elevation: 0,
                  ),

                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}