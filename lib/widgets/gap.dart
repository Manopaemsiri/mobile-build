import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({Key? key, this.gap = kGap}) : super(key: key);

  final double gap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: gap, width: gap);
  }
}
