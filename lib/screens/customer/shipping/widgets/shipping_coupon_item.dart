import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

class ShippingCouponItem extends StatelessWidget {
  const ShippingCouponItem({
    super.key,
    required this.data,
    required this.lController
  });
  final PartnerShippingCouponModel data;
  final LanguageController lController;

  @override
  Widget build(BuildContext context) {
    final imageUrl = data.image?.path ?? '';
    final name = data.name;
    final actualDiscount = priceFormat(data.actualDiscount, lController);
    
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: kAppColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(kRadius)
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 66/44,
              child: ImageUrl(
                imageUrl: imageUrl,
                borderRadius:  BorderRadius.zero,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kHalfGap, horizontal: kHalfGap),
                child: Row(
                  children: [
                    const Gap(gap: kHalfGap),
                    Expanded(
                      child: Text(
                        '$name\n\n',
                        maxLines: 2,
                        style: caption.copyWith(
                          color: kAppColor,
                          fontSize: 11,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                    const Gap(gap: kHalfGap),
                    Text(
                      '-$actualDiscount',
                      style: bodyText2.copyWith(
                        color: kAppColor,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}