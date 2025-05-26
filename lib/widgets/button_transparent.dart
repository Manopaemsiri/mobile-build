import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class ButtonTransparent extends StatelessWidget {
  const ButtonTransparent({
    Key? key,
    required this.title,
    this.color,
    this.icon,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final Color? color;
  final IconData? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: kButtonHeight,
      child: TextButton.icon(
        style: ElevatedButton.styleFrom(
          // เพิ่ม padding ทางขวาหากไม่มี icon
          padding: EdgeInsets.only(right: icon != null ? 0 : 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kButtonRadius),
            side: BorderSide(color: color ?? kWhiteColor),
          ),
          backgroundColor: color ?? kWhiteColor,
        ),
        // ทำให้ใส่-ไม่ใส่ icon ก็ได้
        icon: icon != null
            ? Icon(icon, color: color ?? kWhiteColor)
            : Container(),
        label: Text(
          title,
          style: headline6.copyWith(color: color ?? kWhiteColor),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
