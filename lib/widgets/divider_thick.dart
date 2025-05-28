import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class DividerThick extends StatelessWidget {
  const DividerThick({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: kHalfGap,
      thickness: kHalfGap,
      color: kWhiteSmokeColor,
    );
  }
}