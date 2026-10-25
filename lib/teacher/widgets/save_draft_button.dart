
import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';

class SaveDraftButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveDraftButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        'Save draft & exit',
        style: TextStyle(
          color: AppColors.primaryDarkColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
