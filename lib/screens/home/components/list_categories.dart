import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/frontend_controller.dart';
import 'package:coffee2u/screens/partner/product_categories/list.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/category_controller.dart';

class ListCategories extends StatelessWidget {
  const ListCategories({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final double cardWidth = min((Get.width-(kHalfGap*2))/4, 103.5);
    final double iconSize = cardWidth-(kHalfGap*4);
    final double cardHeight = iconSize+(0)
      + kQuarterGap
      + ((caption.fontSize!*1.44)*2);

    return GetBuilder<FrontendController>(
      builder: (fController) {
        if(!fController.productCategoriesReady){
          return ShimmerProductCategory(
            height: (cardHeight*2)+(kQuarterGap/2), 
            width: cardWidth,
            childAspectRatio: cardHeight/cardWidth, 
            iconSize: iconSize
          );
        }
        return LayoutBuilder(
          builder: (context, boxConstraints) {
            bool singleRow = false;
            int n = boxConstraints.maxWidth~/cardWidth;
            if(fController.productCategories.length <= n) {
              singleRow = true;
            }

            return GetBuilder<CategoryController>(
              init: CategoryController(),
              builder: (categoryController) {
                return Visibility(
                  visible: fController.productCategories.isNotEmpty,
                  child: Column(
                    children: [
                      const Gap(),
                      SizedBox(
                        height: cardHeight*(singleRow? 1: 2) + kQuarterGap/2,
                        child: Center(
                          child: GridView.builder(
                          shrinkWrap: true,
                          controller: categoryController.controller,
                          scrollDirection: Axis.horizontal,
                          padding:  const EdgeInsets.symmetric(horizontal: kHalfGap),
                          physics: const BouncingScrollPhysics(),
                          clipBehavior: Clip.none,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: singleRow? 1: 2,
                            crossAxisSpacing: kQuarterGap/2,
                            mainAxisSpacing: 0,
                            childAspectRatio: cardHeight/cardWidth
                          ),
                          itemCount: fController.productCategories.length,
                          itemBuilder: (context, index) {
                            final item = fController.productCategories[index];
                            final name = item.id == null? lController.getLang(item.name): item.name;
                            final path = item.icon?.path ?? '';

                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => Get.to(() => PartnerProductCategoriesScreen(initCategoryId: item.id)),
                              child: Container(
                                width: cardWidth,
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: kHalfGap),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: iconSize,
                                        height: iconSize,
                                        clipBehavior: Clip.hardEdge,
                                        decoration:  BoxDecoration(
                                          color: path.contains('assets/images/')? kAppColor: kGrayLightColor,
                                          borderRadius: BorderRadius.circular(kRadius)
                                        ),
                                        child: path.contains('assets/images/') 
                                        ? Padding(
                                          padding: const EdgeInsets.all(kHalfGap),
                                          child: Image.asset(
                                            path.contains('assets/images/')? path: defaultPath,
                                            fit: BoxFit.cover,
                                            color: kWhiteColor,
                                          ),
                                        )
                                        : path.isEmpty
                                        ? Image.asset(
                                          defaultPath,
                                          fit: BoxFit.cover,
                                        )
                                        : ImageUrl(
                                          imageUrl: path,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const Gap(gap: kQuarterGap),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$name\n\n',
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: caption.copyWith(
                                          color: kDarkColor,
                                          fontWeight: FontWeight.w400,
                                          height: 1.25
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Visibility(
                        visible: categoryController.controller?.hasClients == true
                          ? (categoryController.controller?.position.maxScrollExtent ?? 0) > 0
                          : false,
                        // visible: true,
                        child: Column(
                          children: [
                            const Gap(gap: kQuarterGap),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 6,
                                width: categoryController.width + kGap*1.5,
                                clipBehavior: Clip.hardEdge,
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(kCardRadius),
                                  color: const Color(0xFFF5CDCB)
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    AnimatedPositioned(
                                      duration: const Duration(milliseconds: 50),
                                      left: categoryController.move,
                                      child: Container(
                                        height: 6,
                                        width: kGap*1.5,
                                        decoration:  BoxDecoration(
                                          color: kAppColor,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],  
                        )
                      )
                    ],
                  ),
                );
              }
            );
          }
        );
      }
    );
  }
}
