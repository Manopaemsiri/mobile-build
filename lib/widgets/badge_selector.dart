import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class BadgeSelector extends StatelessWidget {
  const BadgeSelector({
    Key? key,
    this.selected = false,
    required this.title,
    this.color,
    this.size = 12,
  }) : super(key: key);

  final bool selected;
  final String title;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    Color _color = Theme.of(context).primaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: size*2.0667,
      curve: Curves.easeIn,
      padding: EdgeInsets.fromLTRB(size/3, size/3.5, size/3, size/3.5),
      decoration: BoxDecoration(
        // color: selected ? _color.withOpacity(0.125): kGrayLightColor,
        color: selected ? const Color(0xFFFBD8DD): kGrayLightColor,
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: size,
          color: selected ? color ?? _color : null,
        ),
      ),
    );
  }
}
