import 'package:coffee2u/config/styles.dart';
import 'package:coffee2u/config/themes/colors.dart';
import 'package:coffee2u/config/themes/typography.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CardProductCoupon3 extends StatelessWidget {
  CardProductCoupon3({
    Key? key,
    required this.model,
    required this.onPressed,
  }) : super(key: key);

  final PartnerProductCouponModel model;
  final VoidCallback onPressed;
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    String _image = model.image?.path ?? "";
    String _title = model.name;
    String _body = model.shortDescription;

    return IgnorePointer(
      ignoring: model.availability != 99,
      child: Card(
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
                Stack(
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
                    if(model.availability != 99) ...[
                      Positioned(
                        top: 0, bottom: 0, left: 0, right: 0,
                        child: Container(
                          color: kWhiteColor.withOpacity(0.45),
                        ),
                      ),
                    ],
                    if(model.isPersonal == 1) ...[
                      Positioned(
                        top: 0, left: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(6, 2, 6, 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: kBlueColor,
                          ),
                          child: Text(
                            lController.getLang('Your Coupons'),
                            style: subtitle2.copyWith(
                              fontSize: 13.0,
                              color: kWhiteColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(kGap, kOtGap, kGap, 0),
                          color: model.availability == 99
                            ? kWhiteColor: kGrayLightColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: subtitle1.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.35
                                ),
                              ),
                              const SizedBox(height: 2),
                              SizedBox(
                                height: 36,
                                child: Text(
                                _body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: bodyText2.copyWith(
                                    color: kGrayColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4
                                  ),
                                ),
                              ),
                              const SizedBox(height: kHalfGap),
                              model.availability == 99
                                ? SizedBox(
                                  width: double.infinity,
                                  child: RichText(
                                    textAlign: TextAlign.right,
                                    text: TextSpan(
                                      text: lController.getLang("text_discount_1"),
                                      style: title.copyWith(
                                        fontFamily: 'Kanit',
                                        color: kDarkColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' ${priceFormat(
                                            model.actualDiscount + model.missingPaymentDiscount,
                                            lController
                                          )}',
                                          style: title.copyWith(
                                            fontFamily: 'Kanit',
                                            color: kAppColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : Text(
                                  '● ${model.displayAvailability(lController)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: subtitle2.copyWith(
                                    fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
