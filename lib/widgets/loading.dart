import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loading extends StatelessWidget {
  Loading({Key? key}) : super(key: key);
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CircularProgressIndicator(),
          Image.asset(
            'assets/images/loader.gif',
            height: 80,
            width: 80,
          ),
          const SizedBox(height: kGap),
          Padding(
            padding: const EdgeInsets.only(left: kHalfGap),
            child: Text(
              '${lController.getLang("Loading")}...',
              textAlign: TextAlign.center,
              style: subtitle1.copyWith(
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }
}
