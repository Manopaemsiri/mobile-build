import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class ButtonSignInSocial extends StatelessWidget {
  const ButtonSignInSocial({
    Key? key,
    required this.title,
    this.color,
    this.leftWigget,
    this.rightWigget,
    this.width,
    this.height,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final Color? color;
  final Widget? leftWigget;
  final Widget? rightWigget;
  final double? width;
  final double? height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: kHalfGap,
          top: 0,
          bottom: 0,
          child: leftWigget ?? Container(),
        ),
        Positioned(
          right: kHalfGap,
          top: 0,
          bottom: 0,
          child: rightWigget ?? Container(),
        ),
        SizedBox(
          width: width ?? double.infinity,
          height: height ?? kButtonHeight,
          child: TextButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(right: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kButtonRadius),
                side: BorderSide(color: color ?? kAppColor),
              ),
              backgroundColor: color ?? kAppColor,
            ),
            icon: Container(),
            label: Text(
              title,
              style: subtitle1.copyWith(
                color: color ?? kAppColor,
                fontWeight: FontWeight.w600
              ),
            ),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
