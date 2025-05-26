import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/screens/customer/address/list.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AddressSelection extends StatelessWidget {
  const AddressSelection({
    Key? key,
    this.padding,
    required this.lController
  }): super(key: key);

  final EdgeInsetsGeometry? padding;
  final LanguageController lController;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<CustomerController>(() => CustomerController());
    return GetBuilder<CustomerController>(builder: (controller) {
      final address = "${controller.shippingAddress?.displayAddress(lController)}";
      return InkWell(
        onTap: () => controller.customerModel == null
          ? Get.to(() => const SignInMenuScreen())
          : _onTapSelection(),
        child: Container(
          color: kWhiteColor,
          padding: padding,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kBlueColor.withOpacity(0.2),
                ),
                child: const Center(
                  child: Icon(
                    FontAwesomeIcons.locationDot,
                    size: 16,
                    color: kBlueColor,
                  ),
                ),
              ),
              const Gap(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lController.getLang("Delivery To"),
                    style: bodyText2.copyWith(
                      color: kLightColor,
                      height: 1.35
                    ),
                  ),
                  SizedBox(
                    width: Get.width - 130,
                    child: Text(
                      controller.shippingAddress == null
                        ? lController.getLang("Please select shipping address")
                        : address,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: subtitle1.copyWith(
                        color: kBlueColor,
                        fontWeight: FontWeight.w600,
                        height: 1.35
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void _onTapSelection() {
    Get.to(() => const AddressScreen());
  }
}
