import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/auth/onboarding/onboarding_screen.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  
  List<Map<String, dynamic>> data = [];
  Map<String, dynamic> selectedValue = {};
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      List<Map<String, dynamic>> items = systemLanguages.map((e) => {"value": e, "name": '', 'icon': ''}).toList();
      for (var e in items) { 
        switch (e['value']) {
          case 'th':
            e["name"] = 'Thai';
            e["icon"] = 'assets/images/flag/${e['value'].toUpperCase()}.jpg';
            break;
          case 'ko':
            e["name"] = 'Korean';
            e["icon"] = 'assets/images/flag/${e['value'].toUpperCase()}.jpg';
            break;
          case 'zh':
            e["name"] = 'Chinese';
            e["icon"] = 'assets/images/flag/${e['value'].toUpperCase()}.jpg';
            break;
          default:
            e["name"] = 'English';
            e["icon"] = 'assets/images/flag/${e['value'].toUpperCase()}.jpg';
            break;
        }
      }

      if(mounted){
        setState(() {
          data = items;
          selectedValue = data.firstWhere((e) => e["value"] == lController.languageCode);
        });
      }
    } catch (e) {
      if(kDebugMode) printError(info: '$e');
    }
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: GetBuilder<LanguageController>(builder: (lc) {
          return Stack(
            children: [
              Positioned(
                top: Get.height*0.45 - (kToolbarHeight+MediaQuery.of(context).padding.top) - kGap*3.5,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: min(Get.width * 0.75, 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                      lc.getLang('Welcome To'),
                      textAlign: TextAlign.center,
                      style: headline5.copyWith(
                        fontWeight: FontWeight.w500,
                        color: kWhiteColor
                      ),
                      ),
                      const Gap(gap: kHalfGap),
                      SizedBox(
                        width: min(Get.width*0.4, 172.0),
                        child: Image.asset("assets/images/logo-app-white.png")
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: const [0.7, 1.0],
                  )
                ),
              ),
              Positioned(
                bottom: kGap*3.5,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: min(Get.width * 0.75, 300),
                    child: Column(
                      children: [
                        if(systemLanguages.length > 1)...[
                          Container(
                            height: kToolbarHeight,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kQuarterGap),
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(kRadius),
                            ),
                            child: Center(
                              child: DropdownButton<dynamic>(
                                isExpanded: true,
                                value: selectedValue,
                                borderRadius: BorderRadius.circular(kRadius),
                                onChanged: (value) => onSelectedLanguage(value),
                                items: data.map<DropdownMenuItem<dynamic>>((value) => DropdownMenuItem<dynamic>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      if(value["icon"] != '')...[
                                        Container(
                                          height: 24,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.3),
                                                spreadRadius: 3,
                                                blurRadius: kGap,
                                                offset: const Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                          child: AspectRatio(
                                            aspectRatio: 3/2,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.all(Radius.circular(kRadius*0.3)),
                                              child: Image.asset(
                                                value["icon"],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Gap(),
                                      ],
                                      Text(
                                        (value["name"] ?? ''),
                                        style: title.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                )).toList(),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: kAppColor,
                                ),
                                underline: const SizedBox.shrink(),
                              ),
                            ),
                          ),
                          const Gap(gap: kOtGap),
                        ],
                        ButtonFull(
                          title: systemLanguages.length>1? lController.getLang("Choose Language"): lController.getLang("Get Started"),
                          onPressed: () => onSubmit(context),
                          color: kAppColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      )
    );
  }

  void onSelectedLanguage(value) {
    if(value != null){
      setState(() => selectedValue = value);
      lController.refreshData(code: selectedValue["value"]);
    }
  }

  void onSubmit(BuildContext context)  
    =>  Get.offAll(() => const OnboardingScreen(), transition: Transition.noTransition);
}