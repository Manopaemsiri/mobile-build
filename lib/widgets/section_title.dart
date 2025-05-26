import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle({
    Key? key,
    this.titleText,
    this.isReadMore = false,
    this.padding = kPaddingTitle,
    this.onTap,
  }) : super(key: key);

  final String? titleText;
  final bool isReadMore;
  final EdgeInsets padding;
  final void Function()? onTap;
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleText!,
            style: title.copyWith(
              fontWeight: FontWeight.w600,
              color: kAppColor2
            ),
          ),
          if (isReadMore) ...[
            GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lController.getLang("View All"),
                    style: subtitle2.copyWith(
                      fontWeight: FontWeight.w600, 
                      // color: kAppColor,
                      color: kAppColor2
                    ),
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    color: kAppColor2
                  )
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
