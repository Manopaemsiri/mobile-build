import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _duration = Duration(seconds: 2);
const _animationDuration = Duration(milliseconds: 600);

class ShowDialog {
  static showSuccessToast({String? title, required String desc}) {
    final LanguageController lController = Get.find<LanguageController>();
    Get.snackbar(
      title ?? lController.getLang("Successed"),
      desc,
      icon: const Icon(Icons.check, color: kGreenColor),
      duration: _duration,
      borderColor: kGreenColor,
      borderWidth: 1,
      borderRadius: kRadius,
      backgroundColor: kWhiteColor,
      margin: kPadding,
    );
  }

  static showWarningToast({String? title, required String desc}) {
    final LanguageController lController = Get.find<LanguageController>();
    Get.snackbar(
      title ?? lController.getLang("Warning"),
      desc,
      icon: const Icon(Icons.info_outline, color: kYellowColor),
      duration: _duration,
      borderColor: kYellowColor,
      borderWidth: 1,
      borderRadius: kRadius,
      backgroundColor: kWhiteColor,
      margin: kPadding,
    );
  }

  static showErrorToast({String? title, required String desc}) {
    final LanguageController lController = Get.find<LanguageController>();
    Get.snackbar(
      title ?? lController.getLang("Error"),
      desc,
      icon: const Icon(Icons.close_sharp, color: kRedColor),
      duration: _duration,
      animationDuration: _animationDuration,
      borderColor: kRedColor,
      borderWidth: 1,
      borderRadius: kRadius,
      backgroundColor: kWhiteColor,
      margin: kPadding,
    );
  }

  static showOptionDialog(String title, String message, Function() onConfirm) {
    final LanguageController lController = Get.find<LanguageController>();
    Get.defaultDialog(
      title: title,
      radius: kRadius,
      middleText: message,
      cancel: ButtonCustom(
        width: 100,
        height: kButtonMiniHeight,
        isOutline: true,
        onPressed: () {
          Get.back();
        },
        title: lController.getLang("no_1"),
      ),
      confirm: ButtonCustom(
        width: 100,
        height: kButtonMiniHeight,
        onPressed: onConfirm,
        title: lController.getLang("Yes"),
      ),
    );
  }

  static showForceDialog(
    String titleText, String message, Function() onConfirm,
    { String? confirmText, Function()? onCancel, String? cancelText, bool translate = true, Widget? content }
  ) {
    final LanguageController lController = Get.find<LanguageController>();
    Get.defaultDialog(
      title: translate? lController.getLang(titleText): titleText,
      radius: kRadius,
      middleText: translate? lController.getLang(message): message,
      barrierDismissible: false,
      titlePadding: const EdgeInsets.fromLTRB(kHalfGap, kHalfGap, kHalfGap, 0),
      titleStyle: title.copyWith(fontWeight: FontWeight.w500),

      content: content ??
      Text(
        translate ? lController.getLang(message) : message,
        style: subtitle1,
        textAlign: TextAlign.center,
      ),

      middleTextStyle: subtitle1,
      confirm: Padding(
        padding: const EdgeInsets.symmetric(vertical: kQuarterGap),
        child: ButtonCustom(
          width: 100,
          height: kButtonMiniHeight,
          onPressed: onConfirm,
          title: confirmText ?? lController.getLang("Ok"),
        ),
      ),
      cancel: onCancel == null
        ? null
        : Padding(
          padding: const EdgeInsets.symmetric(vertical: kQuarterGap),
          child: ButtonCustom(
            width: 100,
            isOutline: true,
            height: kButtonMiniHeight,
            title: cancelText ?? lController.getLang('Cancel'),
            onPressed: onCancel,
          ),
        ),
    );
  }


  static dialogChoiceButtons({
    required String titleText,
             String message = '',

    required Function() onConfirm,
    required Function() onSecondary,

    String? confirmText,
    String? secondaryText,

    bool translate = true,
    Widget? content,
    }) {
      
    final LanguageController lController = Get.find<LanguageController>();

    Get.defaultDialog(
      title: '',
      radius: kRadius,
      barrierDismissible: false,
      titlePadding: EdgeInsets.zero,
      titleStyle: const TextStyle(fontSize: 0), 

      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.chevron_left),
                iconSize: 24,
                splashRadius: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Expanded(
                child: Text(
                  lController.getLang(titleText),
                  style: title.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

      
        content ??
          Text(
            translate ? lController.getLang(message) : message,
            style: subtitle1,
            textAlign: TextAlign.center,
          ),
        ],
      ),

      middleText: '', 
      
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ButtonCustom(
            width: 100,
            height: kButtonMiniHeight,
            title: secondaryText ?? lController.getLang("เฉพาะครั้งนี้"),
            isOutline: true,
            onPressed: onSecondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ButtonCustom(
            width: 100,
            height: kButtonMiniHeight,
            title: confirmText ?? lController.getLang("ทุกครั้ง"),
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }


  static showLoadingDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => true,
        child: Center(
          child: Container(
            padding: kPadding,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(kRadius))
            ),
            // child: const CircularProgressIndicator(),
            child: Image.asset(
              'assets/images/loader.gif',
              height: 80,
              width: 80,
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: kWhiteColor.withOpacity(0.5)
    );
  }
}