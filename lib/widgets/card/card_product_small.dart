import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CardProductSmall extends StatelessWidget {
  const CardProductSmall({
    super.key,
    required this.data,
    required this.onTap,
    required this.customerController,
    required this.lController,
    required this.aController,
    required this.showStock,
    this.bgColor = kWhiteColor,
    this.trimDigits = true,
    this.enabledBoxShadow = false,
  });
  final PartnerProductModel data;
  final Function() onTap;
  final CustomerController customerController;
  final LanguageController lController;
  final AppController aController;
  final bool showStock;
  final Color bgColor;
  final bool trimDigits;
  final bool enabledBoxShadow;

  @override
  Widget build(BuildContext context) {
    final imageUrl = data.image?.path ?? '';
    final String name = data.name;

    final String price = data.displayPrice(lController, trimDigits: trimDigits);
    final String memberPrice = data.isDiscounted() 
      ? data.displayDiscountPrice(lController, trimDigits: trimDigits): data.displayMemberPrice(lController, trimDigits: trimDigits);
    final String unit = "/ ${data.unit}";

    bool showStock = customerController.isShowStock();

    bool stockCenter = data.stockCenter > 0 && data.status != 1;
    bool stockShop = data.stock > 0 && data.status != 1;

    const double starHeight = 12;
    final double? score = data.rating;

    const double imageRatio = 178/150;
    final double cardWidth = min((Get.width-kGap*3)/3, 114.92);
    final double cardHeight = (cardWidth/imageRatio)
      + ((caption.fontSize!*1.4)*2)
      + (bodyText2.fontSize!*1.2)
      + kQuarterGap+(2*kHalfGap)
      + (!showStock? 0: caption.fontSize!*1.4)
      + (kQuarterGap*2)
      + (!customerController.isCustomer()? kQuarterGap/2: 0)
      + starHeight;

    PartnerProductStatusModel? _status;
    if(aController.productStatuses.isNotEmpty && data.stock > 0){
      final int index = aController.productStatuses.indexWhere((d) => d.productStatus == data.status && d.type != 1);
      if(index > -1) _status = aController.productStatuses[index];
    }
    _status ??= data.productBadge(lController);
    final double badgeWidth = cardWidth/4;


    String _price = data.isSetSaved()
      ? data.displaySetSavedPrice(lController, trimDigits: trimDigits)
      : data.displayPrice(lController, trimDigits: trimDigits);
    String _memberPrice = data.isSetSaved()
      ? data.displaySetSavedPrice(lController, trimDigits: trimDigits)
      : data.isDiscounted() 
      ? data.displayDiscountPrice(lController, trimDigits: trimDigits)
      : data.displayMemberPrice(lController, trimDigits: trimDigits);
    String _unit = "/ ${data.unit}";

    return InkWell(
      borderRadius: BorderRadius.circular(kCardRadius),
      onTap: onTap,
      child: Container(
        width: cardWidth,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(kCardRadius),
          boxShadow: enabledBoxShadow? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10.5,
              offset: const Offset(0, 0),
            ),
          ]: null
        ),
        padding: EdgeInsets.zero,
        child: AspectRatio(
          aspectRatio: cardWidth/cardHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: cardWidth,
                    color: kWhiteColor,
                    padding: EdgeInsets.zero,
                    child: AspectRatio(
                      aspectRatio: imageRatio,
                      child: ImageProduct(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        padding2: EdgeInsets.zero,
                        decoration: const BoxDecoration(
                          color: kWhiteColor,
                        ),
                        imgRadius: BorderRadius.circular(0),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if(_status != null)...[
                    if(_status.productStatus == 1)...[
                      Positioned(
                        top: 0, bottom: 0, left: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(kQuarterGap),
                          color: kWhiteColor.withValues(alpha: 0.45),
                          child: Center(
                            child: Text(
                              'Coming\nSoon',
                              textAlign: TextAlign.center,
                              style: caption.copyWith(
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
                      if(_status.type == 1)...[
                        Positioned(
                          top: kHalfGap, left: kHalfGap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _status.textBgColor2,
                            ),
                            child: Text(
                              _status.text,
                              style: caption.copyWith(
                                color: _status.textColor2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ]else if(_status.type == 2)...[
                        Positioned(
                          top: kHalfGap, left: kHalfGap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _status.textBgColor2,
                            ),
                            child: Text(
                              data.isDiscounted()
                                ? _status.text.replaceAll('_DISCOUNT_PERCENT_', "${data.discountPercent()}")
                                : _status.text,
                              style: caption.copyWith(
                                color: _status.textColor2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ]else if(_status.type == 3)...[
                        Positioned(
                          top: kHalfGap, left: kHalfGap,
                          child: ImageProduct(
                            imageUrl: _status.icon?.path ?? '',
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
              Container(
                padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name\n',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: caption.copyWith(
                        color: kDarkColor,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        // fontSize: caption
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(gap: kQuarterGap),
                    CardStarRating(
                      height: starHeight,
                      score: score,
                    ),
                    const Gap(gap: kQuarterGap),

                    if(customerController.isCustomer()) ...[
                      RichText(
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        textScaler: TextScaler.linear(1),
                        text: TextSpan(
                          text: _memberPrice,
                          style: bodyText2.copyWith(
                            fontFamily: 'Kanit',
                            color: kAppColor,
                            fontWeight: FontWeight.w600,
                            height: 1.2
                          ),
                          children: [
                            TextSpan(
                              text: " $_unit  ",
                              style: caption.copyWith(
                                fontFamily: 'Kanit',
                                color: kDarkColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(data.isDiscounted() || data.isSetSaved()) ...[
                        Text( 
                          data.isSetSaved()
                          ? data.displaySetFullSavedPrice(lController, showSymbol: false, trimDigits: trimDigits)
                          : data.displayMemberPrice(lController, showSymbol: false, trimDigits: trimDigits),
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: caption.copyWith(
                            color: kDarkColor.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            decoration: TextDecoration.lineThrough
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]else ...[
                        Text( 
                          "",
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: caption.copyWith(
                            color: kDarkColor.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            decoration: TextDecoration.lineThrough
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ]else ...[
                      RichText(
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        textScaler: TextScaler.linear(1),
                        text: TextSpan(
                          text: _price,
                          style: bodyText2.copyWith(
                            fontFamily: 'Kanit',
                            color: kAppColor,
                            fontWeight: FontWeight.w600,
                            height: 1.2
                          ),
                          children: [
                            TextSpan(
                              text: " $_unit",
                              style: caption.copyWith(
                                fontFamily: 'Kanit',
                                color: kDarkColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(data.isSetSaved()) ... [
                        Text( 
                          data.displaySetFullSavedPrice(lController, showSymbol: false, trimDigits: trimDigits),
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: caption.copyWith(
                            color: kDarkColor.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            decoration: TextDecoration.lineThrough
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]else if(data.signinPrice() < data.priceInVAT) ...[
                        GestureDetector(
                          onTap: () => Get.to(() => const SignInMenuScreen()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: kQuarterGap/2, horizontal: kQuarterGap),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(kRadius),
                              color: kAppColor
                            ),
                            child: RichText(
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              textScaler: TextScaler.linear(1),
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      FontAwesomeIcons.crown,
                                      size: caption.fontSize,
                                      color: kWhiteColor,
                                    )
                                  ),
                                  const WidgetSpan( child: Gap(gap: kHalfGap) ),
                                  TextSpan(
                                    text: _memberPrice,
                                    style: caption.copyWith(
                                      fontFamily: 'Kanit',
                                      color: kWhiteColor,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                    if(showStock)...[
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: lController.getLang("text_shipping"),
                          style: caption.copyWith(
                            color: stockCenter? kAppColor.withValues(alpha: 0.8): kDarkLightGrayColor.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Kanit",
                          ),
                          children: <InlineSpan>[
                            const WidgetSpan(child: Gap(gap: kHalfGap)),
                            TextSpan(
                              text: lController.getLang("text_click_and_collect"),
                              style: caption.copyWith(
                                color: stockShop? kAppColor.withValues(alpha: 0.8): kDarkLightGrayColor.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Kanit",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}