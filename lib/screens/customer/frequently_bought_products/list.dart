import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
// import 'package:coffee2u/screens/customer/address/components/address_selection.dart';
import 'package:coffee2u/screens/customer/checkout/read.dart';
import 'package:coffee2u/screens/customer/frequently_bought_products/components/product_frequently_item.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FrequentlyBoughtProductsScreen extends StatefulWidget {
  const FrequentlyBoughtProductsScreen({
    super.key
  });

  @override
  State<FrequentlyBoughtProductsScreen> createState() =>
    _FrequentlyBoughtProductsScreenState();
}

class _FrequentlyBoughtProductsScreenState extends State<FrequentlyBoughtProductsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final AppController controllerApp = Get.find<AppController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  bool isLoading = true;
  PartnerShopModel? _partnerShop;

  _initState() async {
    if(controllerCustomer.isCustomer()){
      if(controllerApp.enabledMultiPartnerShops && controllerCustomer.partnerShop != null && controllerCustomer.partnerShop?.type != 9){
        setState(() => _partnerShop = controllerCustomer.partnerShop);
      }else{
        var data1 = await ApiService.processRead('partner-shop-center');
        setState(() => _partnerShop = PartnerShopModel.fromJson(data1!['result']));
      }
      controllerCustomer.updateFrequentlyProducts(shop: _partnerShop);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(builder: (controller) {
      int dataCount = controller.countFrequentlyProducts();

      return Scaffold(
        appBar: AppBar(
          title: Text(
            lController.getLang("Frequently Bought Products")
          ),
          bottom: const AppBarDivider(),
        ),
        body: !controller.isCustomer()
          ? NoDataCoffeeMug()
          : isLoading? Loading()
            : controller.fbProducts.isEmpty? NoDataCoffeeMug()
            : ListView(
              children: [
               
                // if(controllerApp.enabledMultiPartnerShops) ...[
                //   InkWell(
                //     onTap: () {
                //       Get.to(() => PartnerShopsScreen(
                //         onPressed: (PartnerShopModel value){
                //           setState(() {
                //             _partnerShop = value;
                //           });
                //           controllerCustomer.updateFrequentlyProducts(shop: _partnerShop);
                //           Get.back();
                //         }
                //       ));
                //     },
                //     child: Container(
                //       color: kWhiteColor,
                //       padding: const EdgeInsets.fromLTRB(
                //         kGap, 0, kGap, kGap + kQuarterGap
                //       ),
                //       child: Row(
                //         children: [
                //           Container(
                //             width: 32,
                //             height: 32,
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: kAppColor.withValues(alpha: 0.1),
                //             ),
                //             child: const Center(
                //               child: Icon(
                //                 Icons.store_rounded,
                //                 color: kAppColor,
                //                 size: 22,
                //               ),
                //             ),
                //           ),
                //           const Gap(),
                //           Expanded(
                //             child: Text(
                //               _partnerShop?.name ?? '',
                //               overflow: TextOverflow.ellipsis,
                //               maxLines: 1,
                //               style: subtitle1.copyWith(
                //                 color: kAppColor,
                //                 fontWeight: FontWeight.w600
                //               ),
                //             ),
                //           ),
                //           const Icon(Icons.chevron_right),
                //         ],
                //       ),
                //     ),
                //   ),
                // ],
                const DividerThick(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.fbProducts.length,
                  itemBuilder: (c, index) {
                    PartnerProductModel item = controller.fbProducts[index];
                    return ProductFrequentlyItem(
                      model: item,
                      qty: item.inCart,
                      onChange: (int qty){
                        controller.updateFrequentlyProduct(index, qty);
                      }, 
                      lController: lController,
                      aController: controllerApp,
                      trimDigits: true,
                      showStock: controllerCustomer.isShowStock(),
                    );
                  },
                ),
                SizedBox(
                  height: dataCount < 1? 88: 0,
                ),
              ],
            ),
        bottomNavigationBar: !controller.isCustomer() || dataCount < 1
          ? const SizedBox.shrink()
          : Padding(
            padding: kPadding,
            child: ButtonOrder(
              title: lController.getLang("Order Now"),
              qty: dataCount,
              total: controller.getFrequentlyTotal(),
              onPressed: _onTapOrder,
              lController: lController,
            ),
          ),
      );
    });
  }

  void _onTapOrder() async {
    if(_partnerShop != null && _partnerShop!.isValid()){
      bool res = await controllerCustomer.checkoutFrequentlyProducts(_partnerShop);
      if(res){
        Get.to(() => const CheckOutScreen());
      }
    }
  }
}
