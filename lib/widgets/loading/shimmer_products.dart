import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

class ShimmerProducts extends StatelessWidget {
  const ShimmerProducts({
    Key? key,
    this.itemCount = 7,
  }) : super(key: key);
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    const double imageWidth = 88;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        
        return Container(
          color: kWhiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: kPadding,
                child: Row(
                  children: [
                    const ShimmerWidget(width: imageWidth, height: imageWidth),
                    const SizedBox(width: kGap),
                    SizedBox(
                      width: Get.width - 88 - kGap*3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          ShimmerWidget(height: subtitle1.fontSize!*1.45),
                          const Gap(gap: kQuarterGap),
                          ShimmerWidget(height: subtitle1.fontSize!*1.45),
                          const SizedBox(height: 6),
                          ShimmerWidget(height: subtitle1.fontSize!*1.45),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
            ],
          ),
        );
      },
    );
  }
}