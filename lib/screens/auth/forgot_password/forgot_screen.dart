
import 'dart:io';

import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({ Key? key ,required this.resetToken }) : super(key: key);
  final String resetToken;
  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  bool isResendOTP = false;

  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _cPassword = TextEditingController();
  final TextEditingController _cConfirmPassword = TextEditingController();

  final FocusNode _fPassword = FocusNode();
  final FocusNode _fConfirmPassword = FocusNode();

  bool isShowPassword = false;
  bool isShowConfirmPassword = false;

  
  @override
  void dispose() {
    _fPassword.dispose();
    _fConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    double _width = MediaQuery.of(context).size.width;
    double _logoWidth = _width / 5.5;
    double _hRatio = 0.27;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Get.height * _hRatio,
                width: Get.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-02.jpg'),
                    fit: BoxFit.fill
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
                            height: _logoWidth
                          ),
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
                height: _appBarHeight,
                width: double.infinity,
                child: AppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarBrightness: Brightness.dark,
                    statusBarIconBrightness: Brightness.light
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundColor: kWhiteColor,
                  leading: Container(
                    margin: const EdgeInsets.only(left: kGap),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kAppColor,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Platform.isIOS
                          ? Icons.arrow_back_ios_outlined
                          : Icons.arrow_back_outlined),
                        splashRadius: 1.25*kGap,
                        onPressed: () => Get.until((route) => Get.currentRoute == "/ForgotPasswordScreen"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Get.height * (1.05 - _hRatio),
                width: Get.width,
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(kButtonRadius)
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: AutofillGroup(
                    onDisposeAction: AutofillContextAction.commit,
                    child: ListView(
                      physics: const RangeMaintainingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(2 * kGap),
                      children: [
                        Align(
                          child: Text(
                            lController.getLang("Forget Password"),
                            style: headline5.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Gap(gap: 20),
                        TextFormField(
                          controller: _cPassword,
                          focusNode: _fPassword,
                          obscureText: !isShowPassword,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: lController.getLang("New Password"),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() => isShowPassword = !isShowPassword);
                              },
                              icon: Icon(
                                isShowPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) => Utils.validatePassword(_cPassword.text, _cConfirmPassword.text, 1),
                          onFieldSubmitted: (str) => FocusScope.of(context).unfocus(),
                        ),
                        const SizedBox(height: kGap),
                        TextFormField(
                          controller: _cConfirmPassword,
                          focusNode: _fConfirmPassword,
                          obscureText: !isShowConfirmPassword,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: lController.getLang("Confirm New Password"),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() => isShowConfirmPassword = !isShowConfirmPassword);
                              },
                              icon: Icon(
                                isShowConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) => Utils.validatePassword(_cPassword.text, _cConfirmPassword.text, 2),
                          onFieldSubmitted: (str) => FocusScope.of(context).unfocus(),
                        ),
                        const Gap(),
                        ButtonFull(
                          title: lController.getLang("Reset Password"),
                          onPressed: _onPress,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPress() async {
    FocusManager.instance.primaryFocus?.unfocus();
    
    if(_formKey.currentState!.validate()){

      final temp = await ApiService.customerResetPassword(
        input: {
          "resetToken": widget.resetToken,
          "newPassword": _cPassword.text.trim(),
          "confirmNewPassword": _cConfirmPassword.text.trim(),
        }
      );
      if(temp){
        ShowDialog.showForceDialog(
          lController.getLang("text_reset_password_1"), 
          lController.getLang("text_forgot_password_2"), 
          () => Get.until((route) => Get.currentRoute == "/SignInScreen"),
          confirmText: lController.getLang("Sign In"),
        );
      }
      
    }
  }
}
