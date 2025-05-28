import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../models/customer_subscription_model.dart';
import '../../../../utils/index.dart';

class CardCustomerSubscription extends StatelessWidget {
  const CardCustomerSubscription({
    super.key,
    required this.data,
    required this.lController,
    required this.onTap,
  });
  final CustomerSubscriptionModel data;
  final Function(String) onTap;
  final LanguageController lController;

  @override
  Widget build(BuildContext context) {
    final String name = data.subscription?.name ?? '';
    final String prefixOrderId2C2P = data.prefixOrderId2C2P;
    final DateTime? createdAt = data.createdAt;
    final String status = data.displayStatus(lController);
    final Color statusColor = data.displayStatusColor();

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kRadius),
        color: kWhiteColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(data.id ?? ''),
          child: Container(
            padding: kPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: title.fontSize!*1.4,
                      child: Icon(
                        FontAwesomeIcons.crown,
                        color: Colors.yellow[600],
                        size: title.fontSize!*0.9,
                      ),
                    ),
                    const Gap(gap: kOtGap),
                    Expanded(
                      child: Text(
                        name,
                        style: title.copyWith(
                          fontWeight: FontWeight.w500,
                          color: kDarkColor,
                        )
                      ),
                    ),
                  ],
                ),
                const Divider(),
                _row(
                  left: lController.getLang("Order Ref"), 
                  right: prefixOrderId2C2P,
                  rightColor: kAppColor,
                  overflow: true,
                ),
                const Gap(gap: 2),
                _row(
                  left: lController.getLang("Order Date"), 
                  right: dateFormat(createdAt, format: 'dd/MM/y kk:mm')
                ),
                const Gap(gap: 6),
                _row(
                  left: lController.getLang("Status"), 
                  right: status,
                  rightColor: statusColor,
                  type: 2,
                ),
              ],
            ),
            ),
        ),
      ),
    );
  }

  Widget _row({
    required String left, 
    required String right,
    Color? leftColor,
    Color? rightColor,
    int type = 1,
    bool overflow = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: subtitle1.copyWith(
            color: leftColor ?? kDarkLightColor,
            fontWeight: FontWeight.w400
          ),
        ),
        if(type == 2)...[
          BadgeDefault(
            title: right,
            color: rightColor,
            size: 15,
            textColor: data.status == 0 ? kDarkColor: Colors.white,
          ),
        ] else if(overflow) ...[
          SizedBox(
            width: Get.width - 12 * kGap,
            child: Text(
              right,
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: subtitle1.copyWith(
                color: rightColor ?? kDarkColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ] else ...[
          Text(
            right,
            style: subtitle1.copyWith(
              color: rightColor ?? kDarkColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ]
      ],
    );
  }
}