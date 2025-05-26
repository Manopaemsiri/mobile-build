import 'dart:convert';
import 'dart:io';

import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/auth/otp/otp_screen.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_screen.dart';
import 'package:coffee2u/screens/auth/sign_up/components/telephone_format.dart';
import 'package:coffee2u/screens/cms/content/components/html_content.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'group_sign_up/tax_id/tax_id_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
    this.isFirstState = false,
    this.backTo,
  }): super(key: key);

  final bool isFirstState;
  final String? backTo;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  Future<Map<String, dynamic>?>? _future;
  final _formKey = GlobalKey<FormState>();

  List<CustomerGroupModel> customerGroups = [];

  final TextEditingController _cFirstname = TextEditingController();
  final TextEditingController _cLastname = TextEditingController();
  final TextEditingController _cEmail = TextEditingController();
  final TextEditingController _cPassword = TextEditingController();
  final TextEditingController _cConfirmPassword = TextEditingController();
  final TextEditingController _cTelephone = TextEditingController();

  final FocusNode _fFirstname = FocusNode();
  final FocusNode _fLastname = FocusNode();
  final FocusNode _fUsername = FocusNode();
  final FocusNode _fEmail = FocusNode();
  final FocusNode _fPassword = FocusNode();
  final FocusNode _fConfirmPassword = FocusNode();
  final FocusNode _fTelephone = FocusNode();

  String cardNumber = "";
  String prefix = "";
  String prefixEN = "";
  String firstnameEN = "";
  String lastnameEN = "";
  String birthDate = "";
  String address = "";
  String subdistrict = "";
  String district = "";
  String province = "";
  String zipcode = "";

  bool isShowPassword = true;
  bool isShowConfirmPassword = true;

  bool isResendOTP = false;

  bool acceptPDPA = true;

  ImagePicker picker = ImagePicker();
  bool isScan = false;
  
  bool passwordLength = false;
  bool passwordNumber = false;
  bool passwordSymbol = false;

  int enabledCustomerSignupOTP = -1;

   @override
  void initState() {
    _initState();
    super.initState();
  }

  Future<void> readCmsContent() async {
    try {
      _future =  ApiService.processRead(
      "cms-content",
      input: {"url": "privacy-policy"},
    );
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }
  Future<void> customerGroupList() async {
    try {
      final Map<String, dynamic> input = {
        'dataFilter': {
          'status': 1,
          'enableRegistration': 1,
        }
      };
      final Map<String, dynamic>? res  = await ApiService.processList(
        "customer-groups",
        input: input,
      );
      final int len = res?['result'].length ?? 0;
      for (var i = 0; i < len; i++) {
        customerGroups.add(CustomerGroupModel.fromJson(res?['result'][i]));
      }
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }
  Future<void> getSignUpSetting() async {
    try {
      Map<String, dynamic>? res = await ApiService.processRead("setting", input: { 'name': 'ENABLED_CUSTOMER_SIGNUP_OTP' });
      if(res!=null) enabledCustomerSignupOTP = int.parse(res['result'].toString());
    } catch (_) {}
  }
  void _initState() async {
    await Future.wait([
      readCmsContent(),
      customerGroupList(),
      getSignUpSetting(),
    ]);

    if(mounted) setState((){});
  }

  @override
  void dispose() {
    _fFirstname.dispose();
    _fLastname.dispose();
    _fUsername.dispose();
    _fEmail.dispose();
    _fPassword.dispose();
    _fConfirmPassword.dispose();
    _fTelephone.dispose();
    super.dispose();
  }

  Future<void> takePhoto() async {
    try {
      XFile? picked = await picker.pickImage(source: ImageSource.camera);
      if(picked != null) {
        Uint8List unit8List = File(picked.path).readAsBytesSync();
        String base64Image = base64Encode(unit8List);
        final input = {
          "cardType": "thai-national-id-card",
          "cardUri": base64Image
        };
        final res = await ApiService.cardScanner(input: input);
        if(res["result"].isNotEmpty){
          setState(() {
            isScan = true;
            _cFirstname.text = res["result"]["firstname"] ?? "";
            _cLastname.text = res["result"]["lastname"] ?? "";
            cardNumber = res["result"]["cardNumber"] ?? "";
            prefix = res["result"]["prefix"] ?? "";
            prefixEN = res["result"]["prefixEN"] ?? "";
            firstnameEN = res["result"]["firstnameEN"] ?? "";
            lastnameEN = res["result"]["lastnameEN"] ?? "";
            birthDate = res["result"]["birthDate"] ?? "";
            address = res["result"]["address"] ?? "";
            subdistrict = res["result"]["subdistrict"] ?? "";
            district = res["result"]["district"] ?? "";
            province = res["result"]["province"] ?? "";
            zipcode = res["result"]["zipcode"] ?? "";
          });
          showScanInfo(context);
        }else {
          setState(() {
            isScan = false;
          });
          ShowDialog.showForceDialog("Error", "text_card_scan_error_1", () => Get.back());
        }
      }
    } catch (e) {
      if(kDebugMode) printError(info: '$e');
      setState(() {
        isScan = false;
      });
    }
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
                          const Gap(gap: kHalfGap),
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
                  child: ListView(
                    padding: const EdgeInsets.all(kGap * 2),
                    physics: const RangeMaintainingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Align(
                        child: Text(
                          lController.getLang("Sign Up"),
                          style: headline5.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Gap(gap: 20),
                      TextFormField(
                        controller: _cFirstname,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lController.getLang("First Name")
                            +' *',
                          prefixIcon: const Icon(Icons.person),
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: _fFirstname,
                        validator: (value) => Utils.validateString(value),
                        onFieldSubmitted: (value) => _fLastname.requestFocus(),
                      ),
                      const Gap(),
                      TextFormField(
                        controller: _cLastname,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lController.getLang("Last Name")
                            +' *',
                          prefixIcon: const Icon(Icons.person),
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: _fLastname,
                        validator: (value) => Utils.validateString(value),
                        onFieldSubmitted: (value) => _fTelephone.requestFocus(),
                      ),
                      const Gap(),

                      TextFormField(
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
                        textInputAction: TextInputAction.next,
                        maxLength: 12,
                        focusNode: _fTelephone,
                        validator: (value) => Utils.validatePhone(value!.replaceAll('-', '')),
                        onFieldSubmitted: (value) => _fEmail.requestFocus(),
                      ),
                      const Gap(),
                      TextFormField(
                        controller: _cEmail,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lController.getLang("Email"),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        focusNode: _fEmail,
                        textInputAction: TextInputAction.done,
                        validator: (value) => Utils.validateEmail(value),
                        onFieldSubmitted: (value) => _fPassword.requestFocus(),
                      ),
                      const Gap(),

                      TextFormField(
                        controller: _cPassword,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lController.getLang("Password")+' *',
                          prefixIcon: const Icon(Icons.lock),
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
                        textInputAction: TextInputAction.next,
                        obscureText: isShowPassword,
                        focusNode: _fPassword,
                        validator: (value) => Utils.validatePassword(value, _cConfirmPassword.text, 1),
                        onFieldSubmitted: (value) => _fConfirmPassword.requestFocus(),
                        onChanged: (value) {
                          if(value.length >= 6){
                            setState(() => passwordLength = true);
                          }else {
                            setState(() => passwordLength = false);
                          }

                          if(value.contains(RegExp(r'[0-9]'))){
                            setState(() => passwordNumber = true);
                          }else {
                            setState(() => passwordNumber = false);
                          }

                          if(Utils.isContainSpecialChar(value)){
                            setState(() => passwordSymbol = true);
                          }else {
                            setState(() => passwordSymbol = false);
                          }
                        },
                      ),
                      const Gap(),
                      TextFormField(
                        controller: _cConfirmPassword,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lController.getLang("Confirm Password")
                            +' *',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isShowConfirmPassword = !isShowConfirmPassword;
                              });
                            },
                            icon: Icon(
                              isShowConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        obscureText: isShowConfirmPassword,
                        focusNode: _fConfirmPassword,
                        validator: (value) => Utils.validatePassword(_cPassword.text, _cConfirmPassword.text, 2),
                      ),

                      const Gap(),
                      Text(
                        lController.getLang('text_suggest_password_1'),
                        style: subtitle1.copyWith(
                          fontFamily: 'Kanit',
                          color: kDarkLightColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' \u2022 ${lController.getLang('At least')} 6 ${lController.getLang('characters')}',
                        style: subtitle1.copyWith(
                          fontFamily: 'Kanit',
                          color: passwordLength? kGreenColor: kDarkLightGrayColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        ' \u2022 ${lController.getLang('Number')} 0-9 ${lController.getLang('At least')} 1 ${lController.getLang('characters')}',
                        style: subtitle1.copyWith(
                          fontFamily: 'Kanit',
                          color: passwordNumber? kGreenColor: kDarkLightGrayColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        ' \u2022 ${lController.getLang('Symbol')} * ! @ # \$ & ? % ^ ( ) ${lController.getLang('At least')} 1 ${lController.getLang('characters')}',
                        style: subtitle1.copyWith(
                          fontFamily: 'Kanit',
                          color: passwordSymbol? kGreenColor: kDarkLightGrayColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Gap(gap: kHalfGap),
                      
                      GestureDetector(
                        onTap: () async {
                          pdpaAlert(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: acceptPDPA,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(kButtonRadius),
                                ),
                              ),
                              onChanged: (value) {
                                setState((){
                                  acceptPDPA = value!;
                                });
                              },
                            ),
                            Text(
                              lController.getLang("You agree with"),
                              style: bodyText2,
                            ),
                            const SizedBox(width: kQuarterGap),
                            Text(
                              lController.getLang("Privacy Policy"),
                              style: bodyText2.copyWith(color: kAppColor),
                            ),
                          ],
                        ),
                      ),
                      const Gap(gap: kHalfGap),
                      ButtonFull(
                        title: lController.getLang("Sign Up"),
                        onPressed: _onPressSignUp,
                      ),
                      const SizedBox(height: kOtGap),
                      ButtonCustom(
                        title: lController.getLang("Scan Thai ID Card"),
                        onPressed: takePhoto,
                        isOutline: true,
                        textStyle: headline6,
                        // icon: Icon(Icons.account_box_rounded),
                      ),
                      const SizedBox(height: 1.25*kGap),
                      SizedBox(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              lController.getLang("Already have an account"),
                              style: subtitle2.copyWith(
                                color: kDarkLightColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: kQuarterGap),
                            TextButton(
                              onPressed: () => Get.off(() => SignInScreen(
                                isFirstState: widget.isFirstState,
                              )),
                              child: Text(
                                lController.getLang("Sign In")
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(customerGroups.isNotEmpty)...[
                        const SizedBox(height: 1.25*kGap),
                        Wrap(
                          runSpacing: kGap,
                          children: customerGroups.map((e) {

                            return ButtonCustom(
                              title: lController.getLang("Register for") + " " + (e.name ?? ''),
                              onPressed: () => _tabGroup(e),
                              isOutline: true,
                              textStyle: headline6,
                            );
                          }).toList(),
                        )
                      ]
                      
                      // const Gap(),
                      // DividerText(text: lController.getLang("Or")),
                      // const ButtonSignInGoogle(title: "Signup with Google"),
                      // const Gap(gap: kHalfGap),
                      // const ButtonSignInFacebook(title: "Signup with Facebook"),
                      // const Gap(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onPressSignUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(_formKey.currentState!.validate()){
      if(!acceptPDPA){
        ShowDialog.showForceDialog(
          lController.getLang("Error"),
          "text_privacy_1", () => Get.back()
        );
      }else{
        CustomerController _customerController = Get.find<CustomerController>();
        String? guestId = _customerController.customerModel?.id;
        String _telephone = _cTelephone.text.replaceFirst(RegExp(r'0'), '+66').trim();
        _telephone = _telephone.replaceAll('-', '');
        _telephone = _telephone.replaceAll(' ', '');

        Map<String, dynamic> input = {
          "guestId": guestId,
          "firstname": _cFirstname.text.trim(),
          "lastname": _cLastname.text.trim(),
          "email": _cEmail.text.trim().toLowerCase(),
          "password": _cPassword.text.trim(),
          "confirmPassword": _cConfirmPassword.text.trim(),
          "telephone": _telephone,
        };
        if(cardNumber != "") input["cardNumber"] = cardNumber;
        if(prefix != "") input["prefix"] = prefix;
        if(prefixEN != "") input["prefixEN"] = prefixEN;
        if(firstnameEN != "") input["firstnameEN"] = firstnameEN;
        if(lastnameEN != "") input["lastnameEN"] = lastnameEN;
        if(birthDate != "") input["birthDate"] = birthDate;
        if(address != "") input["address"] = address;
        if(subdistrict != "") input["subdistrict"] = subdistrict;
        if(district != "") input["district"] = district;
        if(province != "") input["province"] = province;
        if(zipcode != "") input["zipcode"] = zipcode;

        bool res = await ApiService.customerCheckDuplicate(input: input);
        if(res == false){
          if(enabledCustomerSignupOTP == 1){
            ShowDialog.showLoadingDialog();
            try {
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: _telephone,
                verificationCompleted: (_) {},
                verificationFailed: (e) {
                  Get.back();
                  ShowDialog.showErrorToast(desc: e.message.toString());
                },
                codeSent: (String verificationId, int? resendToken) {
                  Get.back();
                  if(!isResendOTP){
                    Get.to(() => OtpScreen(
                      input: input,
                      isFirstState: widget.isFirstState,
                      backTo: widget.backTo,
                      verificationID: verificationId,
                      telephone: _telephone,
                      isScan: isScan,
                      enabledCustomerSignupOTP: enabledCustomerSignupOTP,
                    ));
                  }else{
                    // Resend OTP
                  }
                },
                codeAutoRetrievalTimeout: (_) {
                  Get.back();
                },
              );
            }on FirebaseException catch (e){
              Get.back();
              ShowDialog.showForceDialog(
                lController.getLang("Error"), 
                e.message.toString(), () => Get.back()
              );
            } on PlatformException catch (e) {
              Get.back();
              ShowDialog.showForceDialog(
                lController.getLang("Error"),
                e.message ?? '', () => Get.back()
              );
            } catch (e) {
              Get.back();
              ShowDialog.showForceDialog(
                lController.getLang("Error"),
                e.toString(), () => Get.back()
              );
            }
          }else if(enabledCustomerSignupOTP == 2){
            ShowDialog.showLoadingDialog();
            try {
              String _telephone = _cTelephone.text.replaceFirst(RegExp(r'0'), '+66').trim();
              _telephone = _telephone.replaceAll('-', '');
              _telephone = _telephone.replaceAll(' ', '');
              Map<String, dynamic>? res1 = await ApiService.sendOTP(telephone: _telephone, telephoneCode: '+66');
              Get.back();
              if(res1 != null){
                if(res1['requestId']?.isNotEmpty == true && res1['refCode']?.isNotEmpty == true){
                  Get.to(() => OtpScreen(
                    input: input,
                    isFirstState: widget.isFirstState,
                    backTo: widget.backTo,
                    telephone: _telephone,
                    isScan: isScan,
                    enabledCustomerSignupOTP: enabledCustomerSignupOTP,
                    response: res1,
                    telephoneCode: '+66',
                  ));
                }
              }
            } catch (_) {
              Get.back();
            }
          }
        }
      }
    }
  }

  Future<String?> pdpaAlert(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<Map<String, dynamic>?>(
          future: _future,
          builder: (context, snapshot) {
            CmsContentModel? item;

            if (snapshot.hasData) {
              item = CmsContentModel.fromJson(snapshot.data!['result']);

              if (item.id == null) {
                return const SizedBox.shrink();
              }

              final _title = item.title == ''
                ? lController.getLang('Privacy Policy'): item.title;
              final _content = item.content;
              return AlertDialog(
                title: Text(
                  _title,
                  style: subtitle1.copyWith(fontWeight: FontWeight.w500),
                ),
                content: Scrollbar(
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
                        HtmlContent(content: _content),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      lController.getLang('Close'),
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

  Future<String?> showScanInfo(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text(
            lController.getLang("text_confirm_1"),
            textAlign: TextAlign.center,
            style: subtitle1.copyWith(fontWeight: FontWeight.w500),
          ),
          content: Scrollbar(
            trackVisibility: false,
            child: Container(
              height: Get.height * 0.25,
              width: Get.width,
              padding: const EdgeInsets.fromLTRB(0, 0, kGap, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kButtonRadius),
              ),
              child: ListView(
                children: [
                  tableRow("Social ID Number", cardNumber),
                  tableRow("Full Name", _cFirstname.text + " " + _cLastname.text),
                  tableRow("Address", "$address $subdistrict $district $province $zipcode"),
                  tableRow("Date of Birth", birthDate),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ButtonCustom(
              width: 100,
              height: kButtonMiniHeight,
              isOutline: true,
              onPressed: () {
                setState(() {
                  isScan = false;
                  _cFirstname.clear();
                  _cLastname.clear();
                  cardNumber = "";
                  prefix = "";
                  prefixEN = "";
                  firstnameEN = "";
                  lastnameEN = "";
                  birthDate = "";
                  address = "";
                  subdistrict = "";
                  district = "";
                  province = "";
                  zipcode = "";
                });
                Get.back();
              },
              title: lController.getLang("No"),
            ),
            ButtonCustom(
              width: 100,
              height: kButtonMiniHeight,
              onPressed: (){
                setState(() => isScan = true);
                Get.back();
              },
              title: lController.getLang("Yes"),
            ),
          ],
        );
      },
    );
  }

  tableRow(String item1, String item2) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lController.getLang(item1),
          style: subtitle2.copyWith(
            fontWeight: FontWeight.w500,
          )
        ),
        const Gap(gap: kHalfGap),
        Text(
          item2,
          style: subtitle2.copyWith(
            fontWeight: FontWeight.w300,
          )
        ),
        const Gap()
      ],
    );
  }

  void _tabGroup(CustomerGroupModel value) {
    if(value.needTaxId()){
      Get.to(() => TaxIdScreen(group: value));
    }else{
      // Get.to(page);
    }
  }
}