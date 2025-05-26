import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class ShimmerCmsList extends StatelessWidget {
  const ShimmerCmsList({
    Key? key,
    this.itemCount = 7,
  }) : super(key: key);
  final int itemCount;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {

        return Card(
          elevation: 0.8,
          margin: const EdgeInsets.only(bottom: kHalfGap),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadius),
          ),
          child: SizedBox(
            height: 118,
            child: Row(
              children: [
                const ShimmerWidget(
                  height: 118,
                  width: 118,
                  borderRadius: BorderRadius.zero
                ),
                Expanded(
                  child: Padding(
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
                      ],
                    ),
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