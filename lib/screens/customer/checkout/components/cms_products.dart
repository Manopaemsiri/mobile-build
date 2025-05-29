import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/product/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CmsProducts extends StatelessWidget {
  const CmsProducts({
    super.key,
    required this.lController,
    required this.appController,
    required this.customerController,
    this.appBarTitle,
    this.products = const [],
  });
  final LanguageController lController;
  final AppController appController;
  final CustomerController customerController;
  final String? appBarTitle;
  final List<PartnerProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lController.getLang(appBarTitle ?? "Our Products"),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: kGap),
        children: [
          CardProductGrid(
            data: products,
            customerController: customerController,
            lController: lController,
            aController: appController,
            onTap: (item) => _onTap(item.id!),
            showStock: customerController.isShowStock(),
            trimDigits: true,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: kGap, bottom: 2*kGap),
              child: Text(
                lController.getLang("No more data"),
                textAlign: TextAlign.center,
                style: title.copyWith(
                  fontWeight: FontWeight.w500,
                  color: kGrayColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onTap(String id) => Get.to(() => ProductScreen(productId: id));
}