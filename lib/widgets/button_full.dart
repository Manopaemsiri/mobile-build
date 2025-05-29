import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class ButtonFull extends StatelessWidget {
  const ButtonFull({
    super.key,
    required this.title,
    this.color,
    this.icon,
    required this.onPressed,
  });

  final String title;
  final Color? color;
  final Widget? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: kButtonHeight,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kButtonRadius),
          ),
        ),
        onPressed: onPressed,
        label: Text(
          title,
          style: headline6.copyWith(
            color: kWhiteColor
          ),
        ),
        icon: Container(
          child: icon,
        ),
      ),
    );
  }
}
