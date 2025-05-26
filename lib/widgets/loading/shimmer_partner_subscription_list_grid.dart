import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class ShimmerPartnerSubscriptionGrid extends StatelessWidget {
  const ShimmerPartnerSubscriptionGrid({
    Key? key,
    this.itemCount = 7,
  }) : super(key: key);
  final int itemCount;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (_, boxConstraints) {
        final double cardW = min((boxConstraints.maxWidth-(kGap*2)-(kHalfGap*2))/3, 240.0);
        double screenWidth = boxConstraints.maxWidth;
        int crossAxisCount = (screenWidth / cardW).floor();

        double cardWidth = (MediaQuery.of(context).size.width - (2*kGap) - ((crossAxisCount-1)*kHalfGap))/crossAxisCount;
        
        const double imageRatio = 16/9;
        final double cardHeight = (cardWidth/imageRatio)
          + (kGap*2)
          + (title.fontSize!*4*1.45)
          + 6;
        
        return GridView.builder(
          shrinkWrap: true,
          itemCount: itemCount,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: kHalfGap,
            crossAxisSpacing: kHalfGap,
            childAspectRatio: cardWidth/cardHeight
          ),
          itemBuilder: (_, int index) {
            
            return Container(
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(kRadius),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: kGap,
                      horizontal: kGap,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(height: title.fontSize!*1.45),
                        const SizedBox(height: 2),
                        ShimmerWidget(height: title.fontSize!*1.45),
                        const SizedBox(height: 2),
                        ShimmerWidget(height: title.fontSize!*1.45),
                        const SizedBox(height: 2),
                        ShimmerWidget(height: title.fontSize!*1.45),
                      ],
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 16/9,
                    child: const ShimmerWidget(
                      borderRadius: BorderRadius.zero
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );

    return ListView.separated(
      shrinkWrap: true,
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const Gap(gap: kHalfGap),
      itemBuilder: (BuildContext context, int index) {

        return Container(
          margin: const EdgeInsets.only(bottom: kHalfGap),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(kRadius),
          ),
          child: SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kOtGap,
                    horizontal: kGap,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(height: title.fontSize!*1.45),
                      const SizedBox(height: 2),
                      ShimmerWidget(height: title.fontSize!*1.45),
                      const SizedBox(height: 2),
                      ShimmerWidget(height: title.fontSize!*1.45),
                      const SizedBox(height: 2),
                      ShimmerWidget(height: title.fontSize!*1.45),
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: 16/9,
                  child: const ShimmerWidget(
                    borderRadius: BorderRadius.zero
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}