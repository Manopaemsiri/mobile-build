import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/checkout/components/cms_products.dart';
import 'package:coffee2u/screens/partner/product/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardCmsProducts extends StatelessWidget {
  const CardCmsProducts({
    super.key,
    required this.lController,
    required this.customerController,
    required this.aController,
    this.showStock = false,
    this.products = const [],
  });
  final List<PartnerProductModel> products;
  final LanguageController lController;
  final CustomerController customerController;
  final AppController  aController;
  final bool showStock;

  @override
  Widget build(BuildContext context) {
    // List<PartnerProductModel> _products = products.sublist(0, products.length < 10? products.length: 10);
    List<PartnerProductModel> _products = products;
    
    return _products.isEmpty
    ? const SizedBox.shrink()
    : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kGap),
          child: Text(
            lController.getLang('Recommended Products'),
            style: title.copyWith(
              fontWeight: FontWeight.w600,
              color: kWhiteColor 
            ),
          ),
        ),
        const Gap(gap: kHalfGap),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: kGap),
          child: Wrap(
            spacing: kHalfGap,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: _products.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;

              if(index == _products.length - 1 && products.length > 10 && false){
                return IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CardProduct(
                        data: product,
                        customerController: customerController,
                        lController: lController,
                        aController: aController,
                        onTap: () => _onTap(product.id ?? ''),
                        showStock: showStock
                      ),
                      const Gap(gap: kHalfGap),
                      InkWell(
                        borderRadius: BorderRadius.circular(kCardRadius),
                        onTap: _onTapProductSeeMore,
                        child: Container(
                          height: double.infinity,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(kCardRadius),
                          ),
                          padding: kPadding,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: kPadding,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: kWhiteColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: kDarkColor.withValues(alpha: 0.2),
                                      offset: Offset.zero,
                                      blurRadius: 7,
                                      spreadRadius: 0.5,
                                      blurStyle: BlurStyle.normal,
                                    )
                                  ]
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded
                                ),
                              ),
                              const Gap(gap: kHalfGap),
                              Text(
                                lController.getLang('See More'),
                                style: subtitle1.copyWith(
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }

              return CardProductSmall(
                data: product,
                customerController: customerController,
                lController: lController,
                aController: aController,
                onTap: () => _onTap(product.id ?? ''),
                showStock: showStock
              );
            }).toList(),
          )
        ),
      ],
    );
  }

  _onTap(String id) =>
    Get.to(() => ProductScreen(productId: id, backTo: '/CheckOutScreen'));
                           
  _onTapProductSeeMore() => Get.to(() => CmsProducts(
    appBarTitle: 'Recommended Products',
    products: products,
    appController: aController,
    customerController: customerController,
    lController: lController,
  ));
}