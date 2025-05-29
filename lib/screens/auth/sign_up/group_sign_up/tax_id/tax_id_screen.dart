import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/auth/sign_up/group_sign_up/address/customer_group_address_screen.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controller/tax_id_controller.dart';

class TaxIdScreen extends StatelessWidget {
  TaxIdScreen({
    super.key,
    required this.group
  });
  final CustomerGroupModel group;
  final _formKey = GlobalKey<FormState>();

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
                child: GetBuilder<TaxIdController>(
                  init: TaxIdController(),
                  builder: (controller) {

                    return Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(kGap * 2),
                        physics: const RangeMaintainingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Align(
                            child: Text(
                              controller.lController.getLang("Sign Up"),
                              style: headline5.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Gap(gap: 20),
                          TextFormField(
                            controller: controller.cTaxId,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: '${controller.lController.getLang("Tax ID")} *',
                              prefixIcon: const Icon(Icons.person),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: controller.fTaxId,
                            validator: (value) => Utils.validateString(value),
                            onFieldSubmitted: (value) => _onPressed(context),
                          ),
                          const Gap(),
                          ButtonFull(
                            title: controller.lController.getLang("Sign Up"),
                            onPressed: () => _onPressed(context),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    if(_formKey.currentState!.validate()){
      Get.to(() => CustomerGroupAddressScreen(group: group));
    }
  }
}