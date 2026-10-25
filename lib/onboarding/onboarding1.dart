import 'package:flutter/material.dart';
import 'package:marefa/onboarding/onboarding2.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  final int _currentIndex = 0;
  final int _totalDots = 3;

  // Colors from the logo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/onboarding1.png',
              width: 400,
              height: 300,
            ),
            const SizedBox(height: 30),
            const Text(
              "Learn anything,\n anytime",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 223, 130, 16),
                fontWeight: FontWeight.bold,
                fontSize: 30,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 20),

            // Description
            Text(
              'Thousands of courses from expert instructors, \n right in your pocket.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _totalDots,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Onboarding2(),
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
        // ],
      ),
    );
    //);
  }
}
