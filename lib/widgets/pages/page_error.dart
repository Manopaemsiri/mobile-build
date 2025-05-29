import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageError extends StatelessWidget {
  PageError({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kGap*2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              lController.getLang('Error'),
              textAlign: TextAlign.center,
              style: title.copyWith(
                fontWeight: FontWeight.w500
              ),
            ),
            const Gap(gap: kHalfGap),
            Text(
              lController.getLang('text_page_error_1'),
              textAlign: TextAlign.center,
              style: subtitle1.copyWith(
                fontWeight: FontWeight.w400
              ),
            ),
            if(onPressed != null)...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(lController.getLang('Refresh')),
              ),
            ]
          ],
        ),
      ),
    );
  }
}