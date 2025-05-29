// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

import '../../../../controller/language_controller.dart';
import '../../../../utils/formater.dart';

class CardSubscriptionOrder extends StatelessWidget {
  const CardSubscriptionOrder({
    super.key,
    required this.data,
    required this.index,
    required this.dataLength,
    required this.onTap,
    required this.lController,
  });
  final CustomerSubscriptionPlanModel data;
  final int index;
  final int dataLength;
  final Function(String) onTap;
  final LanguageController lController;

  @override
  Widget build(BuildContext context) {
    DateTime? recurringDate = data.recurringDate;
    final String recurringDateFormat = data.billingFormat();
    int status = data.status;
    DateTime? paymentAt = data.paymentAt;
    String orderId = data.order?.id ?? '';

    return InkWell(
      borderRadius: BorderRadius.circular(kRadius),
      onTap: status == 3? () => onTap(orderId): null,
      child: Container(
        padding: kPadding,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(kRadius)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: title.fontSize!*1.4,
                  child: const Icon(
                    Icons.credit_card_rounded,
                    color: kAppColor,
                  ),
                ),
                const Gap(gap: kOtGap),
                Expanded(
                  child: Text(
                    lController.getLang('text_billing_cycle').replaceAll('_VALUE_', '${index+1}'),
                    style: title.copyWith(
                      fontWeight: FontWeight.w500,
                      color: kDarkColor,
                    )
                  ),
                ),
              ],
            ),
            const Divider(),
            if(recurringDate != null)...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.subscription?.displayRecurringTypeName(lController),
                    style: subtitle1.copyWith(color: kDarkLightColor, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    dateFormat(recurringDate, format: recurringDateFormat, local: lController.languageCode),
                    style: subtitle1.copyWith(
                      color: kDarkColor,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
            ],
            
            if(status == 3)...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lController.getLang('Payment at'),
                    style: subtitle1.copyWith(color: kDarkLightColor, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    dateFormat(paymentAt, format: 'dd/MM/y hh:mm', local: lController.languageCode),
                    style: subtitle1.copyWith(
                      color: kDarkColor,
                      fontWeight: FontWeight.w400
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
                  lController.getLang("Status"),
                  style: subtitle1.copyWith(color: kDarkLightColor),
                ),
                data.displayStatus(lController),
              ],
            ),
            if(status == 3)...[
              const Gap(gap: kHalfGap),
              const Divider(height: 1),
              const Gap(),
              Container(
                alignment: Alignment.center,
                child: Text(
                  lController.getLang('More Detail'),
                  style: subtitle2.copyWith(
                    color: kAppColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}