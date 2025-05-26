import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

PageViewModel onboardingPages(OnboardingModel model, [Widget? footer]) {
  return PageViewModel(
    titleWidget: Text(
      model.heading,
      textAlign: TextAlign.center,
      style: headline5.copyWith(
        // fontFamily: "CenturyGothic",
        height: 1.3,
        fontWeight: FontWeight.w500,
      ),
    ),
    bodyWidget: model.note != null
    ? Text(
      model.note ?? '',
      style: bodyText2.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.3,
      ),
      textAlign: TextAlign.center,
    )
    : const SizedBox.shrink(),

    // title: "",
    // bodyWidget: Text(
    //   model.heading,
    //   style: headline5.copyWith(
    //       // fontFamily: "CenturyGothic",
    //       height: 1.3,
    //       fontWeight: FontWeight.w500,
    //     ),
    //   textAlign: TextAlign.center,
    // ),

    image: Image.asset(
      model.image,
      fit: BoxFit.contain
    ),
    decoration: const PageDecoration(
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      // pageColor: Colors.red,
      imageFlex: 2,
      bodyFlex: 1,
      imagePadding: EdgeInsets.fromLTRB(16.0, kToolbarHeight, 16.0, 0.0),
      titlePadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, kGap*2),
      footerPadding: EdgeInsets.zero,
      bodyAlignment: Alignment.topCenter,
      imageAlignment: Alignment.bottomCenter,
      safeArea: 0
    ),
    footer: footer,
  );
}
