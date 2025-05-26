import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/partner_shop_sort_controller.dart';

class PartnerShopSorting extends StatelessWidget {
  const PartnerShopSorting({
    Key? key,
    required this.onSubmit,
    required this.lController,
    this.initFilterSort,
  }): super(key: key);

  final Map<String, dynamic>? initFilterSort;
  final LanguageController lController;
  final Function(Map<String, dynamic>) onSubmit;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: const BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
      ),
      child: GetBuilder<PartnerShopSortontroller>(
        init: PartnerShopSortontroller(initSortKey: initFilterSort),
        builder: (controller) {

          return controller.sortings.isNotEmpty
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(
                  kGap, kOtGap, kGap, kHalfGap
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: (){
                      onSubmit(controller.sortKey);
                      Get.back();
                    },
                    child: Text(
                      lController.getLang('Apply'),
                      style: title.copyWith(
                        color: kAppColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.black87),
              
              Flexible(
                child: ListView(
                  shrinkWrap: false,
                  padding: const EdgeInsets.fromLTRB(
                    kGap, kHalfGap, kGap, kGap * 2
                  ),
                  children: [
                    if(controller.sortings.isNotEmpty) ...[
                      Text(
                        lController.getLang('Sorting'),
                        style: title.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(gap: kHalfGap),
                      Wrap(
                        spacing: kHalfGap,
                        runSpacing: kHalfGap,
                        children: controller.sortings.map((Map<String, dynamic> item) {
                          return InkWell(
                            onTap: () => controller.onSelectSorting(item),
                            child: BadgeSelector(
                              selected: controller.sortKey['value'] == item['value'],
                              title: lController.getLang(item['name']),
                              size: 16
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          )
          : Center(child: NoData());
        }
      ),
    );
  }
}