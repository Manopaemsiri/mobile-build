import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHorizontalProducts extends StatelessWidget {
  const ShimmerHorizontalProducts({
    super.key,
    this.length = 10,
    this.isCmsCard = false,
    this.showStock = false,
  });
  final int length;
  final bool isCmsCard;
  final bool showStock;

  @override
  Widget build(BuildContext context) {
    const double imageRatio = 178/150;
    final double cardWidth = min((Get.width-kGap)/2.4, 172.5);
    double cardHeight = (cardWidth/imageRatio)
      + ((bodyText2.fontSize!*1.4)*3)
      + (title.fontSize!*1.2)
      + kQuarterGap+(2*kHalfGap)
      + (!showStock? 0: subtitle2.fontSize!*1.4);
    if(isCmsCard) {
      cardHeight = (cardWidth/imageRatio)
        + ((bodyText1.fontSize!*1.4)*2)
        + ((bodyText2.fontSize!*1.4)*2)
        + kQuarterGap
        + (kHalfGap*2);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: kGap + kQuarterGap),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: kGap),
          height: title.fontSize!*1.4,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(kRadius),
          ),
          child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
            child: Container(
              color: kWhiteColor,
            ),
          ),
        ),
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kGap),
          child: Wrap(
            spacing: kHalfGap,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: List.generate(length, (index) {

              return Container(
                height: cardHeight,
                width: cardWidth,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(kCardRadius),
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: Container(
                    color: kWhiteColor,
                  ),
                ),
              );
            }).toList(),
          )
        ),
      ],
    );
  }
}