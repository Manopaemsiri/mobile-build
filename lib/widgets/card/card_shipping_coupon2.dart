import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';


class CardShippingCoupon2 extends StatelessWidget {
  const CardShippingCoupon2({
    Key? key,
    required this.model,
    required this.onPressed,
  }) : super(key: key);

  final PartnerShippingCouponModel model;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    String _image = model.image?.path ?? "";
    String _title = model.name;
    String _body = model.shortDescription;

    return Card(
      elevation: 0.8,
      margin: const EdgeInsets.only(bottom: kHalfGap),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 118,
          child: Row(
            children: [
              SizedBox(
                height: 118,
                width: 118,
                child: ImageUrl(
                  imageUrl: _image,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kOtGap,
                          horizontal: kGap,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _title,
                              style: title.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.35
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: kQuarterGap
                              ),
                              child: Text(
                                _body,
                                style: bodyText2.copyWith(
                                  color: kGrayColor,
                                  fontWeight: FontWeight.w400
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
