import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FilterLoading extends StatelessWidget {
  const FilterLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(
        kGap, kHalfGap, kGap, kGap * 2
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerWidget(title.fontSize ?? 0*1.4),
              const Gap(gap: kHalfGap),
              Wrap(
                spacing: kHalfGap,
                runSpacing: kHalfGap,
                children: List.generate(Random().nextInt(10) + 5, (i) => i).map((int d) {
                  return _shimmerWidget(16*1.4, Random().nextInt(50) + 50);
                }).toList(),
              ),
          ],
        );
      },
      itemCount: 10,
      separatorBuilder: (context, index) => const Gap(gap: kGap + kQuarterGap),
    );
  }


  Widget _shimmerWidget(double? height, [double? width]) {

    return Container(
      height: height,
      width: width,
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