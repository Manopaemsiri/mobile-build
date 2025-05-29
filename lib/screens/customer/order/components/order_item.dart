import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.model,
    required this.onTap,
    required this.lController,
    this.trimDigits = false,
  });

  final CustomerOrderModel model;
  final VoidCallback onTap;
  final LanguageController lController;
  final bool trimDigits;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: kWhiteColor,
        margin: const EdgeInsets.only(top: kHalfGap),
        child: Column(
          children: [
            const Divider(height: 1),
            Padding(
              padding: kPadding,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(
                                  Icons.store_rounded,
                                  color: kAppColor,
                                  size: 22,
                                ),
                              ),
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: SizedBox(width: kHalfGap)
                              ),
                              TextSpan(
                                text: model.shop?.name ?? '',
                                style: subtitle1.copyWith(
                                  color: kAppColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Kanit'
                                ),
                              ),
                              if(model.subscription != null)...[
                                const WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: SizedBox(width: kHalfGap)
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: kQuarterGap/2, horizontal: kQuarterGap),
                                    decoration: BoxDecoration(
                                      color: kYellowColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(kRadius)
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            alignment: PlaceholderAlignment.middle,
                                            child: Icon(
                                              FontAwesomeIcons.crown,
                                              color: kYellowColor,
                                              size: subtitle2.fontSize!*0.8,
                                            ),
                                          ),
                                          const WidgetSpan(
                                            alignment: PlaceholderAlignment.middle,
                                            child: SizedBox(width: kQuarterGap)
                                          ),
                                          TextSpan(
                                            text: 'Subscription',
                                            style: subtitle2.copyWith(
                                              color: kYellowColor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Kanit'
                                            ),
                                          ),
                                        ]
                                      ),
                                    )
                                  )
                                )
                              ]
                            ]
                          )
                        )
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  const SizedBox(height: kHalfGap),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lController.getLang("Order ID"),
                        style: subtitle1.copyWith(color: kDarkLightColor),
                      ),
                      Text(
                        model.orderId,
                        style: subtitle2.copyWith(
                          color: kAppColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'CenturyGothic'
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lController.getLang("Order At"),
                        style: subtitle1.copyWith(color: kDarkLightColor),
                      ),
                      Text(
                        dateFormat(model.createdAt?? DateTime.now(), format: 'dd/MM/y kk:mm'),
                        style: subtitle1.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lController.getLang("Grand Total"),
                        style: subtitle1.copyWith(color: kDarkLightColor),
                      ),
                      Text(
                        priceFormat(model.grandTotal, lController, trimDigits: trimDigits),
                        style: title.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  if(model.isValidDownPayment()) ...[
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lController.getLang("Payment Before Installation"),
                          style: subtitle1.copyWith(
                            color: kAppColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          model.displayMissingPayment(lController, trimDigits: trimDigits),
                          style: title.copyWith(
                            color: kAppColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lController.getLang("Shipping Status"),
                        style: subtitle1.copyWith(color: kDarkLightColor),
                      ),
                      model.displayShippingStatus(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
