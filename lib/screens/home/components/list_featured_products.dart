import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/frontend_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/product/list.dart';
import 'package:coffee2u/screens/partner/product/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListFeaturedProducts extends StatelessWidget {
  const ListFeaturedProducts({
    super.key,
    required this.lController,
    required this.customerController,
    required this.aController,
    this.showStock = false,
    this.eventId,
    this.eventName,
  });
  final LanguageController lController;
  final CustomerController customerController;
  final AppController aController;
  final bool showStock;
  final String? eventId;
  final String? eventName;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<FrontendController>(
      builder: (controller) {
        return FutureBuilder<Map<String, dynamic>?>(
          future: controller.partnerFeaturedProducts,
          builder: (buildContext, asyncSnapshot) {
            if(asyncSnapshot.connectionState == ConnectionState.done) {
              if(asyncSnapshot.hasData) {
                final featuredProducts = asyncSnapshot.data;
                List<PartnerProductModel> data = [];
                for (var i = 0; i < (featuredProducts?["result"]?.length ?? 0); i++) {
                  PartnerProductModel model
                    = PartnerProductModel.fromJson(featuredProducts?["result"][i]);
                  data.add(model);
                }

                return data.isEmpty
                ? const SizedBox.shrink()
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: kGap + kQuarterGap),
                    SectionTitle(
                      titleText: lController.getLang("Popular Products"),
                      isReadMore: true,
                      onTap: () => Get.to(() => const PartnerProductsScreen(appTitle: "Popular Products", dataFilter: { "sort": 'desc-salesCount' } )),
                      padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, 0),
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kGap),
                      child: Wrap(
                        spacing: kHalfGap,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: data.map((item) {

                          return CardProduct(
                            data: item,
                            customerController: customerController,
                            lController: lController,
                            aController: aController,
                            onTap: () => onTap(item.id ?? ''),
                            showStock: showStock,
                          );
                        }).toList(),
                      )
                    ),
                  ],
                );
              }else {
                return const SizedBox.shrink();
              }
            }else if(asyncSnapshot.connectionState == ConnectionState.waiting){
              return ShimmerHorizontalProducts(showStock: showStock);
            }
            return const SizedBox.shrink();
          }
        );
      }
    );
  }

  onTap(String productId) => 
    Get.to(() => ProductScreen(
      productId: productId,
      eventId: eventId,
      eventName: eventName,
    ));
}
