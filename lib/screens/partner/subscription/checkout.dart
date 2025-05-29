import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../utils/dialog_helper.dart';
import '../../customer/address/components/card_address.dart';
import '../../customer/address/list.dart';
import '../../customer/billing_address/list.dart';
import '../../customer/checkout/components/list_option.dart';
import '../../customer/shipping/list.dart';
import 'controllers/subscription_checkout_controller.dart';
import 'widgets/card_subscription_products.dart';

class PartnerProductSubscriptionCheckoutScreen extends StatelessWidget {
  PartnerProductSubscriptionCheckoutScreen({
    super.key,
  });
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<SubscriptionCheckoutController>(
      init: SubscriptionCheckoutController(),
      builder: (controller) {
        Widget body = Center(child: Loading());
        if(controller.stateStatus == 1){
          body = _body(controller);
        }else if(controller.stateStatus == 2){
          body = NoData();
        }else if(controller.stateStatus == 3){
          body = PageError();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              lController.getLang("Checkout"),
            ),
          ),
          body: body,
          bottomNavigationBar: controller.stateStatus == 1
          ? Padding(
            padding: kPaddingSafeButton,
            child: ButtonOrder(
              color: controller.products.isEmpty? kGrayColor: null,
              title: lController.getLang("Checkout"),
              qty: controller.countCartProducts(),
              total: controller.checkoutTotal(),
              onPressed: controller.onSubmit,
              lController: lController
            ),
          )
          : const SizedBox.shrink()
        );
      }
    );
  }

  Widget _body(SubscriptionCheckoutController controller) {

    return ListView(
      children: [
        const DividerThick(),
        Container(
          decoration: const BoxDecoration(
            color: kWhiteColor
          ),
          child: CardAddress(
            model: controller.data?.shippingAddress,
            onTap: () => Get.to(() => const AddressScreen(subscription: 1)), 
            lController: lController,
          ),
        ),
        const Gap(),

        Container(
          decoration: const BoxDecoration(
            color: kWhiteColor
          ),
          child: CardSubscriptionProducts(
            products: controller.products,
            lController: lController,
            data: controller.data!,
            shipping: controller.shippingMethod,
            trimDigits: false,
          ),
        ),
        const Gap(),

        // Shipping Method
        Container(
          decoration: const BoxDecoration(
            color: kWhiteColor
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.shippingMethod == null || !controller.shippingMethod!.isValid()
              ? ListOption(
                icon: FontAwesomeIcons.truck,
                title: lController.getLang("Choose Shipping Method"),
                // onTap: () => _onTapShippingMethod(customerController),
                onTap: () => onTapShippingMethod(controller),
                trailings: const [ Icon(Icons.chevron_right) ], 
                lController: lController,
              )
              : ListOption(
                icon: FontAwesomeIcons.truck,
                title: controller.shippingMethod!.displayName,
                description: controller.shippingMethod!.displaySummary(lController) +
                  (controller.shippingMethod?.type == 2 && controller.shippingMethod != null? '\n${lController.getLang('pick up at').replaceAll(RegExp(r'_VALUE_'), controller.shippingMethod?.shop?.name ?? '')}': '') 
                  + (controller.shippingMethod?.type == 2? '\n*** ${lController.getLang('text_subscription_pick_up_note')}': ''),
                descriptionColor: kAppColor,
                onTap: () => onTapShippingMethod(controller),
                trailings: [
                  (controller.shippingMethod?.price ?? 0) <= 0
                  ? Text(
                    'FREE',
                    style: subtitle3.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kAppColor
                    ),
                  )
                  : Text(
                    controller.shippingMethod!.displayPrice(lController),
                    style: subtitle3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ], 
                lController: lController,
              ),
            ],
          )
        ),
        const Gap(),

        // Tax Invoice
        Container(
          decoration: const BoxDecoration(
            color: kWhiteColor
          ),
          child: InkWell(
            onTap: () => Get.to(() => const BillingAddressesScreen(subscription: 1)),
            child: Padding(
              padding: kPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lController.getLang("Tax Invoice"),
                        style: subtitle1.copyWith(
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: kQuarterGap),
                    child: controller.data?.billingAddress != null && controller.data?.billingAddress?.isValid() == true
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.data?.billingAddress!.billingName ?? '',
                            style: subtitle1.copyWith(
                              color: kGrayColor
                            ),
                          ),
                          Text(
                            controller.data?.billingAddress!.displayAddress(lController) ?? '',
                            style: subtitle1.copyWith(
                              color: kGrayColor
                            ),
                          ),
                        ],
                      )
                      : Text(
                        lController.getLang("No billing address"),
                        style: subtitle1,
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onTapShippingMethod(SubscriptionCheckoutController _controller) {
    if (_controller.data?.shippingAddress == null || _controller.data?.shippingAddress?.isValid() != true) {
      ShowDialog.showForceDialog(
        lController.getLang("Missing shipping address"),
        lController.getLang("Please choose a shipping address"), 
        (){
          Get.back();
          Get.to(() => const AddressScreen(subscription: 1));
        }
      );
    }else {
      Get.to(() => const ShippingMethodsScreen(subscription: 1));
    }
  }

}