import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  const ButtonText({
    Key? key,
    required this.title,
    this.color,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final Color? color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kButtonTextHeight,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: color),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(
            vertical: kQuarterGap,
            horizontal: kHalfGap,
          ),
        ),
      ),
    );
  }
}
