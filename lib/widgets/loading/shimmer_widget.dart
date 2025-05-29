import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: width,
      height: height,  
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: borderRadius ?? BorderRadius.circular(kRadius)
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
