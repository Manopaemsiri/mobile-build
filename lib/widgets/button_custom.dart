import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    Key? key,
    required this.title,
    this.color,
    this.icon,
    this.leftWigget,
    this.rightWigget,
    this.width,
    this.height,
    this.isOutline = false,
    required this.onPressed,
    this.textStyle,
  }) : super(key: key);

  final String title;
  final Color? color;
  final Widget? icon;
  final Widget? leftWigget;
  final Widget? rightWigget;
  final double? width;
  final double? height;
  final bool? isOutline;
  final VoidCallback onPressed;
  final TextStyle? textStyle;

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
            style: isOutline == true
              ? ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kButtonRadius),
                  side: BorderSide(color: color ?? kAppColor),
                ),
                backgroundColor: color ?? kWhiteColor,
              )
              : ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 8),
                backgroundColor: color ?? kAppColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kButtonRadius),
                ),
              ),
            icon: icon ?? Container(),
            label: Text(
              title,
              style: textStyle == null
                ? subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isOutline == true
                    ? color ?? kAppColor
                    : color ?? kWhiteColor
                )
                : textStyle!.copyWith(
                  color: isOutline == true
                    ? color ?? kAppColor
                    : color ?? kWhiteColor
                ),
            ),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
