import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.onChanged,
    required this.value,
    required this.imageWidth,
  });

  final PartnerProductModel product;
  final Function(bool?) onChanged;
  final bool? value;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    final String imagePath = product.image?.path ?? '';
    final String productName = product.name;

    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: onChanged, 
      value: value,
      activeColor: kAppColor,
      checkColor: kWhiteColor,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius),
      ),
      side: BorderSide(
        width: 1,
        strokeAlign: BorderSide.strokeAlignCenter,
        color: kLightColor
      ),
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageProduct(
            imageUrl: imagePath,
            width: imageWidth,
            height: imageWidth,
          ),
          const Gap(gap: kHalfGap),
          Expanded(
            child: Text(
              productName,
              maxLines: 4,
              textAlign: TextAlign.start,
              style: bodyText2.copyWith(
                color: kDarkColor,
                fontWeight: FontWeight.w400,
                height: 1.4,
                fontSize: 14
              ),
            ),
          ),
        ],
      ), 
    );
  }
}