import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';


class CardProductCoupon2 extends StatelessWidget {
  const CardProductCoupon2({
    super.key,
    required this.model,
    required this.onPressed,
    this.expireDate,
  });

  final PartnerProductCouponModel model;
  final VoidCallback onPressed;
  final String? expireDate;

  @override
  Widget build(BuildContext context) {
    String widgetImage = model.image?.path ?? "";
    String widgetTitle = model.name;
    String widgetBody = model.shortDescription;

    return Card(
      elevation: 0.8,
      margin: const EdgeInsets.only(bottom: kHalfGap),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Stack(
          children: [
            SizedBox(
              height: 118,
              child: Row(
                children: [
                  SizedBox(
                    height: 118,
                    width: 118,
                    child: ImageUrl(
                      imageUrl: widgetImage,
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
                                  widgetTitle,
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
                                    widgetBody,
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
            if(expireDate != null)...[
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(kRadius, kRadius, kRadius, kRadius) + const EdgeInsets.symmetric(horizontal: kQuarterGap),
                  decoration: BoxDecoration(
                    color: kAppColor.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(kRadius)),
                  ),
                  child: Text(
                    expireDate!,
                    style: caption.copyWith(
                      color: kAppColor,
                    ),
                  ),
                )
              )
            ]
          ],
        ),
      ),
    );
  }
}
