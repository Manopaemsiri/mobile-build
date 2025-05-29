import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class ShimmerRatingList extends StatelessWidget {
  const ShimmerRatingList({
    super.key,
    this.itemCount = 7,
  });
  final int itemCount;

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      shrinkWrap: true,
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const Divider(height: 0.8, thickness: 0.8, indent: kGap, endIndent: kGap),
      itemBuilder: (BuildContext context, int index) {

        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: kPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  child: const ShimmerWidget(
                    height: 35,
                    width: 35,
                    borderRadius: BorderRadius.zero
                  ),
                ),
                const Gap(),
                Expanded(
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
              ],
            ),
          ),
        );
      },
    );
  }
}