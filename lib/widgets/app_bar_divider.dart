import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class AppBarDivider extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDivider({
    Key? key,
    this.preferredSize = const Size.fromHeight(kQuarterGap),
  }) : super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: Container(
        color: kWhiteSmokeColor,
        width: double.infinity,
        height: kQuarterGap,
      ),
      preferredSize: preferredSize,
    );
  }
}
