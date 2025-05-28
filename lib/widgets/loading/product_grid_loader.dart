import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductGridLoader extends StatelessWidget {
  const ProductGridLoader({
    super.key,
    this.itemLength = 10,
    this.showStock = false,
    this.enabledBoxShadow = false,
    this.bgColor = kWhiteColor,
    this.padding = const EdgeInsets.fromLTRB(kGap, kGap, kGap, kGap),
  });
  final int itemLength;
  final bool showStock;
  final bool enabledBoxShadow;
  final Color bgColor;
  final EdgeInsetsGeometry? padding;
  
  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (_, boxConstraints) {
        final double cardW = min((boxConstraints.maxWidth-(kGap*2)-kHalfGap)/2, 176.36363636363637);
        double screenWidth = boxConstraints.maxWidth;
        int crossAxisCount = (screenWidth / cardW).floor();

        double cardWidth = (MediaQuery.of(context).size.width - (2*kGap) - ((crossAxisCount-1)*kHalfGap))/crossAxisCount;
        const double starHeight = 15;
        
        const double imageRatio = 178/150;
        final double cardHeight = (cardWidth/imageRatio)
          + ((bodyText2.fontSize!*1.4)*3)
          + (title.fontSize!*1.2)
          + kQuarterGap+(2*kHalfGap)
          + (!showStock? 0: subtitle2.fontSize!*1.4)
          + (kQuarterGap*2)
          + starHeight;
          
        return GridView.builder(
          shrinkWrap: true,
          padding: padding,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: kHalfGap,
            crossAxisSpacing: kHalfGap,
            childAspectRatio: cardWidth/cardHeight
          ),
          itemCount: itemLength,
          itemBuilder: (_, index) {

            return Container(
              width: cardWidth,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(kCardRadius),
                boxShadow: enabledBoxShadow? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 10.5,
                    offset: const Offset(0, 0),
                  ),
                ]: null
              ),
              padding: EdgeInsets.zero,
              child: AspectRatio(
                aspectRatio: cardWidth/cardHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: cardWidth,
                      color: kWhiteColor,
                      padding: EdgeInsets.zero,
                      child: AspectRatio(
                        aspectRatio: imageRatio,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: Container(
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerWidget(bodyText2.fontSize),
                          const Gap(gap: 1.4),
                          _shimmerWidget(bodyText2.fontSize),

                          const Gap(gap: kHalfGap),

                          _shimmerWidget(bodyText2.fontSize),
                          const Gap(gap: 1.4),
                          _shimmerWidget(subtitle2.fontSize),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  _shimmerWidget(double? height) {

    return Container(
      height: height,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kRadius),
        color: kWhiteColor,
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
  }
}