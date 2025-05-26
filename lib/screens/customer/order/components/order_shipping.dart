import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OrderShipping extends StatelessWidget {
  OrderShipping({
    Key? key,
    required this.model,
    required this.lController,
  }) : super(key: key);

  final CustomerOrderModel model;
  final LanguageController lController;
  final AppController _appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    CustomerShippingAddressModel? address = model.shippingAddress;
    return !model.isValid()
      ? const SizedBox.shrink()
      : Column(
        children: [
          Padding(
            padding: kPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_sharp,
                      color: kAppColor,
                      size: 22,
                    ),
                    const SizedBox(width: kOtGap),
                    Text(
                      lController.getLang("Delivery To"),
                      style: subtitle1.copyWith(
                        color: kAppColor,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: kQuarterGap, left: 34),
                  child: model.isValid()
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(address?.isValidAddress() == true)...[
                          Text(
                            address?.displayAddress(lController, sep: '\n', withCountry: true) ?? '',
                            style: subtitle1.copyWith(
                              color: kDarkLightColor
                            ),
                          ),
                          Text(
                            "${lController.getLang('Telephone Number')} ${address?.telephone}",
                            style: subtitle1.copyWith(
                              color: kDarkLightColor
                            ),
                          ),
                        ]else ...[
                          Text(
                            lController.getLang("No Data Found"),
                            style: subtitle1,
                          ),
                        ]
                        
                      ],
                    )
                    : Text(
                      lController.getLang("Please choose a shipping address"),
                      style: subtitle1,
                    ),
                ),
              ],
            ),
          ),
          if(_appController.enabledMultiPartnerShops) ...[
            const Divider(height: 0.75, thickness: 0.75),
            Container(
              padding: kPadding,
              color: kWhiteColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.store_rounded,
                    color: kAppColor,
                    size: 22,
                  ),
                  const SizedBox(width: kOtGap),
                  Text(
                    model.shop?.name ?? '',
                    style: subtitle1.copyWith(
                      color: kAppColor,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
  }
}