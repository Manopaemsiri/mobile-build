import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/data/local_storage/local_storage.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/auth/onboarding/onboarding_pages.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/screens/cms/content/components/html_content.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  Future<Map<String, dynamic>?>? _future;
  final introKey = GlobalKey<IntroductionScreenState>();
  bool acceptPDPA = true;

  void _onIntroEnd() async {
    await LocalStorage.save(prefSkipIntro, true);
    Get.offAll(() => const SignInMenuScreen(isFirstState: true));
  }

  @override
  void initState() {
    _future = ApiService.processRead(
      "cms-content", input: { "url": "privacy-policy" },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.85,
            width: Get.width,
            child: IntroductionScreen(
              key: introKey,
              globalBackgroundColor: Colors.white,
              pages: [
                onboardingPages(
                  OnboardingModel(
                    heading: 'ช้อปสินค้ากาแฟ\nและเครื่องดื่มคุณภาพ\nจาก AROMA GROUP',
                    // heading: lController.getLang('text_intro_title_1').replaceAll('\\n', '\n'),
                    title: lController.getLang('text_intro_subtitle_1').replaceAll('\\n', '\n'),
                    body: lController.getLang('text_intro_desc_1').replaceAll('\\n', '\n'),
                    image: 'assets/images/onboarding/onboarding-1.png',
                  ),
                ),
                // SHIPPING
                onboardingPages(
                  OnboardingModel(
                    heading: 'ส่งฟรี* ทั่วไทย\nช้อปได้ 24 ชั่วโมง',
                    // heading: lController.getLang('text_intro_title_2').replaceAll('\\n', '\n'),
                    title: lController.getLang('text_intro_subtitle_2').replaceAll('\\n', '\n'),
                    body: lController.getLang('text_intro_desc_2').replaceAll('\\n', '\n'),
                    image: 'assets/images/onboarding/onboarding-2.png',
                    note: '*ตามเงื่อนไขที่บริษัทฯ กำหนด'
                  ),
                ),
                onboardingPages(
                  OnboardingModel(
                    heading: 'ช้อปสินค้ากาแฟ\nและเครื่องดื่มคุณภาพ\nจาก AROMA GROUP',
                    // heading: lController.getLang('text_intro_title_3').replaceAll('\\n', '\n'),
                    title: lController.getLang('text_intro_subtitle_3').replaceAll('\\n', '\n'),
                    body: lController.getLang('text_intro_desc_3').replaceAll('\\n', '\n'),
                    image: 'assets/images/onboarding/onboarding-3.png',
                  ),
                ),
                onboardingPages(
                  OnboardingModel(
                    heading: 'สะดวก สบาย\nชำระเงินได้หลายช่องทาง',
                    // heading: lController.getLang('text_intro_title_4').replaceAll('\\n', '\n'),
                    title: lController.getLang('text_intro_subtitle_4').replaceAll('\\n', '\n'),
                    body: lController.getLang('text_intro_desc_4').replaceAll('\\n', '\n'),
                    image: 'assets/images/onboarding/onboarding-4.png',
                  ),
                ),
              ],
              onDone: _onIntroEnd,
              showSkipButton: false,
              skipOrBackFlex: 0,
              nextFlex: 0,
              showBackButton: false,
              showNextButton: false,
              showDoneButton: false,
              back: const Icon(Icons.arrow_back),
              skip: const Text(
                'Skip',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              next: const Icon(Icons.arrow_forward),
              done: const Text(
                'Done',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              curve: Curves.fastLinearToSlowEaseIn,
              controlsMargin: const EdgeInsets.symmetric(vertical: 16),
              controlsPadding: EdgeInsets.zero,
              dotsDecorator: const DotsDecorator(
                shape: CircleBorder(),
                color: Color(0xFFBDBDBD),
                activeShape: CircleBorder(),
              ),
            ),
          ),
          Container(
            height: Get.height * 0.15,
            width: Get.width,
            color: kWhiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonHalf(
                  title: lController.getLang('Get Started'),
                  onPressed: (){
                    _onIntroEnd();
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    pdpaAlert(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: acceptPDPA,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(kButtonRadius),
                          ),
                        ),
                        onChanged: (value) {
                        },
                      ),
                      Text(
                        lController.getLang('text_privacy_policy_1'),
                        style: bodyText2,
                      ),
                      const SizedBox(width: kQuarterGap),
                      Text(
                        lController.getLang('Privacy Policy'),
                        style: bodyText2.copyWith(color: kAppColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> pdpaAlert(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<Map<String, dynamic>?>(
          future: _future,
          builder: (context, snapshot) {
            CmsContentModel? item;

            if(snapshot.hasData){
              item = CmsContentModel.fromJson(snapshot.data!['result']);

              if(!item.isValid()) return const SizedBox.shrink();

              final widgetTitle = item.title == ''
                ? lController.getLang('Privacy Policy'): item.title;
              final widgetContent = item.content;
              return AlertDialog(
                title: Text(
                  widgetTitle,
                  style: subtitle1.copyWith(fontWeight: FontWeight.w500),
                ),
                content: Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: false,
                  child: Container(
                    height: Get.height * 0.4,
                    width: Get.width,
                    padding: const EdgeInsets.fromLTRB(0, 0, kGap, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kButtonRadius),
                    ),
                    child: ListView(
                      children: [
                        HtmlContent(content: widgetContent),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      lController.getLang("Close"),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}
