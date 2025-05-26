import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class ButtonSmall extends StatelessWidget {
  const ButtonSmall({
    Key? key,
    required this.title,
    this.color,
    this.icon,
    this.width,
    this.height,
    this.titleStyle,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final Color? color;
  final Widget? icon;
  final double? width;
  final double? height;
  final TextStyle? titleStyle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
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
          style: titleStyle ?? subtitle1.copyWith(
            color: kWhiteColor
          ),
        ),
        icon: SizedBox(
          child: icon,
        ),
      ),
    );
  }
}
