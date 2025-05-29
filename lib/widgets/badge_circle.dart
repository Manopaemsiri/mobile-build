import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class BadgeCircle extends StatelessWidget {
  const BadgeCircle({
    super.key,
    required this.title,
    this.color,
    this.size = 16,
  });

  final String title;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    Color widgetColor = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.all(size / 2),
      decoration: BoxDecoration(
        color: color ?? widgetColor,
        shape: BoxShape.circle,
        border: Border.all(width: 1, color: kWhiteColor),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: size, color: Colors.white),
        ),
      ),
    );
  }
}
