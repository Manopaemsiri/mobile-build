import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';


class OrderShippingHistory extends StatelessWidget {
  const OrderShippingHistory({
    Key? key,
    required this.model,
    required this.lController,
  }) : super(key: key);

  final CustomerOrderModel? model;
  final LanguageController lController;


  @override
  Widget build(BuildContext context) {
    return !model!.isValid()
      ? const SizedBox.shrink()
      : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, kOtGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping,
                          color: kAppColor,
                          size: 22,
                        ),
                        const SizedBox(width: kOtGap),
                        Text(
                          model!.shippingFrontend!.displayName,
                          style: subtitle1.copyWith(
                            color: kAppColor,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: kQuarterGap, left: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model!.displayShippingStatusText(),
                        style: subtitle1.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        model!.displayDeliveryDetail(lController),
                        style: subtitle1.copyWith(
                          color: kAppColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.75, thickness: 0.75),

          model!.shippingHistory.isEmpty
            ? const SizedBox.shrink()
            : Container(
              padding: const EdgeInsets.fromLTRB(34+kGap, 0, kGap, kGap+kQuarterGap),
              child: Column(
                children: model!.shippingHistory.map((ShippingStatusMappingModel d){
                  return Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(gap: kGap),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                child: Container(
                                  width: kHalfGap,
                                  height: kHalfGap,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kAppColor,
                                  ),
                                ),
                              ),
                              const Gap(gap: kHalfGap),
                              Text(
                                d.shippingStatus?.name ?? '',
                                style: subtitle1.copyWith(
                                  color: kDarkColor,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20 + kHalfGap),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                d.shippingSubStatus != null && d.shippingSubStatus?.name != ''
                                  ? Text(
                                    d.shippingSubStatus?.name ?? '',
                                    style: subtitle1.copyWith(
                                      color: kDarkLightColor,
                                      fontWeight: FontWeight.w400,
                                      height: 1.25
                                    ),
                                  ): const SizedBox.shrink(),
                                Text(
                                  '${lController.getLang("Time")} ${dateFormat(d.createdAt ?? DateTime.now(), format: 'dd/MM/y kk:mm')}',
                                  style: subtitle1.copyWith(
                                    color: kGrayColor,
                                    fontWeight: FontWeight.w400,
                                    height: 1.25
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList()
              ),
            ),
        
        ],
      );
  }
}