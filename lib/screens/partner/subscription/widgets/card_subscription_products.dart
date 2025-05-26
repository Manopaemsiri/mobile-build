import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';

import '../../../../config/index.dart';
import '../../../../controller/language_controller.dart';
import '../../../../utils/formater.dart';
import '../../../../widgets/index.dart';

class CardSubscriptionProducts extends StatelessWidget {
  const CardSubscriptionProducts({
    Key? key,
    required this.data,
    required this.products,
    required this.lController,
    this.trimDigits = false,
    this.shipping,
  }) : super(key: key);
  final CustomerSubscriptionCartModel data;
  final bool trimDigits;
  final List<PartnerProductModel> products;
  final LanguageController lController;
  final PartnerShippingFrontendModel? shipping;

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, i) {
            PartnerProductModel product = products[i];
            
            return Padding(
              padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'x ${product.inCart} ${product.selectedUnit == null
                                ? product.unit: product.selectedUnit!.unit}',
                              style: subtitle2.copyWith(
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(product.addPriceInVAT > 0)...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kQuarterGap
                          ),
                          decoration: BoxDecoration(
                            color: kYellowColor,
                            borderRadius: BorderRadius.circular(kRadius)
                          ),
                          child: Text(
                            priceFormat(product.addPriceInVAT, lController, trimDigits: trimDigits),
                            style: subtitle2.copyWith(
                              fontWeight: FontWeight.w500,
                              color: kWhiteColor
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
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
            );
          }, 
          separatorBuilder: (_, __) => const Divider(height: 1), 
          itemCount: products.length
        ),
        const Divider(
          height: kGap,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kGap),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lController.getLang("Package Price"),
                style: subtitle1.copyWith(
                  color: kDarkColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                priceFormat(data.total, lController, trimDigits: trimDigits),
                style: subtitle1.copyWith(
                  color: kDarkColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        if(data.initialPriceInVAT > 0)...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGap) + const EdgeInsets.only(top: kHalfGap),
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
                  priceFormat(data.initialPriceInVAT, lController, trimDigits: trimDigits),
                  style: subtitle1.copyWith(
                    fontWeight: FontWeight.w500,
                    color: kYellowColor
                  ),
                ),
              ],
            ),
          ),
        ],
        const Divider(
          height: kGap,
          endIndent: kGap,
          indent: kGap,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kGap) + const EdgeInsets.only(bottom: kHalfGap),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lController.getLang("Grand total"),
                style: subtitle1.copyWith(
                  color: kAppColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                priceFormat(data.displayGrandTotal(shipping), lController, trimDigits: trimDigits),
                style: subtitle1.copyWith(
                  color: kAppColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}