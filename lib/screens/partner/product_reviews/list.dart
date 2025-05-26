import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/product_reviews/controller/product_reviews_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../widgets/index.dart';

class ProductReviewsScreen extends StatelessWidget {
  ProductReviewsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final String productId;

  final LanguageController lController = Get.find<LanguageController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lController.getLang('Customer Reviews'),
        ),
        bottom: const AppBarDivider(),
      ),
      body: GetBuilder<ProductReviewsController>(
        init: ProductReviewsController(productId),
        builder: (controller) {

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              controller.isEnded && controller.data.isEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: kGap),
                child: NoDataCoffeeMug(),
              )
              : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) {
                  final PartnerProductRatingModel item = controller.data[i];

                  return CardReview(
                    data: item,
                    padding: const EdgeInsets.symmetric(vertical: kGap, horizontal: kGap),
                    lController: lController,
                  );
                }, 
                separatorBuilder: (_, i) => const Divider(height: 0.8, thickness: 0.8),
                itemCount: controller.data.length
              ),
              if(controller.isEnded && controller.data.isNotEmpty) ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: kHalfGap, bottom: kGap),
                    child: Text(
                      lController.getLang("No more data"),
                      textAlign: TextAlign.center,
                      style: title.copyWith(
                        fontWeight: FontWeight.w500,
                        color: kGrayColor
                      ),
                    ),
                  ),
                )
              ],
              if(!controller.isEnded) ...[
                VisibilityDetector(
                  key: const Key('loader-widget'),
                  onVisibilityChanged: controller.onLoadMore,
                  child: const ShimmerRatingList(itemCount: 10)
                ),
              ]
            ],
          );
        },
      )
    );
  }
}