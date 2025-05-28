import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/partner_shop_filter_controller.dart';

class PartnerShopFilter extends StatelessWidget {
  const PartnerShopFilter({
    super.key,
    required this.onSubmit,
    required this.lController,
    this.categoryId = '',
    this.eventId = '',
    this.showSubCategory = true,
    this.initFilterCategories = const [],
    this.initFilterSubCategories = const [],
    this.initFilterBrands = const [],
    this.initFilterProductTags = const [],
    this.shopId,
  });

  final Function({List<Map<String, dynamic>> selectedCategories, List<String> selectedSubCategories, List<String> selectedBrands, List<String> selectedProductTags}) onSubmit;
  final LanguageController lController;
  final String categoryId;
  final String eventId;
  final bool showSubCategory;
  final List<dynamic> initFilterCategories;
  final List<String> initFilterSubCategories;
  final List<String> initFilterBrands;
  final List<String> initFilterProductTags;
  final String? shopId;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
        ),
        child: GetBuilder<PartnerShopFilterController>(
          init: PartnerShopFilterController(
            shopId: shopId,
            categoryId: categoryId,
            eventId: eventId,
            showSubCategory: showSubCategory,
            initBrands: initFilterBrands,
            initCategories: initFilterCategories,
            initSubCategories: initFilterSubCategories,
            initProductTags: initFilterProductTags
          ),
          builder: (controller) {

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    kGap, kOtGap, kGap, kHalfGap
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: controller.clearFilter,
                        child: Text(
                          lController.getLang("Clear"),
                          style: title.copyWith(
                            color: kGrayColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          onSubmit(
                            selectedCategories: controller.selectedCategories,
                            selectedSubCategories: controller.selectedSubCategories,
                            selectedBrands: controller.selectedBrands,
                            selectedProductTags: controller.selectedProductTags
                          );
                          Get.back();
                        },
                        child: Text(
                          lController.getLang("Apply"),
                          style: title.copyWith(
                            color: kAppColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.black87),
                if(controller.loading)...[
                  const Expanded(
                    child: FilterLoading(),
                  )
                ]else if(controller.categories.isEmpty 
                && controller.subCategories.isEmpty 
                && controller.brands.isEmpty 
                && controller.productTags.isEmpty)...[
                  Expanded(
                    child: NoDataCoffeeMug(),
                  ),
                ]else ...[
                  Flexible(
                    child: ListView(
                      shrinkWrap: false,
                      padding: const EdgeInsets.fromLTRB(
                        kGap, kHalfGap, kGap, kGap * 2
                      ),
                      children: [
                        if(categoryId.isEmpty && controller.categories.isNotEmpty)...[
                          Text(
                            lController.getLang("Category"),
                            style: title.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(gap: kHalfGap),
                          Wrap(
                            spacing: kHalfGap,
                            runSpacing: kHalfGap,
                            children: controller.categories.map((Map<String, dynamic> item) {
                              
                              return InkWell(
                                onTap: () => controller.onSelectCategory(item),
                                child: BadgeSelector(
                                  key: ValueKey<String>(item['id'] ?? ''),
                                  selected: controller.selectedCategories.any((d) => d['id'] == item['id']),
                                  title: item['name'],
                                  size: 16,
                                ),
                              );
                            }).toList(),
                          ),
                          const Gap(gap: kGap + kQuarterGap),
                        ]else if(controller.subCategories.isNotEmpty) ...[
                          Text(
                            lController.getLang("Sub Category"),
                            style: title.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(gap: kHalfGap),
                          Wrap(
                            spacing: kHalfGap,
                            runSpacing: kHalfGap,
                            children: controller.subCategories.map((PartnerProductSubCategoryModel item) {
                              return InkWell(
                                onTap: () => controller.onSelectSubCategory(item),
                                child: BadgeSelector(
                                  key: ValueKey<String>(item.id ?? ''),
                                  selected: controller.selectedSubCategories.contains(item.id),
                                  title: item.name,
                                  size: 16,
                                ),
                              );
                            }).toList(),
                          ),
                          const Gap(gap: kGap + kQuarterGap),
                        ],
                        
                        if(controller.brands.isNotEmpty) ...[
                          Text(
                            lController.getLang("Brands"),
                            style: title.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(gap: kHalfGap),
                          Wrap(
                            spacing: kQuarterGap,
                            runSpacing: kQuarterGap,
                            children: controller.brands.map((PartnerProductBrandModel item) {
                              double brandW = (Get.width - 4*kQuarterGap - 2*kGap) / 5;
                              brandW = min(brandW, 80);

                              return InkWell(
                                onTap: () => controller.onSelectBrand(item),
                                child: ImageProduct(
                                  key: ValueKey<String>(item.id ?? ''),
                                  imageUrl: item.icon!.path,
                                  selected: controller.selectedBrands.contains(item.id),
                                  width: brandW,
                                  height: brandW * 4/5,
                                  fit: BoxFit.contain,
                                  padding: const EdgeInsets.all(kHalfGap),
                                ),
                              );
                            }).toList(),
                          ),
                          const Gap(gap: kGap + kQuarterGap),
                        ],

                        if(controller.productTags.isNotEmpty) ...[
                          Text(
                            lController.getLang("Product Tags"),
                            style: title.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(gap: kHalfGap),
                          Wrap(
                            spacing: kHalfGap,
                            runSpacing: kHalfGap,
                            children: controller.productTags.map((String item) {
                              var index = controller.productTags.indexOf(item);
                              return InkWell(
                                onTap: () => controller.onSelectProductTags(item),
                                child: BadgeSelector(
                                  key: ValueKey<String>('${index}_$item'),
                                  selected: controller.selectedProductTags.contains(item),
                                  title: item,
                                  size: 16,
                                ),
                              );
                            }).toList(),
                          ),
                          const Gap(gap: kGap + kQuarterGap),
                        ],
                      ],
                    ),
                  ),
                ]
              ],
            );
          }
        ),
      ),
    );
  }
}