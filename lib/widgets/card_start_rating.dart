import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

import '../utils/formater.dart';

class CardStarRating extends StatelessWidget {
  const CardStarRating({
    Key? key,
    required this.height,
    this.score,
  }) : super(key: key);

  final double? score;
  final double height;

  @override
  Widget build(BuildContext context) {

    return Opacity(
      opacity: score == null? 0: 1,
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.star_rounded,
              color: kYellowColor,
              size: height,
            ),
            const Gap(gap: kQuarterGap),
            Text(
              score != null && (score ?? -1) >= 0? numberFormat(score, digits: 1): '-',
              style: subtitle3.copyWith(
                color: kDarkColor,
                fontWeight: FontWeight.w400,
                fontSize: height-1,
                height: 1.2
              ),
            )
          ],
        ),
      ),
    );
  }
}