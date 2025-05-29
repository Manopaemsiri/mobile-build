import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/bottom_nav/bottom_nav.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'controller/customer_group_address_controller.dart';

class CustomerGroupAddressScreen extends StatelessWidget {
  const CustomerGroupAddressScreen({
    super.key,
    required this.group
  });
  final CustomerGroupModel group;
  
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
                child: GetBuilder<CustomerGroupAddressController>(
                  init: CustomerGroupAddressController(group),
                  builder: (controller) {

                    if(controller.isReday == false){
                      return ListView.separated(
                        padding: const EdgeInsets.all(kGap * 2),
                        physics: const RangeMaintainingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          return Column(
                            children: [
                              Container(
                                height: title.fontSize!*1.4,
                                padding: EdgeInsets.zero,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(kRadius),
                                  color: kWhiteColor,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  enabled: true,
                                  child: Container(
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                              const Gap(gap: kHalfGap),
                              Container(
                                height: 150,
                                padding: EdgeInsets.zero,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(kRadius),
                                  color: kWhiteColor,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  enabled: true,
                                  child: Container(
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                              const Gap(gap: kHalfGap),
                              Container(
                                height: 150,
                                padding: EdgeInsets.zero,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(kRadius),
                                  color: kWhiteColor,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  enabled: true,
                                  child: Container(
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }, 
                        separatorBuilder: (_, index) => const Gap(), 
                        itemCount: 2
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.all(kGap * 2),
                      physics: const RangeMaintainingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        if(controller.addresses.isNotEmpty)...[
                          Text(
                            controller.lController.getLang("Shipping Addresses"),
                            style: title.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(gap: kHalfGap),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, index) {
                              final CustomerShippingAddressModel item = controller.addresses[index];

                              return _addressCard(
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.displayAddress(controller.lController, sep: '\n', withCountry: true),
                                        style: subtitle1,
                                      ),
                                      const Gap(gap: kQuarterGap),
                                      Text(
                                        '${controller.lController.getLang('Telephone Number')} ${item.telephone}',
                                        style: subtitle1,
                                      ),
                                      const Gap(gap: kHalfGap),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.lController.getLang("toggle_status"),
                                                style: subtitle2.copyWith(
                                                  fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              Transform.scale(
                                                scale: 0.7,
                                                child: CupertinoSwitch(
                                                  value: item.isSelected == 1,
                                                  activeTrackColor: kAppColor,
                                                  onChanged: (bool value) async {
                                                    // if(item.id != controller.shippingAddress?.id) {
                                                    //   ShowDialog.showLoadingDialog();
                                                    //   await ApiService.processUpdate(
                                                    //     "shipping-address-set-selected",
                                                    //     input: { "_id": item.id }
                                                    //   );
                                                    //   await controllerCustomer.readCart(needLoading: false);
                                                    //   await Future.wait([
                                                    //     controller.updateShippingAddress(item),
                                                    //     controllerCustomer.clearStateToNull(),
                                                    //     AppHelpers.updatePartnerShop(controllerCustomer),
                                                    //   ]);
                                                    //   Get.back();
                                                    // }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          if(controller.canUpdateShipping)...[
                                            IconButton(
                                              icon: const Icon(
                                                Icons.border_color_outlined
                                              ),
                                              splashRadius: 1.45*kGap,
                                              onPressed: () {
                                                // Navigator.of(context).push(
                                                //   MaterialPageRoute(builder: (context) =>
                                                //     AddressAddScreen(
                                                //       isEditMode: true,
                                                //       addressModel: item
                                                //     ),
                                                // )).then((value) async {
                                                //   if(value != null && value?['refresh'] == true) {
                                                //     await controllerCustomer.clearStateToNull();
                                                //     await AppHelpers.updatePartnerShop(controllerCustomer);
                                                //     shippingAddressList(updateState: true);
                                                //   }
                                                // });
                                              },
                                            ),
                                          ]
                                        ],
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => const Gap(gap: kHalfGap),
                            itemCount: controller.addresses.length
                          ),
                          const Gap(),
                        ],
                        if(controller.billingAddresses.isNotEmpty)...[
                          Text(
                            controller.lController.getLang("Billing Addresses"),
                            style: title.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(gap: kHalfGap),
                          ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              final CustomerBillingAddressModel item = controller.billingAddresses[index];

                              return _addressCard(
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.displayAddress(controller.lController, sep: '\n', withCountry: true),
                                        style: subtitle1,
                                      ),
                                      const Gap(gap: kQuarterGap),
                                      Text(
                                        '${controller.lController.getLang('Telephone Number')} ${item.telephone}',
                                        style: subtitle1,
                                      ),
                                      const Gap(gap: kHalfGap),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.lController.getLang("toggle_status"),
                                                style: subtitle2.copyWith(
                                                  fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              Transform.scale(
                                                scale: 0.7,
                                                child: CupertinoSwitch(
                                                  value: item.isSelected == 1,
                                                  activeTrackColor: kAppColor,
                                                  onChanged: (bool value) async {
                                                    await ApiService.processUpdate(
                                                      "billing-address-set-selected",
                                                      input: { "_id": item.id }
                                                    );
                                                    // await controller.updateBillingAddress(item);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          if(controller.canUpdateBilling)...[
                                            IconButton(
                                              icon: const Icon(
                                                Icons.border_color_outlined
                                              ),
                                              splashRadius: 1.45*kGap,
                                              onPressed: () {
                                                // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                //   BillingAddressScreen(
                                                //     isEditMode: true,
                                                //     addressModel: item
                                                //   )
                                                // )).then((value) {
                                                //   billingAddressList(updateState: true);
                                                // });
                                              },
                                            ),
                                          ]
                                        ]
                                      )
                                    ],
                                  )
                                )
                              );
                            },
                            separatorBuilder: (_, __) => const Gap(gap: kHalfGap),
                            itemCount: controller.billingAddresses.length
                          ),
                          const Gap(),
                        ],
                        ButtonFull(
                          title: controller.lController.getLang("Sign Up"),
                          onPressed: () => _onPressed(),
                        ),
                      ],
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

  void _onPressed() =>
    Get.offAll(() => const BottomNav());


  _addressCard(Widget child) {
    return Container(
      padding: kPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(
          color: kDarkLightGrayColor.withValues(alpha: 0.5),
          width: 0.4
        )
      ),
      child: child,
    );
  }
}