import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProductFrequentlyItem extends StatelessWidget {
  const ProductFrequentlyItem({
    super.key,
    required this.model,
    required this.onChange,
    required this.lController,
    required this.aController,
    this.qty = 0,
    this.trimDigits = false,
    this.showStock = false
  });

  final PartnerProductModel model;
  final Function(int) onChange;
  final int qty;
  final LanguageController lController;
  final AppController aController;
  final bool trimDigits;
  final bool showStock;

  @override
  Widget build(BuildContext context) {
    const double imageWidth = 88;
    const double badgeWidth = imageWidth/2.5;
    
    String widgetImage = model.image?.path ?? '';
    String widgetName = model.name;
    String widgetPrice = model.selectedUnit == null
      ? model.isSetSaved()
        ? model.displaySetSavedPrice(lController, trimDigits: trimDigits)
        : model.isDiscounted()
          ? model.displayDiscountPrice(lController, trimDigits: trimDigits)
          : model.displayMemberPrice(lController, trimDigits: trimDigits)
      : model.selectedUnit!.isDiscounted()
        ? model.selectedUnit!.displayDiscountPrice(lController, trimDigits: trimDigits) 
        : model.selectedUnit!.displayMemberPrice(lController, trimDigits: trimDigits);
    String widgetUnit = model.selectedUnit == null 
      ? '/ ${model.unit}'
      : '/ ${model.selectedUnit!.unit}';

    PartnerProductStatusModel? widgetStatus;
    if(aController.productStatuses.isNotEmpty && model.stock > 0){
      final int index = aController.productStatuses.indexWhere((d) => d.productStatus == model.status && d.type != 1);
      if(index > -1) widgetStatus = aController.productStatuses[index];
    }
    widgetStatus ??= model.productBadge(lController, showSelectedUnit: model.selectedUnit?.isDiscounted() == true);

    bool stockCenter = model.stockCenter > 0 && model.status != 1;
    bool stockShop = model.stock > 0 && model.status != 1;


    const double starHeight = 15;
    final double? score = model.rating;

    return Container(
      color: kWhiteColor,
      child: Column(
        children: [
          Padding(
            padding: kPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        ImageProduct(
                          imageUrl: widgetImage,
                          width: imageWidth,
                          height: imageWidth,
                        ),
                        // if(_tag != null) ...[
                        //   Positioned(top: 0, left: 0, child: _tag),
                        // ],
                        if(widgetStatus != null)...[
                          if(widgetStatus.productStatus == 1)...[
                            Positioned(
                              top: 0, bottom: 0, left: 0, right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(kQuarterGap),
                                color: kWhiteColor.withValues(alpha: 0.45),
                                child: Center(
                                  child: Text(
                                    'Coming\nSoon',
                                    textAlign: TextAlign.center,
                                    style: subtitle2.copyWith(
                                      color: kDarkColor,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                      height: 1.05,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]else...[
                            if(widgetStatus.type == 1)...[
                              Positioned(
                                top: 0, left: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: widgetStatus.textBgColor2,
                                  ),
                                  child: Text(
                                    widgetStatus.text,
                                    style: caption.copyWith(
                                      color: widgetStatus.textColor2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ]else if(widgetStatus.type == 2)...[
                              Positioned(
                                top: 0, left: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: widgetStatus.textBgColor2,
                                  ),
                                  child: Text(
                                    model.isDiscounted()
                                      ? widgetStatus.text.replaceAll('_DISCOUNT_PERCENT_', "${model.selectedUnit == null? model.discountPercent(): model.selectedUnit?.discountPercent()}")
                                      : widgetStatus.text,
                                    style: caption.copyWith(
                                      color: widgetStatus.textColor2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ]else if(widgetStatus.type == 3)...[
                              Positioned(
                                top: kHalfGap, left: kHalfGap,
                                child: ImageProduct(
                                  imageUrl: widgetStatus.icon?.path ?? '',
                                  width: badgeWidth, 
                                  height: badgeWidth,
                                  decoration: const BoxDecoration(),
                                  fit: BoxFit.contain,
                                  alignment: Alignment.topLeft,
                                ),
                              ),
                            ]
                          ]
                        ],
                      ],
                    ),
                    if(model.isValidDownPayment()) ...[
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.circleInfo,
                          color: kAppColor,
                          size: 22,
                        ),
                        padding: kOtPadding,
                        onPressed: () => _onTapDownPaymentInfo(model),
                      ),
                    ],
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: kGap),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 48,
                          child: Text(
                            widgetName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: subtitle1.copyWith(
                              fontWeight: FontWeight.w500,
                              height: 1.45
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        CardStarRating(
                          height: starHeight,
                          score: score,
                        ),
                        // const Gap(gap: kQuarterGap),

                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: widgetPrice,
                            style: headline6.copyWith(
                              fontFamily: 'Kanit',
                              color: kAppColor,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: " $widgetUnit  ",
                                style: caption.copyWith(
                                  fontFamily: 'Kanit',
                                  color: kDarkColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              if(model.selectedUnit == null && (model.isDiscounted() || model.isSetSaved())) ...[
                                TextSpan(
                                  text: model.isSetSaved()
                                  ? model.displaySetFullSavedPrice(lController, showSymbol: false, trimDigits: trimDigits)
                                  : model.displayMemberPrice(lController, showSymbol: false, trimDigits: trimDigits),
                                  style: subtitle1.copyWith(
                                    fontFamily: 'Kanit',
                                    color: kAppColor,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ]
                              else if(model.selectedUnit != null && model.selectedUnit!.isDiscounted()) ...[
                                TextSpan(
                                  text: model.selectedUnit!.displayMemberPrice(lController, showSymbol: false, trimDigits: trimDigits),
                                  style: subtitle1.copyWith(
                                    fontFamily: 'Kanit',
                                    color: kAppColor,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if(showStock)...[
                          const SizedBox(height: 2),
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: lController.getLang("text_shipping"),
                              style: subtitle2.copyWith(
                                color: stockCenter? kAppColor.withValues(alpha: 0.8): kDarkLightGrayColor.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Kanit",
                              ),
                              children: <InlineSpan>[
                                const WidgetSpan(child: Gap(gap: kHalfGap)),
                                TextSpan(
                                  text: lController.getLang("text_click_and_collect"),
                                  style: subtitle2.copyWith(
                                    color: stockShop? kAppColor.withValues(alpha: 0.8): kDarkLightGrayColor.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Kanit",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if(model.isValidDownPayment()) ...[
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: "${lController.getLang("Deposit")} ",
                              style: subtitle2.copyWith(
                                fontFamily: 'Kanit',
                                color: kDarkColor,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: model.selectedUnit == null 
                                    ? model.displayDownPayment(lController, trimDigits: trimDigits) 
                                    : model.selectedUnit!.displayDownPayment(lController, trimDigits: trimDigits),
                                  style: title.copyWith(
                                    fontFamily: 'Kanit',
                                    color: kAppColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: kOtGap),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${lController.getLang("Quantity")} : ',
                              style: subtitle1.copyWith(
                                color: kDarkColor
                              ),
                            ),
                            QuantityBigFix(
                              qty: qty,
                              minimum: 0,
                              maximum: model.getMaxStock(),
                              onChange: (int value) => onChange(value)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  void _onTapDownPaymentInfo(PartnerProductModel product) {
    if(product.isValidDownPayment()){
      ShowDialog.showForceDialog(
        lController.getLang("text_clearance_1"),
        lController.getLang("text_deposit_product1").replaceFirst("value", "30"),
        () => Get.back(),
      );
    }
  }
}