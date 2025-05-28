import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';


class CardAddress extends StatelessWidget {
  const CardAddress({
    super.key,
    this.model,
    required this.onTap,
    required this.lController
  });

  final CustomerShippingAddressModel? model;
  final VoidCallback onTap;
  final LanguageController lController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: kPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_sharp,
                      color: kAppColor,
                      size: 22,
                    ),
                    const SizedBox(width: kGap),
                    Text(
                      lController.getLang("Delivery to"),
                      style: subtitle1.copyWith(
                        color: kAppColor,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: kQuarterGap, left: 38),
              child: model != null && model!.isValid()
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${model?.displayAddress(lController, sep: '\n')}",
                      style: subtitle1.copyWith(
                        color: kDarkColor
                      ),
                    ),
                    Text(
                      "${lController.getLang('Telephone Number')} ${model?.telephone}",
                      style: subtitle1.copyWith(
                        color: kDarkColor
                      ),
                    ),
                  ],
                )
                : Text(
                  lController.getLang("Please select shipping address"),
                  style: subtitle1,
                ),
            ),
          ],
        ),
      ),
    );
  }
}