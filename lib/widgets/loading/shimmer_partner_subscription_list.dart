import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class ShimmerPartnerSubscriptionList extends StatelessWidget {
  const ShimmerPartnerSubscriptionList({
    Key? key,
    this.itemCount = 7,
  }) : super(key: key);
  final int itemCount;

  @override
  Widget build(BuildContext context) {

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
          ),
        );
      },
    );
  }
}