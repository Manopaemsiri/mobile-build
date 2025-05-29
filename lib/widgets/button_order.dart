import 'package:coffee2u/config/styles.dart';
import 'package:coffee2u/config/themes/colors.dart';
import 'package:coffee2u/config/themes/typography.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/material.dart';

class ButtonOrder extends StatelessWidget {
  const ButtonOrder({
    super.key,
    this.title = "Order Now",
    this.color,
    this.width,
    this.height,
    required this.qty,
    required this.total,
    required this.onPressed,
    required this.lController,
    this.trimDigits = false
  });

  final String title;
  final Color? color;
  final double? width;
  final double? height;
  final int qty;
  final double total;
  final VoidCallback onPressed;
  final LanguageController lController;
  final bool trimDigits;

  @override
  Widget build(BuildContext context) {
    String widgetTitle = title;
    String widgetQty = "$qty";
    String widgetTotal = priceFormat(total, lController, trimDigits: trimDigits);

    return Stack(
      children: [
        SizedBox(
          width: width ?? double.infinity,
          height: height ?? kButtonHeight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kButtonRadius),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              widgetTitle,
              style: headline6.copyWith(
                color: kWhiteColor,
                 fontSize: 18, 
              ),
            ),
          ),
        ),
        Positioned(
          left: kGap,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: kButtonHeight / 2,
                  height: kButtonHeight / 2,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(kButtonRadius),
                  ),
                  child: Center(
                    child: Text(
                      widgetQty,
                      style: headline6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: kGap,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: kButtonHeight / 2,
                  child: Center(
                    child: Text(
                      widgetTotal,
                      style: subtitle1.copyWith(
                        fontSize: 18,
                        color: kWhiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
