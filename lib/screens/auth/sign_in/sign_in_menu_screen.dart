import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_screen.dart';
import 'package:coffee2u/screens/auth/sign_up/sign_up_screen.dart';
import 'package:coffee2u/screens/bottom_nav/bottom_nav.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignInMenuScreen extends StatefulWidget {
  const SignInMenuScreen({
    Key? key,
    this.isFirstState = false,
  }): super(key: key);
  
  final bool isFirstState;

  @override
  State<SignInMenuScreen> createState() => _SignInMenuScreenState();
}

class _SignInMenuScreenState extends State<SignInMenuScreen>  {
  final LanguageController lController = Get.find<LanguageController>();
  TextEditingController cEmail = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  final FocusNode _fEmail = FocusNode();
  final FocusNode _fPassword = FocusNode();

  bool isShowPassword = true;

  @override
  void initState() {
    super.initState();
    Utils.globalContext = context;
  }

  @override
  void dispose() {
    _fEmail.dispose();
    _fPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _logoWidth = MediaQuery.of(context).size.shortestSide < 600
      ? _width / 5.5: MediaQuery.of(context).size.width/8;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Get.height * 0.65,
                width: Get.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/logo-app-white.png',
                            width: _logoWidth,
                            height: _logoWidth,
                          ),
                          const Gap(gap: kHalfGap),
                          Text(
                            "${lController.getLang('Welcome to')} $appName",
                            style: subtitle1.copyWith(
                              fontFamily: "CenturyGothic",
                              color: kWhiteColor,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Get.height * 0.45,
                width: Get.width,
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(kButtonRadius),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2*kGap, 0, 2*kGap, 2*kGap),
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            ButtonCustom(
                              title: lController.getLang("Sign In"),
                              onPressed: _onPressSignIn,
                              textStyle: headline6,
                              width: MediaQuery.of(context).size.shortestSide < 600
                                ? null
                                : MediaQuery.of(context).size.width*0.4
                            ),
                            const SizedBox(height: kOtGap),
                            ButtonCustom(
                              onPressed: _onPressSignUp,
                              title: lController.getLang("Sign Up"),
                              isOutline: true,
                              textStyle: headline6,
                              width: MediaQuery.of(context).size.shortestSide < 600
                                ? null
                                : MediaQuery.of(context).size.width*0.4
                            ),
                            if(widget.isFirstState) ...[
                              const SizedBox(height: kOtGap),
                              ButtonCustom(
                                title: lController.getLang("Start Without Account"),
                                onPressed: _onPressNoMember,
                                isOutline: true,
                                textStyle: headline6,
                                width: MediaQuery.of(context).size.shortestSide < 600
                                ? null
                                : MediaQuery.of(context).size.width*0.4
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!widget.isFirstState) ...[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).padding.top + kToolbarHeight,
                  width: double.infinity,
                  child: AppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarBrightness: Brightness.dark,
                      statusBarIconBrightness: Brightness.light,
                    ),
                    backgroundColor: Colors.transparent,
                    foregroundColor: kWhiteColor,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _onPressSignIn() {
    Get.to(() => SignInScreen(
      isFirstState: widget.isFirstState,
    ));
  }

  void _onPressSignUp() {
    Get.to(() => SignUpScreen(
      isFirstState: widget.isFirstState,
    ));
  }

  Future<void> _onPressNoMember() async {
    if (widget.isFirstState) {
      Get.offAll(() => const BottomNav());
    } else {
      Get.to(() => const BottomNav());
    }
  }
}