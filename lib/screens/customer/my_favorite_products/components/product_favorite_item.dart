import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductFavoriteItem extends StatelessWidget {
  const ProductFavoriteItem({
    super.key,
    required this.model,
    required this.onTap,
    this.isFavorited = true,
    this.showStock = false,
    required this.lController,
    required this.aController,
    this.trimDigits = false
  });

  final PartnerProductModel model;
  final VoidCallback onTap;
  final bool isFavorited;
  final bool showStock;
  final LanguageController lController;
  final AppController aController;
  final bool trimDigits;

  @override
  Widget build(BuildContext context) {
    final CustomerController _customerController = Get.find<CustomerController>();

    String widgetImage = model.image?.path ?? '';
    String widgetName = model.name;
    String widgetMemberPrice = model.isDiscounted()
      ? model.displayDiscountPrice(lController, trimDigits: trimDigits) 
      : model.displayMemberPrice(lController, trimDigits: trimDigits);
    String widgetUnit = "/ ${model.unit}";
    Widget widgetFavoriteIcon = isFavorited
      ? const Icon(Icons.favorite, color: kAppColor)
      : const Icon(Icons.favorite_border, color: kAppColor);

    PartnerProductStatusModel? widgetStatus;
    if(aController.productStatuses.isNotEmpty && model.stock > 0){
      final int index = aController.productStatuses.indexWhere((d) => d.productStatus == model.status && d.type != 1);
      if(index > -1) widgetStatus = aController.productStatuses[index];
    }
    widgetStatus ??= model.productBadge(lController);
    const double imageWidth = 88;
    const double badgeWidth = imageWidth/2.5;

    bool stockCenter = model.stockCenter > 0 && model.status != 1;
    bool stockShop = model.stock > 0 && model.status != 1;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: kWhiteColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(kGap, kGap, kHalfGap, kGap),
              child: Row(
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
                                  // widgetStatus.needTranslate? lController.getLang(widgetStatus.name): widgetStatus.name,
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
                                    ? widgetStatus.text.replaceAll('_DISCOUNT_PERCENT_', "${model.discountPercent()}")
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
                              top: 0, left: 0,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: kGap),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: Text(
                                    widgetName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: subtitle1.copyWith(
                                      fontWeight: FontWeight.w500,
                                      height: 1.45
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: widgetFavoriteIcon,
                                iconSize: 1.5*kGap,
                                splashRadius: 1.25*kGap,
                                onPressed: () async {
                                  await _customerController.toggleFavoriteProduct(model.id ?? '');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: widgetMemberPrice,
                              style: headline6.copyWith(
                                fontFamily: 'Kanit',
                                color: kAppColor,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: " $widgetUnit",
                                  style: caption.copyWith(
                                    fontFamily: 'Kanit',
                                    color: kDarkColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if(model.isDiscounted() || model.isSetSaved()) ...[
                                  const TextSpan(text: "  "),
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
                                    text: model.displayDownPayment(lController, trimDigits: trimDigits),
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
      ),
    );
  }
}
