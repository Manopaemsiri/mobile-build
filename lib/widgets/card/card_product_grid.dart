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

class CardProductGrid extends StatelessWidget {
  const CardProductGrid({
    Key? key,
    required this.data,
    required this.onTap,
    required this.customerController,
    required this.lController,
    required this.aController,
    required this.showStock,
    this.bgColor = kWhiteColor,
    this.trimDigits = true,
    this.enabledBoxShadow = false,
    this.padding = const EdgeInsets.fromLTRB(kGap, kGap, kGap, 0),
    this.showFavorited = false,
  }) : super(key: key);
  final List<PartnerProductModel> data;
  final Function(PartnerProductModel) onTap;
  final CustomerController customerController;
  final LanguageController lController;
  final AppController aController;
  final bool showStock;
  final Color bgColor;
  final bool trimDigits;
  final bool enabledBoxShadow;
  final EdgeInsetsGeometry? padding;
  final bool showFavorited;

  @override
  Widget build(BuildContext context) {
    
    return data.isEmpty
    ? const SizedBox.shrink()
    : LayoutBuilder(
      builder: (_, boxConstraints) {
        final double cardW = min((boxConstraints.maxWidth-(kGap*2)-kHalfGap)/2, 176.36363636363637);
        double screenWidth = boxConstraints.maxWidth;
        int crossAxisCount = (screenWidth / cardW).floor();

        double cardWidth = (MediaQuery.of(context).size.width - (2*kGap) - ((crossAxisCount-1)*kHalfGap))/crossAxisCount;
        
        const double starHeight = 15;
        
        const double imageRatio = 178/150;
        final double cardHeight = (cardWidth/imageRatio)
          + ((bodyText2.fontSize!*1.4)*3)
          + (title.fontSize!*1.2)
          + kQuarterGap+(2*kHalfGap)
          + (!showStock? 0: subtitle2.fontSize!*1.4)
          + (kQuarterGap*2)
          + starHeight;

        return GridView.builder(
          key: key,
          restorationId: key.toString(),
          shrinkWrap: true,
          padding: padding,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: kHalfGap,
            crossAxisSpacing: kHalfGap,
            childAspectRatio: cardWidth/cardHeight
          ),
          itemCount: data.length,
          itemBuilder: (_, index) {
            PartnerProductModel item = data[index];
            final imageUrl = item.image?.path ?? '';
            final String name = item.name;

            final double? score = item.rating;

            bool showStock = customerController.isShowStock();

            bool stockCenter = item.stockCenter > 0 && item.status != 1;
            bool stockShop = item.stock > 0 && item.status != 1;
            
            PartnerProductStatusModel? _status;
            if(aController.productStatuses.isNotEmpty && item.stock > 0){
              final int index = aController.productStatuses.indexWhere((d) => d.productStatus == item.status && d.type != 1);
              if(index > -1) _status = aController.productStatuses[index];
            }
            _status ??= item.productBadge(lController);
            final double badgeWidth = cardWidth/4;


            String _price = item.isSetSaved()
              ? item.displaySetSavedPrice(lController, trimDigits: trimDigits)
              : item.displayPrice(lController, trimDigits: trimDigits);
            String _memberPrice = item.isSetSaved()
              ? item.displaySetSavedPrice(lController, trimDigits: trimDigits)
              : item.isDiscounted() 
              ? item.displayDiscountPrice(lController, trimDigits: trimDigits)
              : item.displayMemberPrice(lController, trimDigits: trimDigits);
            String _unit = "/ ${item.unit}";

            Widget _favoriteIcon = customerController.isFavoriteProduct(item)
            ? const Icon(Icons.favorite, color: kAppColor)
            : const Icon(Icons.favorite_border, color: kAppColor);

            return InkWell(
              borderRadius: BorderRadius.circular(kCardRadius),
              onTap: () => onTap(item),
              child: Container(
                width: cardWidth,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(kCardRadius),
                  boxShadow: enabledBoxShadow? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
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
                                // show: true
                              ),
                            ),
                          ),
                          if(_status != null)...[
                            if(_status.productStatus == 1)...[
                              Positioned(
                                top: 0, bottom: 0, left: 0, right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(kQuarterGap),
                                  color: kWhiteColor.withOpacity(0.45),
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
                                      item.isDiscounted()
                                        ? _status.text.replaceAll('_DISCOUNT_PERCENT_', "${item.discountPercent()}")
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
                          if(showFavorited)...[
                            Positioned(
                              top: 0, right: 0,
                              child: IconButton(
                                alignment: Alignment.topRight,
                                icon: _favoriteIcon,
                                iconSize: 1.5*kGap,
                                splashRadius: 1.25*kGap,
                                onPressed: () async =>
                                  await customerController.toggleFavoriteProduct(item.id ?? ''),
                              ),
                            )
                          ],
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$name\n\n',
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              style: bodyText2.copyWith(
                                color: kDarkColor,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                                fontSize: 13
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
                                textScaleFactor: 1,
                                text: TextSpan(
                                  text: _memberPrice,
                                  style: title.copyWith(
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
                              if(item.isDiscounted() || item.isSetSaved()) ...[
                                Text( 
                                  item.isSetSaved()
                                  ? item.displaySetFullSavedPrice(lController, showSymbol: false, trimDigits: trimDigits)
                                  : item.displayMemberPrice(lController, showSymbol: false, trimDigits: trimDigits),
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: bodyText2.copyWith(
                                    color: kDarkColor.withOpacity(0.3),
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
                                  style: bodyText2.copyWith(
                                    color: kDarkColor.withOpacity(0.3),
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
                                textScaleFactor: 1,
                                text: TextSpan(
                                  text: _price,
                                  style: title.copyWith(
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
                              if(item.isSetSaved()) ... [
                                Text( 
                                  item.displaySetFullSavedPrice(lController, showSymbol: false, trimDigits: trimDigits),
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: bodyText2.copyWith(
                                    color: kDarkColor.withOpacity(0.3),
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                    decoration: TextDecoration.lineThrough
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]else if(item.signinPrice() < item.priceInVAT) ...[
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
                                      textScaleFactor: 1,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            alignment: PlaceholderAlignment.middle,
                                            child: Icon(
                                              FontAwesomeIcons.crown,
                                              size: bodyText2.fontSize,
                                              color: kWhiteColor,
                                            )
                                          ),
                                          const WidgetSpan( child: Gap(gap: kHalfGap) ),
                                          TextSpan(
                                            text: _memberPrice,
                                            style: bodyText2.copyWith(
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
                                  style: subtitle2.copyWith(
                                    color: stockCenter? kAppColor.withOpacity(0.8): kDarkLightGrayColor.withOpacity(0.6),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Kanit",
                                  ),
                                  children: <InlineSpan>[
                                    const WidgetSpan(child: Gap(gap: kHalfGap)),
                                    TextSpan(
                                      text: lController.getLang("text_click_and_collect"),
                                      style: subtitle2.copyWith(
                                        color: stockShop? kAppColor.withOpacity(0.8): kDarkLightGrayColor.withOpacity(0.6),
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
        );
      }
    );
  }
}