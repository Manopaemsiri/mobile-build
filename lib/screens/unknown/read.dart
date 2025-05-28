import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';

class UnknownScreen extends StatefulWidget {
  const UnknownScreen({super.key});

  @override
  State<UnknownScreen> createState() => _UnknownScreenState();
}

class _UnknownScreenState extends State<UnknownScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lController.getLang('Error'),
          style: headline6.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        padding: kPadding,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: min(Get.width*0.4, 157.09090909090912),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    coffeeMug,
                  ),
                ),
              ),
              const Gap(gap: kHalfGap),
              Text(
                lController.getLang('text_404_error_1'),
                style: title.copyWith(
                  fontFamily: 'Kanit',
                  color: kDarkColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(gap: kQuarterGap),
              Text(
                lController.getLang('please try again later'),
                style: title.copyWith(
                  fontFamily: 'Kanit',
                  color: kDarkColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}