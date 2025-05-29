import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

class BadgeDefault extends StatelessWidget {
  const BadgeDefault({
    super.key,
    required this.title,
    this.icon,
    this.iconRight,
    this.color,
    this.size = 12,
    this.textColor,
  });

  final String title;
  final IconData? icon;
  final IconData? iconRight;
  final Color? color;
  final double size;
  final Color? textColor; 

  @override
  Widget build(BuildContext context) {
    Color _color = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kHalfGap,
        vertical: kQuarterGap / 2,
      ),
      decoration: BoxDecoration(
        color: color ?? _color,
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: Row(
        children: [
          if(icon != null) ...[
            Icon(
              icon, color: 
              Colors.white, 
              size: size * 0.8
            ),
            Gap(gap: size * 0.6),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: size,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          if(iconRight != null) ...[
            Gap(gap: size * 0.6),
            Icon(
              iconRight,
              color: Colors.white,
              size: size * 0.8
            ),
          ],
        ],
      ),
    );
  }
}