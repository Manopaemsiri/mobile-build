import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class ButtonHalf extends StatelessWidget {
  const ButtonHalf({
    Key? key,
    required this.title,
    this.color,
    this.icon,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final Color? color;
  final Widget? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2),
      height: kButtonHalfHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: subtitle1.copyWith(color: kWhiteColor),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kButtonRadius),
          ),
        ),
      ),
    );
  }
}
