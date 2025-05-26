import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

import '../../../../config/index.dart';

class CardCustomerSubscriptionProduct extends StatelessWidget {
  const CardCustomerSubscriptionProduct({
    Key? key,
    required this.data,
    required this.lController,
    this.trimDigits = false
  }) : super(key: key);
  final PartnerProductModel data;
  final LanguageController lController;
  final bool trimDigits;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageProduct(
              imageUrl: data.image?.path ?? '',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: kOtGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: subtitle2.copyWith(
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'x ${data.inCart} ${data.selectedUnit == null
                      ? data.unit: data.selectedUnit!.unit}',
                    style: subtitle2.copyWith(
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                ),
                ],
              ),
            ),
            const SizedBox(),
            if(data.addPriceInVAT > 0)...[
              Text(
                priceFormat(data.addPriceInVAT, lController, trimDigits: trimDigits),
                style: subtitle2.copyWith(
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.end,
              ),
            ]
          ],
        ),
        if(data.shipBySupplier == 1) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(40+kOtGap, 2, 0, 0),
            child: Text(
              "*** ${lController.getLang("text_lion_delivered_1")} ${data.preparingDays} ${lController.getLang("Days")}",
              style: subtitle2.copyWith(
                fontSize: 13,
                color: kAppColor,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}