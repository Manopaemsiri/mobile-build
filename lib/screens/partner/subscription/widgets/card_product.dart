import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

class SubscriptionProduct extends StatelessWidget {
  const SubscriptionProduct({
    super.key,
    required this.data,
    required this.onTap,
    required this.lController,
    required this.aController,
    required this.showStock,
    this.bgColor = kWhiteColor,
    this.trimDigits = true,
    this.enabledBoxShadow = false,
    this.padding = const EdgeInsets.fromLTRB(kGap, kGap, kGap, 0),
    this.showFavorited = false,
    this.sumCredit = 0,
    this.increaseItem,
    this.decreaseItem,
  });
  final SelectionSteps data;
  final Function(PartnerProductModel) onTap;
  final LanguageController lController;
  final AppController aController;
  final bool showStock;
  final Color bgColor;
  final bool trimDigits;
  final bool enabledBoxShadow;
  final EdgeInsetsGeometry? padding;
  final bool showFavorited;
  final double sumCredit;
  final Function(int productIndex)? increaseItem;
  final Function(int productIndex)? decreaseItem;

  @override
  Widget build(BuildContext context) {
    
    return data.products.isEmpty
    ? const SizedBox.shrink()
    : LayoutBuilder(
      builder: (_, boxConstraints) {
        final double cardW = min((boxConstraints.maxWidth-(kGap*2)-kHalfGap)/2, 176.36363636363637);
        double screenWidth = boxConstraints.maxWidth;
        int crossAxisCount = (screenWidth / cardW).floor();

        double cardWidth = (MediaQuery.of(context).size.width - (2*kGap) - ((crossAxisCount-1)*kHalfGap))/crossAxisCount;
        
        const double imageRatio = 178/150;
        final double cardHeight = (cardWidth/imageRatio)
          + ((bodyText2.fontSize!*1.4)*3)
          + (kQuarterGap*4)
          + (kHalfGap*2)
          + 24;

        final List<RelatedProduct>  products = data.products;
        
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
          itemCount: products.length,
          itemBuilder: (_, index) {
            RelatedProduct item = products[index];
            final PartnerProductModel? product = item.product;
            if(product == null) return const SizedBox.shrink();

            final imageUrl = product.image?.path ?? '';
            final String name = product.name;

            int dataQuantity = item.quantity;
            String dataAddPriceInVAT = priceFormat(item.addPriceInVAT, lController, trimDigits: trimDigits);

            double credit = item.credit;
            String dataCredit = numberFormat(credit, digits: 0);

            bool canAddItem = sumCredit + credit <= data.credit;

            return Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () => onTap(product),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(kRadius), topRight: Radius.circular(kRadius)),
                          child: Container(
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
                        ),
                        Positioned(
                          top: kHalfGap, right: kHalfGap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: kWhiteColor,
                              border: Border.all(
                                strokeAlign: BorderSide.strokeAlignCenter,
                                width: 1,
                                color: Colors.yellow[600] ?? kYellowColor,
                              ),
                            ),
                            child: RichText(
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              textScaler: TextScaler.linear(1),
                              text: TextSpan(
                                style: title.copyWith(
                                  fontFamily: 'Kanit',
                                  color: kAppColor,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      Icons.paid,
                                      color: Colors.yellow[600],
                                      size: title.fontSize,
                                    )
                                  ),
                                  TextSpan(
                                    text: ' $dataCredit',
                                    style: title.copyWith(
                                      fontFamily: 'Kanit',
                                      color: kAppColor,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                          RichText(
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            textScaler: TextScaler.linear(1),
                            text: TextSpan(
                              text: item.addPriceInVAT > 0? '+ $dataAddPriceInVAT': '',
                              style: bodyText2.copyWith(
                                fontFamily: 'Kanit',
                                color: kAppColor,
                                fontWeight: FontWeight.w600,
                                height: 1.2
                              ),
                            ),
                          ),
                          const Gap(gap: kQuarterGap),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: kQuarterGap, vertical: kQuarterGap),
                            decoration: BoxDecoration(
                              color: kAppColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(kRadius)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: decreaseItem != null? () => decreaseItem!(index): null,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(kRadius),
                                      color: dataQuantity == 0? kLightColor: kAppColor,
                                    ),
                                    child: const Icon(
                                      Icons.remove_rounded,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$dataQuantity',
                                  style: title.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: kDarkColor.withValues(alpha: dataQuantity<=0? 0.4: 1)
                                  ),
                                ),
                                InkWell(
                                  onTap: canAddItem && increaseItem != null? () => increaseItem!(index): null,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(kRadius),
                                      color: canAddItem? kAppColor: kLightColor
                                    ),
                                    child: const Icon(
                                      Icons.add_rounded,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}