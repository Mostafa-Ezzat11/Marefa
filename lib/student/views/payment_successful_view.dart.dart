import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';

class PaymentSuccessfulView extends StatelessWidget {
  const PaymentSuccessfulView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              CircleAvatar(
                radius: 50,
                child: Image(
                  image: AssetImage(
                    'assets/images/payment_successfuly.png',
                  ),
                ),
              ),
              Text(
                'Payment Successful!',
                style: TextStyle(
                  color: AppColors.largeTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight(1000),
                ),
              ),
              Text(
                'Your course has been enrolled successfully.',
                style: TextStyle(
                  color: AppColors.largeTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight(280),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.orangeColor,

                  borderRadius: BorderRadius.circular(12),
                ),
                height: 50,
                width: 170,
                child: Center(
                  child: Text(
                    'Go to My Courses',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight(800),
                    ),
                  ),
                ),
              ),

              TextButton(
                onPressed: () {},
                child: Text(
                  'View Receipt',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
