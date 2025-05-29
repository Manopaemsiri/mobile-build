import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/formater.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutOrderItem extends StatelessWidget {
  const CheckoutOrderItem({
    super.key,
    required this.model,
    required this.lController,
    required this.settings
  });

  final CustomerCartModel model;
  final LanguageController lController;
  final Map<String, dynamic> settings;

  @override
  Widget build(BuildContext context) {
    final List<PartnerProductModel> products = model.products.where((d) => d.status != -2).toList();
    final List<PartnerProductModel> freeProducts = model.products.where((d) => d.status == -2).toList();

    return !model.isValid()
      ? const SizedBox.shrink()
      : Column(
        children: [
          // if(_appController.enabledMultiPartnerShops) ...[
          //   const Divider(height: 1),
          //   Container(
          //     padding: kPadding,
          //     color: kWhiteColor,
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         const Icon(
          //           Icons.store_rounded,
          //           color: kAppColor,
          //           size: 22,
          //         ),
          //         const SizedBox(width: kGap),
          //         Text(
          //           model.shop?.name ?? '',
          //           style: subtitle1.copyWith(
          //             color: kAppColor,
          //             fontWeight: FontWeight.w600
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],

          const DividerThick(),
          Column(
            children: products.map((PartnerProductModel product){
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      kGap, kHalfGap, kGap, kHalfGap
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ImageProduct(
                              imageUrl: product.image?.path ?? '',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: kOtGap),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: subtitle2.copyWith(
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),                                                
                                  const SizedBox(height: 2),
                                  Text(
                                    'x ${product.inCart} ${product.selectedUnit == null
                                      ? product.unit: product.selectedUnit!.unit}',
                                    style: subtitle2.copyWith(
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                    ),
                                  ),
                                  if(product.eventId.isNotEmpty)...[
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(kRadius/2),
                                        color: kWhiteColor,
                                        border: Border.all(
                                          color: kAppColor
                                        )
                                      ),
                                      child: Text(
                                        lController.getLang('text_added_from_event').replaceAll('_VALUE_', product.eventName),
                                        style: caption.copyWith(
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                          height: 1.45,
                                          color: kAppColor
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 105,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    product.displayTotalPriceInVAT(lController),
                                    style: subtitle2.copyWith(
                                      fontWeight: FontWeight.w500
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                  if(product.isValidDownPayment()) ...[
                                    Text(
                                      "${lController.getLang("Deposit")} ${product.displayTotalDownPaymentInVAT(lController)}",
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
                                    if(product.discountInVAT > 0) ...[
                                      Text(
                                        product.displayFullAmountInVAT(lController, showSymbol: false),
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
                        if(product.shipBySupplier == 1) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40+kOtGap, 2, 0, 0),
                            child: Text(
                              "*** ${lController.getLang("text_lion_delivered_1")} ${product.preparingDays} ${lController.getLang("Days")}",
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
                  ),
                  const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
          if(settings?['APP_ENABLE_FEATURE_PARTNER_PRODUCT_REWARD'] == '1' 
          && freeProducts.isNotEmpty)...[
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

                      String _image = item.image?.path ?? '';
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
                              imageUrl: _image,
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
            const Divider(height: 1),
          ],
          GetBuilder<CustomerController>(builder: (controller) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    kGap, kHalfGap, kGap, kHalfGap
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        model.isValidDownPayment() 
                          ? lController.getLang("Subtotal Down Payment") 
                          : lController.getLang("Subtotal"),
                        style: subtitle1.copyWith(
                          color: kAppColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        priceFormat(model.total, lController),
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
                              priceFormat(
                                controller.cartMissingPayment(),
                                lController
                              ),
                              style: subtitle1.copyWith(
                                height: 1.25,
                                color: kDarkColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if(controller.cartMissingPayment() < model.missingPayment) ...[
                              Text(
                                priceFormat(model.missingPayment, lController),
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
              ],
            );
          }),
        ],
      );
  }
}
