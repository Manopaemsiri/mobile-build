import 'dart:async';
import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/auth/forgot_password/forgot_screen.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPasswordScreen extends StatefulWidget {
  OtpPasswordScreen({
    super.key,
    required this.telephone,
    this.telephoneCode = '+66',

    required this.enabledCustomerSignupOTP,

    this.verificationID,
    this.resetToken,
    this.resendToken,

    this.response,
  });
  
  final String telephone;
  final String telephoneCode;

  final int enabledCustomerSignupOTP;

  String? verificationID;
  String? resetToken;
  int? resendToken;
  
  Map<String, dynamic>? response;

  @override
  State<OtpPasswordScreen> createState() => _OtpPasswordScreenState();
}

class _OtpPasswordScreenState extends State<OtpPasswordScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final int _otpLength = 6;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  var errorController = StreamController<ErrorAnimationType>();

  late Timer? _timer;
  int _start = 30;

  @override
  void initState(){
    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if(_start == 0){
          setState(() => timer.cancel());
        }else{
          setState(() => _start--);
        }
      },
    );
  }

  void _onResendOTP() async {
    _controller.clear();
    if(widget.enabledCustomerSignupOTP == 1){
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.telephone,
        verificationCompleted: (_){},
        verificationFailed: (e){
          Get.back();
          ShowDialog.showErrorToast(desc: e.message.toString());
        },
        codeSent: (String verificationId, int? resendToken){
          widget.verificationID = verificationId;
          setState(() => _start = 30);
          startTimer();
        },
        codeAutoRetrievalTimeout: (_){
          Get.back();
        },
      );
    }else if(widget.enabledCustomerSignupOTP == 2){
      Map<String, dynamic>? res = await ApiService.sendOTP(telephone: widget.telephone, telephoneCode: widget.telephoneCode);
      if(res != null){
        if(res['requestId']?.isNotEmpty == true && res['refCode']?.isNotEmpty == true){
          widget.response = res;
        }
      }
      setState(() => _start = 30);
      startTimer();
    }
  }

  @override
  void dispose() {
    errorController.close();
    if(_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    double widgetWidth = MediaQuery.of(context).size.width;
    double widgetLogoWidth = widgetWidth / 5.5;
    double ratioHeight = 0.27;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Get.height * ratioHeight,
                width: Get.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/sign-in-bg.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/logo-app-white.png',
                            width: widgetLogoWidth,
                            height: widgetLogoWidth,
                          ),
                          // const Gap(gap: kHalfGap),
                          // Text(
                          //   "Welcome To Coffee2U",
                          //   style: subtitle1.copyWith(
                          //     fontFamily: "CenturyGothic",
                          //     color: kWhiteColor,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SizedBox(
                height: appBarHeight,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Get.height * (1.05 - ratioHeight),
                width: Get.width,
                padding: const EdgeInsets.all(2 * kGap),
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(kButtonRadius),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            lController.getLang("Confirm Telephone"),
                            style: headline5.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: kQuarterGap),
                          Text(
                            lController.getLang("text_otp1"),
                            style: subtitle1.copyWith(
                              fontFamily: 'Kanit',
                              color: kDarkLightColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            widget.telephone.replaceFirst('+66', '0'),
                            style: title.copyWith(
                              fontFamily: 'Kanit',
                              color: kDarkLightColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Gap(),
                      PinCodeTextField(
                        controller: _controller,
                        appContext: context,
                        length: _otpLength,
                        autoFocus: true,
                        obscureText: false,
                        obscuringCharacter: '-',
                        animationType: AnimationType.fade,
                        animationDuration: const Duration(milliseconds: 300),
                        keyboardType: TextInputType.number,
                        cursorColor: kAppColor,
                        textStyle: title,
                        hintCharacter: '*',
                        hintStyle: title,
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(4),
                          fieldHeight: 60,
                          fieldWidth: 50,
                          borderWidth: 2,
                          inactiveColor: kAppColor.withValues(alpha: 0.4),
                          inactiveFillColor: kWhiteColor,
                          activeColor: kAppColor,
                          selectedColor: kAppColor,
                          selectedFillColor: kWhiteColor,
                          activeFillColor: kWhiteColor,
                        ),
                        errorAnimationController: errorController,
                        pastedTextStyle: const TextStyle(
                          color: kAppColor,
                          fontWeight: FontWeight.w600,
                        ),
                        onCompleted: (String value) {
                          onTap();
                        },
                        onChanged: (String value) {},
                        beforeTextPaste: (String? value) {
                          return true;
                        },
                      ),
                      const Gap(),
                      ButtonFull(
                        title: lController.getLang("Verify"),
                        onPressed: onTap,
                      ),
                      const Gap(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _start == 0 ? _onResendOTP : null,
                            child: RichText(
                              text: TextSpan(
                                text: lController.getLang("Send OTP Again"),
                                style: subtitle1.copyWith(
                                  color: _start == 0? kDarkLightColor: kLightColor,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  fontFamily: "Kanit",
                                ),
                                children: <TextSpan>[
                                  if (_start != 0) ...[
                                    TextSpan(
                                      text: " $_start ${lController.getLang("second")}",
                                      style: subtitle2.copyWith(
                                        color: kDarkLightColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Kanit",
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onTap() async {
    if(_controller.text.length != _otpLength){
      errorController.add(ErrorAnimationType.shake);
      return;
    }

    if(widget.enabledCustomerSignupOTP == 1){
      ShowDialog.showLoadingDialog();
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationID!,
          smsCode: _controller.text,
        );

        await FirebaseAuth.instance.signInWithCredential(credential)
          .then((userCredential) async {
            Get.back();
            User? _user = userCredential.user;
            final phone = _user?.phoneNumber;

            if(phone != null){
              if (kDebugMode) {
                print(_user);
                print(phone);
              }
              //+66 Format
              Get.to(() => ForgotScreen(resetToken: widget.resetToken!));
            }else{
              ShowDialog.showErrorToast(desc: lController.getLang("Error"));
            }
          });
      } on FirebaseException catch (e) {
        Get.back();
        if (e.code == 'invalid-verification-code') {
          ShowDialog.showErrorToast(
            desc: lController.getLang("text_otp_error1"),
          );
        } else {
          ShowDialog.showErrorToast(desc: e.message.toString());
        }
      }
    }else if(widget.enabledCustomerSignupOTP == 2){
      if(widget.response == null) return;
      try {
        Map<String, dynamic> input = widget.response!;
        input['code'] = _controller.text;
        Map<String, dynamic>? res = await ApiService.verifyOTP(input: input);
        if(res != null){
          if(res['requestId']?.isNotEmpty == true && res['refCode']?.isNotEmpty == true){
            Get.to(() => ForgotScreen(resetToken: widget.resetToken!));
          }
        }else{
          if(mounted) setState(() => _controller.clear());
        }
      } catch (_) {}
    }
  }
}