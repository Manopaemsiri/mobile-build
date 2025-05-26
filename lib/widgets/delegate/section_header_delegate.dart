import 'package:flutter/material.dart';

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  const SectionHeaderDelegate({required this.child, this.height = 50});

  final Widget child;
  final double height;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      color: Colors.white,
      alignment: Alignment.bottomCenter,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
