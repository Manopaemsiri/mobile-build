import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/customer/shopping_cart/read.dart';
import 'package:coffee2u/screens/partner/product/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFavoriteProductsScreen extends StatefulWidget {
  const MyFavoriteProductsScreen({Key? key}) : super(key: key);

  @override
  State<MyFavoriteProductsScreen> createState() =>
    _MyFavoriteProductsScreenState();
}

class _MyFavoriteProductsScreenState extends State<MyFavoriteProductsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final AppController aController = Get.find<AppController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  bool trimDigits = true;
  
  @override
  void initState() {
    _customerController.updateFavoriteProducts();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(lController.getLang("My Favorite Products")),
        ),
        body: !controller.isCustomer() || controller.frProducts.isEmpty
          ? NoDataCoffeeMug()
          : ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            // physics: const NeverScrollableScrollPhysics(),
            children: [
              CardProductGrid(
                key: const ValueKey<String>("partner-products"),
                padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, kGap),
                data: controller.frProducts,
                customerController: _customerController,
                lController: lController,
                aController: aController,
                onTap: (d) => Get.to(() => ProductScreen(
                  productId: d.id ?? '',
                )), 
                showStock: _customerController.isShowStock(),
                trimDigits: trimDigits,
                showFavorited: true,
              ),
            ],
          ),
          bottomNavigationBar: GetBuilder<CustomerController>(
            builder: (controller) {
              int count = controller.countCartProducts();
              return count > 0
                ? Padding(
                  padding: kPaddingSafeButton,
                  child: ButtonOrder(
                    title: lController.getLang("Order Now"),
                    qty: count,
                    total: controller.cart.total,
                    onPressed: () async {
                      await controller.readCart();
                      Get.to(() => const ShoppingCartScreen());
                    },
                    lController: lController,
                    trimDigits: trimDigits
                  ),
                ): const SizedBox.shrink();
            },
          ),
      );
    });
  }
}