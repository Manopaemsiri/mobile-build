import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class BadgeSelector extends StatelessWidget {
  const BadgeSelector({
    super.key,
    this.selected = false,
    required this.title,
    this.color,
    this.size = 12,
  });

  final bool selected;
  final String title;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    Color widgetColor = Theme.of(context).primaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: size*2.0667,
      curve: Curves.easeIn,
      padding: EdgeInsets.fromLTRB(size/3, size/3.5, size/3, size/3.5),
      decoration: BoxDecoration(
        // color: selected ? widgetColor.withValues(alpha: 0.125): kGrayLightColor,
        color: selected ? const Color(0xFFFBD8DD): kGrayLightColor,
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: size,
          color: selected ? color ?? widgetColor : null,
        ),
      ),
    );
  }
}
