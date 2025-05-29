import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  const LabelText({
    super.key,
    required this.text,
    this.isRequired = false,
  });

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    if (isRequired) {
      return Row(
        children: [
          Text(
            text,
            style: subtitle1.copyWith(
              fontWeight: FontWeight.w600
            ),
          ),
          Text(
            ' *', 
            style: subtitle1.copyWith(
              color: kRedColor,
              fontWeight: FontWeight.w600
            )
          ),
        ],
      );
    }

    return Text(
      text,
      style: subtitle1.copyWith(
        fontWeight: FontWeight.w600
      )
    );
  }
}
