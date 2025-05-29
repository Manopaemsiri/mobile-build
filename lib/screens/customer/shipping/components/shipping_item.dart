import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/shipping/widgets/shipping_coupon_item.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

class ShippingItem extends StatelessWidget {
  const ShippingItem({
    super.key,
    required this.model,
    required this.onSelect,
    required this.lController,
    this.shippingCoupon,
    this.shopShopDetail = false,
    this.showImage = false,
    this.size = 38,
  });
  final PartnerShippingFrontendModel model;
  final Function(PartnerShippingFrontendModel, PartnerShippingCouponModel?) onSelect;
  final LanguageController lController;
  final PartnerShippingCouponModel? shippingCoupon;

  final bool shopShopDetail;
  final bool showImage;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String txtTitle = shopShopDetail? model.shop?.name ?? '': model.displayName;
    String imageUrl = model.icon?.path ?? '';
    if(showImage && model.shop?.image?.path != null) imageUrl = model.shop?.image?.path ?? '';
    final bool enabled = model.hasShortages() && (model.type != 2 || shopShopDetail);

    return IgnorePointer(
      ignoring: enabled,
      child: InkWell(
        onTap: enabled
          ? null
          : () => onSelect(model, shippingCoupon),
        child: Container(
          color: enabled? kGrayLightColor: kWhiteColor,
          child: Opacity(
            opacity: enabled? 0.8: 1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kGap, horizontal: kGap
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: size,
                        width: size,
                        padding: const EdgeInsets.only(top: kQuarterGap*1.5),
                        child: ImageUrl(
                          imageUrl: imageUrl,
                          borderRadius: showImage? BorderRadius.circular(kRadius): null,
                        ),
                      ),
                      const Gap(gap: kGap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    txtTitle,
                                    style: title.copyWith(
                                      fontWeight: FontWeight.w500
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                
                                enabled
                                ? const SizedBox.shrink()
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      model.type == 2 || model.price <= 0
                                        ? 'FREE': model.displayPrice(lController),
                                      style: title.copyWith(
                                        color: kAppColor,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2
                                      ),
                                    ),
                                    model.type != 2 && model.discount > 0
                                    ? Text(
                                      model.displayDiscount(lController),
                                      style: subtitle1.copyWith(
                                        color: kGrayColor,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.lineThrough,
                                        height: 1
                                      ),
                                    ): const SizedBox.shrink(), 
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            
                            enabled? Padding(
                              padding: const EdgeInsets.only(bottom: kQuarterGap),
                              child: Text(
                                lController.getLang('Not enough products in the store'),
                                style: subtitle2
                              ),
                            ): const SizedBox.shrink(),
                            if(enabled)...[
                              ...model.shortages.map((d){
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: kHalfGap),
                                    Text(
                                      '●',
                                      style: subtitle2.copyWith(
                                        fontWeight: FontWeight.w400,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(width: kHalfGap),
                                    Expanded(
                                      child: Text(
                                        '${lController.getLang("Missing")} ${d['name']} ${numberFormat(double.parse(d['shortage'].toString()), digits: 0)} ${d['unit']}',
                                        style: subtitle2.copyWith(
                                          fontWeight: FontWeight.w500,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if(!model.hasShortages()) ...[
                                  if(model.type == 2)...[
                                    Text(
                                      lController.getLang('Choose the date and time to pick up the product'),
                                      style: subtitle2
                                    ),
                                  ]else if(model.type != 2)...[
                                    Text(
                                      // model.displayDeliveryDate(lController),
                                      model.displaySummary(lController),
                                      style: subtitle2
                                    )
                                  ]
                                ]
                                // else ...[
                                //   Text(
                                //     "",
                                //     style: subtitle2
                                //   ),
                                // ],
                              ],
                            ),
                            
                            // Condition checked before send to API
                            if(!enabled && shippingCoupon != null)...[
                              const Gap(),
                              ShippingCouponItem(
                                data: shippingCoupon!,
                                lController: lController,
                              ),
                            ],
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 1),
              ],
            ),
          ),
        ),
      )
    );
  }
}
