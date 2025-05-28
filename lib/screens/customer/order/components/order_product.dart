import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/shopping_cart/widgets/will_received_coupon.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderProduct extends StatelessWidget {
  const OrderProduct({
    super.key,
    required this.model,
    required this.lController,
    this.fromSubscription = false,
  });

  final CustomerOrderModel model;
  final LanguageController lController;
  final bool fromSubscription;

  @override
  Widget build(BuildContext context) {
    List<PartnerProductModel> products = model.products.where((d) => d.status != -2).toList();
    List<PartnerProductModel> freeProducts = model.products.where((d) => d.status == -2).toList();
    bool isSubscription = model.subscription != null;
    
    return !model.isValid()
    ? const SizedBox.shrink()
    : Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (_, index) {
            PartnerProductModel item = products[index];

            return Padding(
              padding: const EdgeInsets.fromLTRB(
                kGap, kHalfGap, kGap, kHalfGap
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ImageProduct(
                        imageUrl: item.image?.path ?? '',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: kOtGap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: subtitle2.copyWith(
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'x ${item.inCart} ${item.selectedUnit == null
                                ? item.unit: item.selectedUnit!.unit}',
                              style: subtitle2.copyWith(
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                        SizedBox(
                          width: 105,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if(fromSubscription)...[
                                if(item.subscriptionInitial > 0)...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: kQuarterGap
                                    ),
                                    decoration: BoxDecoration(
                                      color: kYellowColor,
                                      borderRadius: BorderRadius.circular(kRadius)
                                    ),
                                    child: Text(
                                      item.subscriptionInitial > 0
                                      ? priceFormat(item.addPriceInVAT, lController)
                                      : 'Subscription',
                                      style: subtitle2.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: kWhiteColor
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ]
                              ]else ...[
                                Text(
                                  isSubscription? priceFormat(item.priceInVAT, lController): item.displayTotalPriceInVAT(lController),
                                  style: subtitle2.copyWith(
                                    fontWeight: FontWeight.w500
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                              if(item.isValidDownPayment() && item.downPaymentInVAT > 0) ...[
                                Text(
                                  "${lController.getLang("Deposit")} ${item.displayTotalDownPaymentInVAT(lController)}",
                                  style: subtitle2.copyWith(
                                    fontSize: 13,
                                    color: kAppColor,
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ]
                              else ...[
                                if(item.discountInVAT > 0) ...[
                                  Text(
                                    item.displayFullAmountInVAT(lController, showSymbol: false),
                                    style: subtitle2.copyWith(
                                      color: kGrayColor,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.lineThrough,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                  if(item.shipBySupplier == 1) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40+kOtGap, 2, 0, 0),
                      child: Text(
                        "*** ${lController.getLang("text_lion_delivered_1")} ${item.preparingDays} ${lController.getLang("Days")}",
                        style: subtitle2.copyWith(
                          fontSize: 13,
                          color: kAppColor,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }, 
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: products.length
        ),
        if(freeProducts.isNotEmpty)...[
          const Divider(height: 1),
          Container(
            decoration: BoxDecoration(
              color: kYellowColor.withValues(alpha: 0.05)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(model.productGiveawayRule != null)...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kHalfGap),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: kQuarterGap, horizontal: kQuarterGap),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(kRadius),
                                  color: kAppColor.withValues(alpha: 0.1)
                                ),
                                child: Icon(
                                  Icons.redeem_rounded,
                                  color: kAppColor.withValues(alpha: 0.8)
                                ),
                              )
                            ),
                            const WidgetSpan(child: Gap(gap: kHalfGap)),
                            TextSpan(
                              text: model.productGiveawayRule?.name ?? '',
                              style: subtitle2.copyWith(
                                fontWeight: FontWeight.w500,
                                color: kDarkColor,
                                fontFamily: 'Kanit'
                              )
                            )
                          ]
                        )
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    endIndent: kGap,
                    indent: kGap,
                  )
                ],
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: freeProducts.length,
                  itemBuilder: (_, index) {
                    PartnerProductModel item = freeProducts[index];

                    String widgetImage = item.image?.path ?? '';
                    String name = item.name;
                    String inCart = "x ${item.inCart} ${item.selectedUnit != null? item.selectedUnit?.unit: item.unit}";

                    return Container(
                      padding: const EdgeInsets.fromLTRB(
                        kGap, kHalfGap, kGap, kHalfGap
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageProduct(
                            imageUrl: widgetImage,
                            width: 40,
                            height: 40,
                          ),
                          const Gap(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: subtitle2.copyWith(
                                          fontWeight: FontWeight.w400,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    const Gap(),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(kQuarterGap, 0, kQuarterGap, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(kRadius/2),
                                        color: Colors.transparent,
                                        border: Border.all(
                                          color: kAppColor
                                        )
                                      ),
                                      child: Text(
                                        lController.getLang('Free Product'),
                                        style: caption.copyWith(
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w500,
                                          height: 1.45,
                                          color: kAppColor,
                                          fontSize: 10
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(gap: kQuarterGap/2),
                                Text(
                                  inCart,
                                  style: subtitle2.copyWith(
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    );
                    
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                ),
              ],
            ),
          ),
          const Divider(height: 0.8, thickness: 0.8),
        ]else...[
          const Divider(height: 0.8, thickness: 0.8),
        ],
        Column(
          children: [
            const SizedBox(height: kQuarterGap),
            Padding(
              padding: const EdgeInsets.fromLTRB(kGap, kQuarterGap, kGap, kQuarterGap),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lController.getLang(fromSubscription? "Package Price": "Subtotal"),
                    style: subtitle1.copyWith(
                      color: kDarkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    priceFormat(model.total, lController),
                    style: subtitle1.copyWith(
                      color: kDarkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: kQuarterGap),
            const Divider(height: 0.8, thickness: 0.8),
            const SizedBox(height: kQuarterGap),

            if(model.subscriptionInitialPriceInVAT() > 0)...[
              Padding(
                padding: const EdgeInsets.fromLTRB(kGap, kQuarterGap, kGap, kQuarterGap),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lController.getLang("Initial Product Price"),
                      style: subtitle1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      priceFormat(model.subscriptionInitialPriceInVAT(), lController),
                      style: subtitle1.copyWith(
                        fontWeight: FontWeight.w500,
                        color: kYellowColor
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if(model.couponDiscount > 0 || model.couponMissingPaymentDiscount > 0) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(kGap, kQuarterGap, kGap, kQuarterGap),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lController.getLang("Product Coupon"),
                      style: subtitle1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(model.couponDiscount > 0) ...[
                          Text(
                            '- ${priceFormat(model.couponDiscount, lController)}',
                            style: subtitle3.copyWith(
                              fontWeight: FontWeight.w500,
                              color: kAppColor,
                              height: 1.2,
                            ),
                          ),
                        ],
                        if(model.couponMissingPaymentDiscount > 0) ...[
                          Text(
                            '- ${priceFormat(model.couponMissingPaymentDiscount, lController)}',
                            style: subtitle3.copyWith(
                              fontWeight: FontWeight.w500,
                              color: kBlueColor,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(kGap, kQuarterGap, kGap, kQuarterGap),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lController.getLang("Shipping Cost"),
                    style: subtitle1.copyWith(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    model.shippingCost <= 0
                      ? 'FREE'
                      : priceFormat(model.shippingCost, lController),
                    style: subtitle1.copyWith(
                      fontWeight: FontWeight.w500,
                      color: model.shippingCost <= 0
                        ? kAppColor: kDarkColor
                    ),
                  ),
                ],
              ),
            ),
            if(model.shippingCost > 0 && model.shippingDiscount > 0) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(kGap, kQuarterGap, kGap, kQuarterGap),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lController.getLang("Shipping Coupon"),
                      style: subtitle1.copyWith(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '- ${priceFormat(model.shippingDiscount, lController)}',
                      style: subtitle3.copyWith(
                        fontWeight: FontWeight.w500,
                        color: kAppColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if(model.cashDiscount > 0 || model.cashMissingPaymentDiscount > 0) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(kGap, kQuarterGap, kGap, kQuarterGap),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lController.getLang("Cash Coupon"),
                      style: subtitle1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(model.cashDiscount > 0) ...[
                          Text(
                            '- ${priceFormat(model.cashDiscount, lController)}',
                            style: subtitle3.copyWith(
                              fontWeight: FontWeight.w500,
                              color: kAppColor,
                              height: 1.2,
                            ),
                          ),
                        ],
                        if(model.cashMissingPaymentDiscount > 0) ...[
                          Text(
                            '- ${priceFormat(model.cashMissingPaymentDiscount, lController)}',
                            style: subtitle3.copyWith(
                              fontWeight: FontWeight.w500,
                              color: kBlueColor,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if(model.pointDiscount > 0) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(kGap, kQuarterGap, kGap, kQuarterGap),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${lController.getLang("Use")} ${numberFormat(model.pointBurn.toDouble(), digits: 0)} ${lController.getLang("Points")}',
                      style: subtitle1.copyWith(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '- ${priceFormat(model.pointDiscount, lController)}',
                      style: subtitle1.copyWith(
                        fontWeight: FontWeight.w500,
                        color: kAppColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: kQuarterGap),
            const Divider(height: 0.8, thickness: 0.8),
            Padding(
              padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.isValidDownPayment() 
                          ? lController.getLang("Total Down Payment") 
                          : lController.getLang("Grand Total"),
                        style: subtitle1.copyWith(
                          color: kAppColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if(model.isValidDownPayment() && (model.customDownPayment ?? 0) > 0)...[
                        Text(
                          '${lController.getLang('Choose Down Payment')} ${numberFormat(model.customDownPayment, digits: 0)}%',
                          style: bodyText2.copyWith(
                            color: kDarkColor,
                            fontWeight: FontWeight.w300,
                            height: 1
                          ),
                        ),
                      ]
                    ],
                  ),
                  Text(
                    priceFormat(model.grandTotal, lController),
                    style: subtitle1.copyWith(
                      color: kAppColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if(model.isValidDownPayment()) ...[
              const Divider(height: 0.8, thickness: 0.8),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  kGap, kHalfGap, kGap, kHalfGap,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lController.getLang("Payment Before Installation"),
                      style: subtitle1.copyWith(
                        color: kDarkColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          model.displayMissingPayment(lController),
                          style: subtitle1.copyWith(
                            height: 1.25,
                            color: kDarkColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if(model.fullMissingPayment > model.missingPayment) ...[
                          Text(
                            priceFormat(model.fullMissingPayment, lController),
                            style: subtitle2.copyWith(
                              height: 1.25,
                              color: kDarkLightGrayColor,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if(model.isValidDownPayment())...[
              const Divider(height: 0.8, thickness: 0.8),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  kGap, kHalfGap, kGap, kHalfGap,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lController.getLang("Grand Total"),
                      style: subtitle1.copyWith(
                        color: kDarkColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      priceFormat(model.grandTotal+model.missingPayment, lController),
                      style: subtitle1.copyWith(
                        height: 1.25,
                        color: kDarkColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            if(!isSubscription)...[
              const Divider(height: 0.8, thickness: 0.8),
              const SizedBox(height: kHalfGap),
              Padding(
                padding: const EdgeInsets.fromLTRB(kGap, 2, kGap, kHalfGap),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lController.getLang("reward Point(s)"),
                      style: subtitle1.copyWith(
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    BadgeDefault(
                      title: numberFormat(model.pointEarn.toDouble(), digits: 0),
                      icon: FontAwesomeIcons.crown,
                      size: 13,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
            ],

            // if(model.receivedCoupons.isNotEmpty && _customerController.isCustomer())...[
            if(model.receivedCoupons.isNotEmpty)...[
              const Divider(height: 0.8, thickness: 0.8),
              const Gap(gap: kHalfGap),
              WillReceivedCoupons(
                data: model.receivedCoupons,
                lController: lController,
                couponTitle: "Received Coupons",
              ),
              if(model.paymentStatus == 1)...[
                const Gap(gap: kHalfGap),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kGap),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      lController.getLang("Coupon will be valid after payment"),
                      style: caption.copyWith(
                        color: kRedColor,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ),
              ],
              const Gap(gap: kHalfGap),
              // const DividerThick(),
            ]
          ],
        ),
      ],
    );
  }
}
