import 'dart:math';

import 'package:coffee2u/screens/customer/payment/list.dart';
import 'package:flutter/material.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:get/get.dart';

class DownPaymentsScreen extends StatefulWidget {
  const DownPaymentsScreen({Key? key}) : super(key: key);

  @override
  State<DownPaymentsScreen> createState() => _DownPaymentsScreenState();
}

class _DownPaymentsScreenState extends State<DownPaymentsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  List<double> customDownPayments = [];
  double? selectedPercent;
  late double defaultPercent;

  @override
  void initState() {
    super.initState();
    _customerController.discountProduct!.customDownPayments.sort();
    if(mounted){
      setState(() {
        defaultPercent = grandTotal(withShipping: false) /overallTotal(withShipping: false) *100;
        customDownPayments = _customerController.discountProduct!.customDownPayments;
        selectedPercent = defaultPercent;
      });
    }
  }

  double grandTotal({bool withShipping = true}) {
    if(_customerController.cart.products.isNotEmpty){
      return max(
        _customerController.cart.total 
        - (_customerController.discountProduct?.isValid() == true? (_customerController.discountProduct?.actualDiscount ?? 0): 0) 
        + (withShipping && _customerController.shippingMethod?.isValid() == true? (_customerController.shippingMethod?.price ?? 0): 0) 
        - (withShipping && _customerController.discountShipping?.isValid() == true? (_customerController.discountShipping?.actualDiscount ?? 0): 0) 
        - (_customerController.discountCash?.isValid() == true? (_customerController.discountCash?.actualDiscount ?? 0): 0) 
        - (_customerController.discountPoint?.discount ?? 0) 
      , 0);
    }else{
      return 0;
    }
  }
  double shippingTotal() {
    if(_customerController.cart.products.isNotEmpty){
      return max(
        (_customerController.shippingMethod?.isValid() == true? (_customerController.shippingMethod?.price ?? 0): 0) 
        - (_customerController.discountShipping?.isValid() == true? (_customerController.discountShipping?.actualDiscount ?? 0): 0) 
      , 0);
    }else{
      return 0;
    }
  }
  double overallTotal({bool withShipping = false}) {
    if(_customerController.cart.products.isNotEmpty){
      return max(
        _customerController.cart.total 
        - (_customerController.discountProduct?.isValid() == true? (_customerController.discountProduct?.actualDiscount ?? 0): 0) 
        + (withShipping && _customerController.shippingMethod?.isValid() == true? (_customerController.shippingMethod?.price ?? 0): 0) 
        - (withShipping && _customerController.discountShipping?.isValid() == true? (_customerController.discountShipping?.actualDiscount ?? 0): 0) 
        - (_customerController.discountCash?.isValid() == true? (_customerController.discountCash?.actualDiscount ?? 0): 0) 
        - (_customerController.discountPoint?.discount ?? 0) 
        + (_customerController.cart.hasDownPayment == 1? (
          _customerController.cart.missingPayment 
          - (_customerController.discountProduct?.hasMissingPaymentDiscount() == true? (_customerController.discountProduct?.missingPaymentDiscount ?? 0): 0) 
          - (_customerController.discountCash?.hasMissingPaymentDiscount() == true? (_customerController.discountCash?.missingPaymentDiscount ?? 0): 0) 
        ): 0) 
      , 0);
    }else{
      return 0;
    }
  }
  double missingTotal() {
    if(_customerController.cart.products.isNotEmpty && _customerController.cart.hasDownPayment == 1){
      return max(
        _customerController.cart.missingPayment 
        - (_customerController.discountProduct?.hasMissingPaymentDiscount() == true? (_customerController.discountProduct?.missingPaymentDiscount ?? 0): 0) 
        - (_customerController.discountCash?.hasMissingPaymentDiscount() == true? (_customerController.discountCash?.missingPaymentDiscount ?? 0): 0) 
      , 0);
    }else{
      return 0;
    }
  }

  void _onTapComfirm() async {
    Get.to(() => PaymentMethodsScreen(
      customDownPayment: selectedPercent,
      amountDefault: (overallTotal(withShipping: false) *selectedPercent!/100 * pow(10, 2)).round().toDouble() / pow(10, 2),
      missingPaymentDefault: (overallTotal(withShipping: false) *(100-selectedPercent!)/100 * pow(10, 2)).round().toDouble() / pow(10, 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text(
          lController.getLang("Choose Down Payments")
        ),
      ),
      body: ListView(
        padding: kPadding,
        children: [
          InkWell(
            onTap: () {
              if(mounted) setState(() => selectedPercent = defaultPercent);
            },
            child: Container(
              padding: kPadding,
              decoration: BoxDecoration(
                color: selectedPercent == defaultPercent? kAppColor.withOpacity(0.05): kWhiteColor,
                borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
                border: Border.all(width: 1, color: selectedPercent == defaultPercent? kAppColor: kLightColor)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${lController.getLang('Default')} ${numberFormat(defaultPercent, digits: 0)}%',
                    style: title.copyWith(
                      fontFamily: 'Kanit',
                      color: kAppColor,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const Gap(gap: kHalfGap),
                  RichText(
                    text: TextSpan(
                      text: '${lController.getLang('Pay Now')} ',
                      style: subtitle1.copyWith(
                        color: kDarkColor,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400
                      ),
                      children: [
                        TextSpan(
                          text: '${priceFormat(grandTotal(withShipping: false), lController)} ',
                          style: subtitle1.copyWith(
                            color: kDarkColor,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        if(shippingTotal() > 0)...[
                          TextSpan(
                            text: '+ ${lController.getLang('Shipping Cost')} ',
                            style: subtitle1.copyWith(
                              color: kDarkColor,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w400
                            ),
                            children: [
                              TextSpan(
                                text: priceFormat(shippingTotal(), lController),
                                style: subtitle1.copyWith(
                                  color: kDarkColor,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ]
                          ),
                        ] 
                      ]
                    )
                  ),
                  if(_customerController.cart.hasDownPayment == 1)...[
                    RichText(
                      text: TextSpan(
                        text: '${lController.getLang('Pay Later')} ',
                        style: subtitle1.copyWith(
                          color: kDarkColor,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w400
                        ),
                        children: [
                          TextSpan(
                            text: priceFormat(missingTotal(), lController),
                            style: subtitle1.copyWith(
                              color: kDarkColor,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ]
                      )
                    ),
                  ]
                ],
              ),
            ),
          ),
          const Gap(gap: kHalfGap),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index){
              final d = customDownPayments[index];

              return downPaymentCard(d, (value) {
                  if(mounted) setState(() => selectedPercent = value);
                },
              );
            }, 
            separatorBuilder: (cnotext, index){
              return const Gap(gap: kHalfGap);
            }, 
            itemCount: customDownPayments.length
          )
        ],
      ),
      bottomNavigationBar: GetBuilder<CustomerController>(builder: (controller) {
        return Padding(
          padding: kPaddingSafeButton,
          child: IgnorePointer(
            ignoring: selectedPercent == null,
            child: ButtonFull(
              color: selectedPercent == null
                ? kGrayColor: kAppColor,
              title: lController.getLang("Choose"),
              onPressed: () => _onTapComfirm(),
            )
          ),
        );
      })
    );
  }

  Widget downPaymentCard(double percent, Function(double) onTap) {
    return InkWell(
      onTap: () => onTap(percent),
      child: Container(
        padding: kPadding,
        decoration: BoxDecoration(
          color: selectedPercent == percent? kAppColor.withOpacity(0.05): kWhiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
          border: Border.all(width: 1, color: selectedPercent == percent? kAppColor: kLightColor)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${lController.getLang('Down Payment')} ${numberFormat(percent, digits: 0)}%',
              style: title.copyWith(
                fontFamily: 'Kanit',
                color: kAppColor,
                fontWeight: FontWeight.w500
              ),
            ),
            const Gap(gap: kHalfGap),
            RichText(
              text: TextSpan(
                text: '${lController.getLang('Pay Now')} ',
                style: subtitle1.copyWith(
                  color: kDarkColor,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400
                ),
                children: [
                  TextSpan(
                    text: '${priceFormat( overallTotal(withShipping: false) *percent/100, lController)} ',
                    style: subtitle1.copyWith(
                      color: kDarkColor,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  if(shippingTotal() > 0)...[
                    TextSpan(
                      text: '+ ${lController.getLang('Shipping Cost')} ',
                      style: subtitle1.copyWith(
                        color: kDarkColor,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400
                      ),
                      children: [
                        TextSpan(
                          text: priceFormat(shippingTotal(), lController),
                          style: subtitle1.copyWith(
                            color: kDarkColor,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ]
                    ),
                  ] 
                ]
              )
            ),
            if(_customerController.cart.hasDownPayment == 1)...[
              RichText(
                text: TextSpan(
                  text: '${lController.getLang('Pay Later')} ',
                  style: subtitle1.copyWith(
                    color: kDarkColor,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400
                  ),
                  children: [
                    TextSpan(
                      text: priceFormat(overallTotal(withShipping: false) *(100-percent)/100, lController),
                      style: subtitle1.copyWith(
                        color: kDarkColor,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ]
                )
              ),
            ]
          ],
        ),
      ),
    );
  }
}