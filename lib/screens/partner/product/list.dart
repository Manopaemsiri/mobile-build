import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/shopping_cart/read.dart';
// import 'package:coffee2u/screens/partner/shop/components/product_item.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/screens/partner/product/read.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PartnerProductsScreen extends StatefulWidget {
  const PartnerProductsScreen({
    super.key,
    this.appTitle,
    this.dataFilter,
  });
  
  final String? appTitle;
  final Map<String, dynamic>? dataFilter;

  @override
  State<PartnerProductsScreen> createState() => _PartnerProductsScreenState();
}

class _PartnerProductsScreenState extends State<PartnerProductsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final AppController aController = Get.find<AppController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  List<PartnerProductModel> dataModel = [];

  PartnerShopModel? _partnerShop;

  int page = 0;
  bool isLoading = false;
  bool isEnded = false;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    try {
      if(controllerCustomer.partnerShop != null && controllerCustomer.partnerShop?.type != 9){
        final res = await ApiService.processRead("partner-shop", input: { "_id": controllerCustomer.partnerShop?.id });
        _partnerShop = PartnerShopModel.fromJson(res?["result"]);
      }else {
        final res = await ApiService.processRead("partner-shop-center");
        _partnerShop = PartnerShopModel.fromJson(res?["result"]);
      }
    } catch (e) {
      if(kDebugMode) print('$e');
    }
    loadData();
  }

  Future<void> onRefresh() async {
    if(mounted){
      setState(() {
        page = 0;
        isLoading = false;
        isEnded = false;
        dataModel = [];
      });
      loadData();
    }
  }

  Future<void> loadData() async {
    if (!isEnded && !isLoading) {
      try {
        page += 1;
        if(mounted) setState(() => isLoading = true);
        
        Map<String, dynamic> dataFilterInput = widget.dataFilter ?? {};
        dataFilterInput = Map.from(dataFilterInput);
        dataFilterInput["partnerShopId"] = _partnerShop?.id;
        
        final res = await ApiService.processList("partner-products", input: {
          "dataFilter": dataFilterInput,
          "paginate": {
            "page": page,
            "pp": 26,
          }
        });
        PaginateModel paginateModel =
            PaginateModel.fromJson(res?["paginate"]);

        var len = res?["result"].length;
        for (var i = 0; i < len; i++) {
          PartnerProductModel model =
              PartnerProductModel.fromJson(res!["result"][i]);
          dataModel.add(model);
        }
        if(mounted){
          setState(() {
            dataModel;
            if (dataModel.length == paginateModel.total) {
              isEnded = true;
              isLoading = false;
            } else if (res != null) {
              isLoading = false;
            }
          });
        }
      } catch (e) {
        if(kDebugMode) print('$e');
      }
    }
  }

  Widget loaderWidget() =>
    const ShimmerProducts();

  void onLoadMore(info) async {
    if (info.visibleFraction > 0 && !isEnded && !isLoading) {
      await loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lController.getLang(widget.appTitle ?? "Our Products"),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: kGap),
        children: [
          const Gap(gap: kGap),
          Column(
            children: [
              isEnded && dataModel.isEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: kGap),
                child: NoDataCoffeeMug(),
              )
              : CardProductGrid(
                key: const ValueKey<String>("partner-products"),
                padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, kHalfGap),
                data: dataModel,
                customerController: controllerCustomer,
                lController: lController,
                aController: aController,
                onTap: (d) => onTap(d.id!),
                showStock: controllerCustomer.isShowStock(),
                trimDigits: true,
              ),
              if (isEnded && dataModel.isNotEmpty) ...[
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
              if (!isEnded) ...[
                VisibilityDetector(
                  key: const Key('loader-widget'),
                  onVisibilityChanged: onLoadMore,
                  child: ProductGridLoader(
                    showStock: controllerCustomer.isShowStock(),
                    padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, kGap),
                  )
                ),
              ]
            ],
          ),
        ]
      ),
      bottomNavigationBar: GetBuilder<CustomerController>(
        builder: (controller) {
          int count = controller.countCartProducts();
          return IgnorePointer(
            ignoring: count > 0 ? false : true,
            child: Visibility(
              visible: count > 0 ? true : false,
              child: Padding(
                padding: kPaddingSafeButton,
                child: ButtonOrder(
                  title: lController.getLang("Basket"),
                  qty: count,
                  total: controller.cart.total,
                  onPressed: () async {
                    await controller.readCart();
                    Get.to(() => const ShoppingCartScreen());
                  },
                  lController: lController,
                  trimDigits: true
                ),
              ),
            )
          );
        },
      ),
    );
  }

  onTap(String? productId) =>
    Get.to(() => ProductScreen(productId: productId ?? ''));
}
