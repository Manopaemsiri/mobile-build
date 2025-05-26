import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

class CardPackageProduct extends StatelessWidget {
  const CardPackageProduct({
    Key? key,
    required this.data,
    required this.onTap,
    required this.customerController,
    required this.lController,
    required this.aController,
    required this.showStock,
    this.bgColor = kWhiteColor,
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
        
        const double imageRatio = 178/150;
        final double cardHeight = (cardWidth/imageRatio)
          + ((bodyText2.fontSize!*1.4)*2)
          + (2*kHalfGap);

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
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                        child: Text(
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