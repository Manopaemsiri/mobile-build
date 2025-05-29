import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/subscription/read.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:coffee2u/screens/customer/address/list.dart';

import '../../../widgets/index.dart';
import '../../partner/subscription/create.dart';
import '../subscription_orders/list.dart';
import 'controllers/customer_subscription_controller.dart';
import 'widgets/card_product.dart';

import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/apis/api_service.dart';

class CustomerSubscriptionScreen extends StatelessWidget {
  CustomerSubscriptionScreen({
    super.key,
    required this.id,
  });

  final String id;
  final lController = Get.find<LanguageController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  final bool trimDigits = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lController.getLang('Subscription Package'),
        ),
      ),
      body: GetBuilder<CustomerController>(
        builder: (customerController) {
          return GetBuilder<CustomerSubscriptionController>(
            init: CustomerSubscriptionController(id: id),
            builder: (controller) {
              Widget body = Center(child: Loading());
              if (controller.stateStatus == 1) {
                body = widgetBody(controller);
              } else if (controller.stateStatus == 2) {
                body = NoData();
              } else if (controller.stateStatus == 3) {
                body = PageError();
              }
              return body;
            },
          );
        },
      ),
    );
  }

  Widget widgetBody(CustomerSubscriptionController controller) {
    final CustomerSubscriptionModel? item = controller.data;
    if (item == null) return const SizedBox.shrink();
    final String orderRef = item.prefixOrderId2C2P;
    final String subscriptionId = item.subscription?.id ?? '';
    final String customerSubscriptionId = item.id ?? '';

    final CustomerShippingAddressModel? shippingAddress = controllerCustomer.shippingAddress;
    final CustomerBillingAddressModel? billingAddress = item.billingAddress;
    final List<PartnerProductModel> relatedProducts = controller.relatedProducts;
    final List<PartnerProductModel> products = controller.products;

    return ListView(
      children: [
        const Gap(),
        Container(
          padding: kPadding,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(color: kWhiteColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${lController.getLang("Order Ref")} $orderRef',
                style: title.copyWith(
                  color: kDarkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => CustomerSubscriptionOrdersScreen(subscriptionId: customerSubscriptionId)),
                child: Text(
                  lController.getLang('Billing Information'),
                  style: bodyText1.copyWith(
                    decoration: TextDecoration.underline,
                    color: kAppColor,
                  ),
                ),
              )
            ],
          ),
        ),
        const Gap(gap: kHalfGap),
        _card(
          _cardTitle(
            FontAwesomeIcons.solidMoneyBill1,
            'Package Information',
            detail: controller.data?.subscription != null ? 'view data' : null,
            onTap: controller.data?.subscription != null ? () => onTapPackageInformation(subscriptionId) : null,
          ),
          [
            if (controller.data?.subscription != null) ...[
              Text(
                controller.data?.subscription?.name ?? 'Package',
                style: subtitle1.copyWith(color: kDarkLightColor),
              ),
              Text(
                controller.data?.diaplaySubscriptionPrice(lController) ?? '',
                style: subtitle1.copyWith(color: kDarkLightColor),
              ),
              Text(
                controller.data?.diaplaySubscriptionContract(lController) ?? '',
                style: subtitle1.copyWith(color: kDarkLightColor),
              ),
            ] else ...[
              const Gap(gap: kHalfGap),
              Align(
                alignment: Alignment.center,
                child: Text(
                  lController.getLang("No Data Found"),
                  style: subtitle2.copyWith(fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ],
        ),
        const Gap(gap: kHalfGap),
        _card(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: kAppColor),
                    const SizedBox(width: 8),
                    Text(
                      lController.getLang('Delivery To'),
                      style: subtitle1,
                    ),
                  ],
                ),
                  if (item.status != 3)
                    IconButton(
                      icon: Icon(Icons.chevron_right, color: kAppColor),
                      padding: EdgeInsets.zero, 
                      constraints: const BoxConstraints(), 
                      onPressed: () async {
                        await Get.to(() => AddressScreen(subscriptionId: customerSubscriptionId))
                            ?.then((value) async {
                          final res = await ApiService.processRead(
                            'shipping-address-get-selected',
                            input: {'autoBilling': 1},
                          );
                          if (res?['result'] != null) {
                            final updatedAddress =
                                CustomerShippingAddressModel.fromJson(res?['result']);
                            await ApiService.processUpdate('subscription', input: {
                              '_id': customerSubscriptionId,
                              'shippingAddressId': updatedAddress.id,
                            });
                            await controllerCustomer.updateShippingAddress(updatedAddress);
                            Get.find<CustomerSubscriptionController>().update();
                          }
                        });
                      },
                    ),
                ],
              ),
            [
            if (shippingAddress?.isValidAddress() == true) ...[
              const SizedBox(height: 6), 
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shippingAddress?.displayAddress(lController, sep: '\n', withCountry: true) ?? '',
                          style: subtitle1.copyWith(color: kDarkLightColor),
                        ),
                        Text(
                          "${lController.getLang('Telephone Number')} ${shippingAddress?.telephone}",
                          style: subtitle1.copyWith(color: kDarkLightColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              const Gap(gap: kHalfGap),
              Align(
                alignment: Alignment.center,
                child: Text(
                  lController.getLang("No Data Found"),
                  style: subtitle2.copyWith(fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ],
        ),

        if (billingAddress?.isValidAddress() == true) ...[
          const Gap(gap: kHalfGap),
          _card(
            _cardTitle(Icons.description_rounded, 'Billing Address'),
            [
              Text(
                billingAddress?.billingName ?? '',
                style: subtitle1.copyWith(color: kDarkLightColor),
              ),
              Text(
                billingAddress?.displayAddress(lController, sep: '\n', withCountry: true) ?? '',
                style: subtitle1.copyWith(color: kDarkLightColor),
              ),
            ],
          ),
        ],
        if (relatedProducts.isNotEmpty) ...[
          const Gap(gap: kHalfGap),
          _card(
            _cardTitle(Icons.inventory_2_rounded, 'Initial Subscription Products'),
            [
              const Gap(gap: kHalfGap),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final PartnerProductModel d = relatedProducts[index];
                  return CardCustomerSubscriptionProduct(
                    data: d,
                    lController: lController,
                    trimDigits: trimDigits,
                  );
                },
                separatorBuilder: (_, index) => const Divider(),
                itemCount: relatedProducts.length,
              )
            ],
          ),
        ],
        const Gap(gap: kHalfGap),
        _card(
          _cardTitle(
            Icons.local_mall_rounded, 
            'Products',
            detail: (products.isNotEmpty && item.status != 0 && item.status != 3) ? 'Edit': null,
            onTap: (products.isNotEmpty && item.status != 0 && item.status != 3) ? () async {
            if(controller.data?.subscription != null){
              final result = await Get.to(() => PartnerProductSubscriptionCreateScreen(
                data: controller.data!.subscription!.copyWith(
                  relatedCredit: controller.data?.relatedCredit,
                  relatedProducts: controller.data?.relatedProducts,
                  selectionSteps: controller.data?.selectionSteps,
                  priceInVAT: controller.data?.subscription?.priceInVAT,
                  discountPriceInVAT: controller.data?.subscription?.discountPriceInVAT,
                ),
                type: 2,
                lController: lController,
                subscription: controller.data,
              ));
              if (result == true) {
                 await controller.getDataAgain(); 
                }
              
              }
              } : null,
            ),
          [
            
            if(products.isNotEmpty == true)...[
              const Gap(gap: kHalfGap),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final PartnerProductModel d = products[index];

                  return CardCustomerSubscriptionProduct(
                    data: d,
                    lController: lController,
                    trimDigits: trimDigits,
                  );
                },
                separatorBuilder: (_, index) => const Divider(),
                itemCount: products.length,
              )
            ]else ...[
              const Gap(gap: kHalfGap),
              Align(
                alignment: Alignment.center,
                child: Text(
                  lController.getLang("No Data Found"),
                  style: subtitle2.copyWith(
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            ]
          ]
        ),
      ],
    );
  }

  onTapPackageInformation(String value) => Get.to(() => PartnerProductSubscriptionScreen(
        id: value,
        subscribeButton: false,
        lController: lController,
      ));

  Widget _cardTitle(IconData icon, String text, {String? detail, Function()? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            softWrap: true,
            text: TextSpan(
              style: subtitle1.copyWith(
                color: kAppColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Kanit',
              ),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    icon,
                    color: kAppColor,
                    size: 18,
                  ),
                ),
                const WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Gap(gap: kGap),
                ),
                TextSpan(
                  text: lController.getLang(text),
                ),
              ],
            ),
          ),
        ),
        if (onTap != null) ...[
          InkWell(
            onTap: onTap,
            child: Text(
              lController.getLang(detail ?? 'See More'),
              style: caption.copyWith(
                color: kAppColor,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _card(Widget value, List<Widget> values) {
    return Container(
      padding: kPadding,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: kWhiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          value,
          Padding(
            padding: const EdgeInsets.only(left: kGap + 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: values,
            ),
          ),
        ],
      ),
    );
  }
}
