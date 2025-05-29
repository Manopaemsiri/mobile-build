import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class ButtonTextBackground extends StatelessWidget {
  const ButtonTextBackground(
      {super.key,
      required this.title,
      this.backgroundColor = kGrayLightColor,
      this.textColor = kAppColor,
      required this.onTap,
      this.size = 'normal'})
     ;

  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Function() onTap;
  final String size;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
                kHalfGap, kQuarterGap, kHalfGap, kQuarterGap),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
            ),
            child: Text(
              title,
              style: size == 'small'
                  ? subtitle2.copyWith(
                      color: textColor, fontWeight: FontWeight.w400)
                  : subtitle1.copyWith(
                      color: textColor, fontWeight: FontWeight.w400),
            ),
          ),
        )
      ],
    );
  }
}
