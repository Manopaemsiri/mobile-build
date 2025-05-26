import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ChangePasswordScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _cOld = TextEditingController();
  final TextEditingController _cNew = TextEditingController();
  final TextEditingController _cConfirm = TextEditingController();

  final FocusNode _fOld = FocusNode();
  final FocusNode _fNew = FocusNode();
  final FocusNode _fConfirm = FocusNode();
  
  bool isShowOld = false;
  bool isShowNew = false;
  bool isShowConfirm = false;

  bool passwordLength = false;
  bool passwordNumber = false;
  bool passwordSymbol = false;

  bool _isValid() {
    return _cOld.text != '' && _cNew.text != '' && _cConfirm.text != ''; 
  }

  @override
  void dispose() {
    _fOld.dispose();
    _fNew.dispose();
    _fConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang("Change Password")),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: kPadding,
            children: [
              LabelText(
                text: lController.getLang("Current Password"),
                isRequired: true,
              ),
              const SizedBox(height: kHalfGap),
              TextFormField(
                controller: _cOld,
                focusNode: _fOld,
                obscureText: !isShowOld,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => isShowOld = !isShowOld);
                    },
                    icon: Icon(
                      isShowOld
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) => Utils.validateString(value),
                onFieldSubmitted: (value) => _fNew.requestFocus(),
              ),

              const SizedBox(height: kGap),
              LabelText(
                text: lController.getLang("New Password"),
                isRequired: true,
              ),
              const SizedBox(height: kHalfGap),
              TextFormField(
                controller: _cNew,
                focusNode: _fNew,
                obscureText: !isShowNew,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => isShowNew = !isShowNew);
                    },
                    icon: Icon(
                      isShowNew
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) => Utils.validatePassword(value, _cConfirm.text, 1),
                onFieldSubmitted: (value) => _fConfirm.requestFocus(),
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
              
              const SizedBox(height: kGap),
              LabelText(
                text: lController.getLang("Confirm New Password"),
                isRequired: true,
              ),
              const SizedBox(height: kHalfGap),
              TextFormField(
                controller: _cConfirm,
                focusNode: _fConfirm,
                obscureText: !isShowConfirm,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => isShowConfirm = !isShowConfirm);
                    },
                    icon: Icon(
                      isShowConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.done,
                validator: (value) => Utils.validatePassword(_cNew.text, _cConfirm.text, 2),
                onFieldSubmitted: (str) => FocusScope.of(context).unfocus(),
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
              const Gap(gap: kHalfGap),
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
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<CustomerController>(builder: (controller) {
        return Padding(
          padding: kPaddingSafeButton,
          child: IgnorePointer(
            ignoring: !_isValid(),
            child: ButtonFull(
              color: _isValid()? kAppColor: kGrayColor,
              title: lController.getLang("Save"),
              onPressed: () => _onSubmit(),
            ),
          ),
        );
      })
    );
  }

  void _onSubmit() async {
    if(_isValid()){
      FocusManager.instance.primaryFocus?.unfocus();
      if(_formKey.currentState!.validate()){
        bool res = await ApiService.processUpdate(
          'password',
          input: {
            "oldPassword": _cOld.text,
            "newPassword": _cNew.text,
            "confirmNewPassword": _cConfirm.text,
          },
          needLoading: true,
        );
        if(res){
          setState(() {
            _cOld.text = '';
            _cNew.text = '';
            _cConfirm.text = '';
            isShowOld = false;
            isShowNew = false;
            isShowConfirm = false;
          });
          ShowDialog.showSuccessToast(
            title: lController.getLang("Successed"),
            desc: lController.getLang('text_change_password_1')
          );
        }
      }
    }
  }
}