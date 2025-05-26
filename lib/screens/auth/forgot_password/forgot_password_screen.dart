import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/apis/res_api_error.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/auth/otp/otp_password_screen.dart';
import 'package:coffee2u/screens/auth/sign_up/components/telephone_format.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cTelephone = TextEditingController();
  final FocusNode _fTelephone = FocusNode();
  bool isResendOTP = false;

  int enabledCustomerSignupOTP = -1;

  @override
  void initState() {
    super.initState();
    getDataSetting();
  }

  Future<void> getDataSetting() async {
    try {
      Map<String, dynamic>? res = await ApiService.processRead("setting", input: { 'name': 'ENABLED_CUSTOMER_SIGNUP_OTP' });
      if(res!=null) enabledCustomerSignupOTP = int.parse(res['result'].toString());
    } catch (_) {}
  }
  
  @override
  void dispose() {
    _fTelephone.dispose();
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
                            width: _logoWidth,
                            height: _logoWidth,
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
                height: _appBarHeight,
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
                height: Get.height * (1.05 - _hRatio),
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
                            lController.getLang("Forgot Password"),
                            style: headline5.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Gap(gap: 20),
                        AutofillGroup(
                          onDisposeAction: AutofillContextAction.commit,
                          child: TextFormField(
                            controller: _cTelephone,
                            decoration: InputDecoration(
                              counterText: '',
                              border: const OutlineInputBorder(),
                              labelText: lController.getLang("Telephone Number")
                                +' *',
                              prefixIcon: const Icon(Icons.phone_rounded),
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(12),
                              TelephoneFormatter(
                                mask: 'xxx-xxx-xxxx',
                                separator: '-',
                              ),
                            ],
                            autofillHints: const [
                              AutofillHints.telephoneNumber,
                            ],
                            textInputAction: TextInputAction.next,
                            maxLength: 12,
                            focusNode: _fTelephone,
                            validator: (value) => Utils.validatePhone(value!.replaceAll('-', '')),
                            onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                          ),
                        ),
                        const Gap(),
                        ButtonFull(
                          title: lController.getLang("Request OTP"),
                          onPressed: _onPressReset,
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

  void _onPressReset() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(_formKey.currentState!.validate()){
      String _telephone = _cTelephone.text.replaceFirst(RegExp(r'0'), '+66').trim();
      _telephone = _telephone.replaceAll('-', '');
      _telephone = _telephone.replaceAll(' ', '');
      
      bool res = await ApiService.customerCheckDuplicate(input: {
        "telephone": _telephone,
      });
      if(res == false){
        ShowDialog.showForceDialog(
          "Error",
          "No Data Found", 
          () => Get.back()
        );
      }else{
        Get.back();
        if(enabledCustomerSignupOTP == 1){
          ShowDialog.showLoadingDialog();
          try {
            await ApiService.customerForgetPassword(input: {"telephone": _telephone}).then((value) async {
              if(value != null && value["data"]["resetToken"] != null){
                final resetToken = value["data"]["resetToken"];
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: _telephone,
                  verificationCompleted: (_) {},
                  verificationFailed: (e) {
                    Get.back();
                    ShowDialog.showErrorToast(desc: e.message.toString());
                  },
                  codeSent: (String verificationId, int? resendToken){
                    Get.back();
                    if(!isResendOTP){
                      Get.to(() => OtpPasswordScreen(
                        verificationID: verificationId,
                        resendToken: resendToken,
                        telephone: _telephone,
                        resetToken: resetToken ?? '',
                        enabledCustomerSignupOTP: enabledCustomerSignupOTP,
                      ));
                    }else{
                      // Resend OTP
                    }
                  },
                  codeAutoRetrievalTimeout: (_){
                    Get.back();
                  },
                );
              }else{
                final res1 = ResApiError.fromJson(value!).error;
                final temp = res1?.errorText();
                ShowDialog.showForceDialog(
                  lController.getLang('Error'), "$temp",
                  () => Get.back()
                );
              }
            });
          }on FirebaseException catch (e){
            Get.back();
            ShowDialog.showForceDialog(
              lController.getLang('Error'), e.message.toString(),
              (){ Get.back(); Get.back(); }
            );
          }on PlatformException catch (e){
            Get.back();
            ShowDialog.showForceDialog(
              lController.getLang('Error'), e.message ?? '',
              (){ Get.back(); Get.back(); }
            );
          }catch (e){
            Get.back();
            ShowDialog.showForceDialog(
              lController.getLang('Error'), e.toString(),
              (){ Get.back(); Get.back(); }
            );
          }
        }else if(enabledCustomerSignupOTP == 2){
          ShowDialog.showLoadingDialog();
          try {
            await ApiService.customerForgetPassword(input: {"telephone": _telephone}).then((value) async {
              if(value != null && value["data"]["resetToken"] != null){
                final resetToken = value["data"]["resetToken"];
                String _telephone = _cTelephone.text.replaceFirst(RegExp(r'0'), '+66').trim();
                _telephone = _telephone.replaceAll('-', '');
                _telephone = _telephone.replaceAll(' ', '');
                Map<String, dynamic>? res1 = await ApiService.sendOTP(telephone: _telephone, telephoneCode: '+66');
                Get.back();
                if(res1 != null){
                  if(res1['requestId']?.isNotEmpty == true && res1['refCode']?.isNotEmpty == true){
                    Get.to(() => OtpPasswordScreen(
                      telephone: _telephone,
                      telephoneCode: '+66',
                      response: res1,
                      enabledCustomerSignupOTP: enabledCustomerSignupOTP,
                      resetToken: resetToken ?? '',
                    ));
                  }
                }
              }else{
                final res1 = ResApiError.fromJson(value!).error;
                final temp = res1?.errorText();
                ShowDialog.showForceDialog(
                  lController.getLang('Error'), "$temp",
                  () => Get.back()
                );
              }
            });
          } catch (_) {
            Get.back();
          }
        }
      }
    }
  }
}