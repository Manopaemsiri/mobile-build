import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataCoffeeMug extends StatelessWidget {
  NoDataCoffeeMug({
    super.key,
    this.titleText ,
  });

  final String? titleText;
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    final titleText2 = titleText ?? lController.getLang("No data found");
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: kGap,
          bottom: kGap
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 85, height: 85, child: Image.asset(coffeeMug)),
            const Gap(),
            Text(
              lController.getLang(titleText2),
              textAlign: TextAlign.center,
              style: title.copyWith(
                  fontWeight: FontWeight.w500, color: kGrayColor),
            ),
          ],
        ),
      ),
    );
  }
}
