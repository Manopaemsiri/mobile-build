import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CardShippingCoupon extends StatelessWidget {
  const CardShippingCoupon({
    super.key,
    this.width = 150,
    required this.model,
    required this.onPressed,
  });

  final double width;
  final PartnerShippingCouponModel model;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    String _image = model.image?.path ?? "";
    String _title = model.name;
    String _body = model.shortDescription;

    const double imageRatio = 178/150;
    final double cardWidth = min((Get.width-kGap)/2.4, 172.5);
    final double cardHeight = (cardWidth/imageRatio)
      + ((bodyText1.fontSize!*1.4)*2)
      + ((bodyText2.fontSize!*1.4)*2)
      + kQuarterGap
      + (kHalfGap*2);

    return InkWell(
      borderRadius: BorderRadius.circular(kCardRadius),
      onTap: onPressed,
      child: Container(
        width: cardWidth,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(kCardRadius),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.1),
          //     spreadRadius: 1,
          //     blurRadius: 10.5,
          //     offset: const Offset(0, 0),
          //   ),
          // ]
        ),
        padding: EdgeInsets.zero,
        child: AspectRatio(
          aspectRatio: cardWidth/cardHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: cardWidth,
                color: kWhiteColor,
                padding: EdgeInsets.zero,
                child: AspectRatio(
                  aspectRatio: imageRatio,
                  child: ImageUrl(
                    imageUrl: _image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_title\n\n',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: bodyText1.copyWith(
                        color: kDarkColor,
                        fontWeight: FontWeight.w500,
                        height: 1.4
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(gap: kQuarterGap),
                    Text(
                      '$_body\n\n',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: bodyText2.copyWith(
                        color: kGrayColor,
                        // fontWeight: FontWeight.w500,
                        height: 1.4
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    // return SizedBox(
    //   width: width,
    //   child: Card(
    //     elevation: 0.8,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(kRadius),
    //     ),
    //     child: InkWell(
    //       onTap: onPressed,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           SizedBox(
    //             height: 100,
    //             width: double.infinity,
    //             child: ClipRRect(
    //               borderRadius: const BorderRadius.only(
    //                 topLeft: Radius.circular(kRadius),
    //                 topRight: Radius.circular(kRadius),
    //               ),
    //               child: ImageUrl(
    //                 imageUrl: _image,
    //                 borderRadius: const BorderRadius.only(
    //                   topLeft: Radius.circular(4),
    //                   topRight: Radius.circular(4),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Container(
    //             height: 84 + kGap,
    //             padding: kHalfPadding,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 SizedBox(
    //                   child: Text(
    //                     _title,
    //                     maxLines: 2,
    //                     style: bodyText2.copyWith(
    //                       color: kDarkColor,
    //                       fontWeight: FontWeight.w500,
    //                       height: 1.4
    //                     ),
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                 ),
    //                 const SizedBox(height: kQuarterGap),
    //                 SizedBox(
    //                   height: 40,
    //                   child: Text(
    //                     _body,
    //                     maxLines: 2,
    //                     style: caption.copyWith(color: kGrayColor),
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}