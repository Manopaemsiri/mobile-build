import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class BadgeOnline extends StatelessWidget {
  const BadgeOnline({
    super.key,
    required this.isOnline,
    this.size = kGap,
  });

  final bool isOnline;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (!isOnline) return const SizedBox();
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kGreenColor,
      ),
    );
  }
}
