import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductCategory extends StatelessWidget {
  const ShimmerProductCategory({
    Key? key,
    required this.height,
    required this.width,
    required this.childAspectRatio,
    required this.iconSize
  }) : super(key: key);
  final double height;
  final double width;
  final double childAspectRatio;
  final double iconSize;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const Gap(),
        SizedBox(
          height: height+kQuarterGap/2,
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: kHalfGap),
            physics: const NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: kQuarterGap/2,
              mainAxisSpacing: 0,
              childAspectRatio: childAspectRatio
            ),
            itemCount: 10,
            itemBuilder: (context, index) {

              return  Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: kHalfGap),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: kHalfGap),
                            alignment: Alignment.center,
                            width: iconSize,
                            height: iconSize,
                            decoration: BoxDecoration(
                              color: kGrayLightColor,
                              borderRadius: BorderRadius.circular(kRadius)
                            ),
                          ),
                        ),
                      const Gap(gap: kQuarterGap),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              height: caption.fontSize!*1.25,
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
                            const Gap(gap: 1),
                            Container(
                              height: caption.fontSize!*1.25,
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
        ),
      ],
    );
  }
}