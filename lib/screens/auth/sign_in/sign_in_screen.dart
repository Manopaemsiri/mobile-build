import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:coffee2u/screens/bottom_nav/bottom_nav.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    this.isFirstState = false,
  });
  final bool isFirstState;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cEmail = TextEditingController();
  final TextEditingController _cPassword = TextEditingController();

  final FocusNode _fEmail = FocusNode();
  final FocusNode _fPassword = FocusNode();

  bool isShowPassword = true;

  @override
  void initState() {
    Utils.globalContext = context;
    super.initState();
  }

  @override
  void dispose() {
    _fEmail.dispose();
    _fPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    double widgetWidth = MediaQuery.of(context).size.width;
    double widgetLogoWidth = MediaQuery.of(context).size.shortestSide < 600
      ? widgetWidth / 5.5
      : MediaQuery.of(context).size.width/8;
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
                    image: AssetImage('assets/images/bg-02.jpg'),
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
                          //   "Welcome to Coffee2U",
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
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(kButtonRadius),
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
                            lController.getLang("Sign In"),
                            style: headline5.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Gap(gap: 20),
                        TextFormField(
                          controller: _cEmail,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: lController.getLang("Telephone Number"),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          focusNode: _fEmail,
                          validator: (str) => Utils.validateString(str),
                          enableInteractiveSelection: true,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) => _fPassword.requestFocus(),
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username,
                            AutofillHints.telephoneNumber,
                          ],
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            cut: true,
                            selectAll: true,
                            paste: true,
                          ),
                        ),
                        const Gap(),
                        TextFormField(
                          controller: _cPassword,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: lController.getLang("Password"),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isShowPassword = !isShowPassword;
                                });
                              },
                              icon: Icon(
                                isShowPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          onEditingComplete: () {
                            TextInput.finishAutofillContext();
                          },
                          autofillHints: const [
                            AutofillHints.password,
                          ],
                          obscureText: isShowPassword,
                          focusNode: _fPassword,
                          validator: (str) => Utils.validateString(str),
                          onFieldSubmitted: (value) => _onPressSignIn(),
                        ),
                        const Gap(),
                        ButtonFull(
                          title: lController.getLang("Sign In"),
                          onPressed: _onPressSignIn,
                        ),
                        // DividerText(text: lController.getLang("Or")),
                        // const ButtonSignInGoogle(),
                        // const Gap(gap: kHalfGap),
                        // const ButtonSignInFacebook(),
                        // const Gap(),
                        const SizedBox(height: 1.25*kGap),
                        Align(
                          child: SizedBox(
                            height: 20,
                            child: TextButton(
                              onPressed: () => Get.to(() => const ForgotPasswordScreen()),
                              child: Text(
                                lController.getLang("Forgot Password")
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onPressSignIn() async {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      CustomerController _customerController = Get.find<CustomerController>();
      final guestId = _customerController.customerModel?.id;
      await ApiService.authSignin(input: {
        "guestId": guestId,
        "username": _cEmail.text,
        "password": _cPassword.text
      }).then((value) {
        _cPassword.clear();
        if (value) {
          Get.offAll(() => const BottomNav());
        }
      });
    }
  }
}