import 'dart:math';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/shopping_cart/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/screens/partner/product/read.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.initSearch = '',
    this.backTo,
  });
  final String initSearch;
  final String? backTo;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final AppController aController = Get.find<AppController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  List<PartnerProductModel> _data = [];

  FocusNode fSearch = FocusNode();
  final searchCon = TextEditingController();

  int page = 0;

  String search = "";
  String selectedEventId = "";
  String selectedEventName = "";

  bool isLoading = false;
  bool isEnded = false;
  bool onSearchSubmit = false;

  late List<PartnerProductCategoryModel> categoryList = [];
  late List<PartnerProductBrandModel> brandList = [];
  late List<PartnerEventModel> eventList = [];

  bool trimDigits = true;

  @override
  void initState() {
    if (widget.initSearch != '') {
      search = widget.initSearch;
      searchCon.text = widget.initSearch;
      onSearchSubmit = true;
      onRefresh();
    }
    getCatagory();
    getBrands();
    getEvents();
    fSearch.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    fSearch.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    setState(() {
      page = 0;
      isLoading = false;
      isEnded = false;
      _data = [];
    });
    loadData();
  }

  void getCatagory() async {
    await ApiService.processList("partner-product-categories").then((value) {
      final length = value?["result"].length;
      for (var i = 0; i < length; i++) {
        PartnerProductCategoryModel category =
          PartnerProductCategoryModel.fromJson(value?["result"][i]);
        setState(() => categoryList.add(category));
      }
    });
  }
  void getBrands() async {
    await ApiService.processList("partner-product-brands").then((value) {
      final length = value?["result"].length;
      for (var i = 0; i < length; i++) {
        PartnerProductBrandModel brand =
          PartnerProductBrandModel.fromJson(value?["result"][i]);
        setState(() => brandList.add(brand));
      }
    });
  }
  void getEvents() async {
    await ApiService.processList("partner-events").then((value) {
      final length = value?["result"].length;
      for(var i=0; i<length; i++){
        PartnerEventModel event =
          PartnerEventModel.fromJson(value?["result"][i]);
        setState(() => eventList.add(event));
      }
    });
  }

  Future<void> loadData() async {
    if (!isEnded && !isLoading) {
      try {
        page += 1;
        setState(() {
          isLoading = true;
        });

        await ApiService.processList("partner-products", input: {
          "dataFilter": {
            "keywords": search,
            "partnerShopId": _customerController.partnerShop?.id,
          },
          "paginate": {
            "page": page,
            "pp": 26,
          }
        }).then((value) {
          PaginateModel paginateModel =
              PaginateModel.fromJson(value?["paginate"]);

          var len = value?["result"].length;
          for (var i = 0; i < len; i++) {
            PartnerProductModel model =
                PartnerProductModel.fromJson(value!["result"][i]);
            _data.add(model);
          }
          setState(() {
            _data;
            if (_data.length == paginateModel.total) {
              isEnded = true;
              isLoading = false;
            } else if (value != null) {
              isLoading = false;
            }
          });
        });
      } catch (e) {}
    }
  }

  Widget loaderWidget() =>
    const ShimmerProducts();

  void onLoadMore(info) async {
    if (info.visibleFraction > 0 && !isEnded && !isLoading) {
      await loadData();
    }
  }

  void _onTabSearch(String str, {String prefix='', String eventId='', String eventName=''}) {
    setState((){
      selectedEventId = eventId;
      selectedEventName = eventName;
    });
    if(str.trim() != ""){
      setState((){
        search = prefix + str;
        searchCon.text = prefix + str;
        onSearchSubmit = true;
      });
      FocusScope.of(context).unfocus();
      onRefresh();
    }
  }

  void _onSearch(String str) {
    if (str.trim() != "") {
      setState(() {
        search = str;
        searchCon.text = str;
        onSearchSubmit = true;
      });
      FocusScope.of(context).unfocus();
      onRefresh();
    }
  }

  void _onClear() {
    setState(() {
      search = "";
      searchCon.text = "";
      onSearchSubmit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: kAppColor
          ),
          backgroundColor: kAppColor,
          iconTheme: const IconThemeData( color: kWhiteColor ),
          title: SizedBox(
            height: 40,
            child: TextFormField(
              autofocus: true,
              controller: searchCon,
              decoration: InputDecoration(
                hintText: lController.getLang("Search") + '...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: kGap),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kRadius),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: search != ""
                ? IconButton(
                  onPressed: _onClear,
                  icon: const Icon(Icons.close),
                )
                : const Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value){
                  _onSearch(value);
                },
              onChanged: (value){
                if(value == ''){
                  setState(() => onSearchSubmit = false);
                }
                setState(() => search = value);
              },
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: kGap),
          children: [
            if(onSearchSubmit) ...[
              const Gap(gap: kGap),
              Column(
                children: [
                  isEnded && _data.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.only(top: kGap),
                    child: NoDataCoffeeMug(),
                  )
                  : CardProductGrid(
                    padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, kHalfGap),
                    key: const ValueKey<String>("search-products"),
                    data: _data,
                    customerController: _customerController,
                    lController: lController,
                    aController: aController,
                    onTap: (d) => Get.to(() => ProductScreen(
                      productId: d.id ?? '',
                      eventId: selectedEventId,
                      backTo: widget.backTo,
                    )),
                    showStock: _customerController.isShowStock(),
                    trimDigits: trimDigits,
                  ),
                  if (isEnded && _data.isNotEmpty) ...[
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
                        showStock: _customerController.isShowStock(),
                        padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, kGap),
                      )
                    ),
                  ]
                ],
              ),
            ] else ...[
              Padding(
                padding: kPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(eventList.isNotEmpty) ...[
                      Text(
                        lController.getLang("Search by Events"),
                        style: headline6
                      ),
                      const Gap(gap: kHalfGap),
                      Wrap(
                        spacing: kHalfGap,
                        runSpacing: kHalfGap,
                        children: eventList.map((PartnerEventModel item) {
                          return InkWell(
                            onTap: (){
                              _onTabSearch(
                                item.name, prefix: '*',
                                eventId: item.id ?? '',
                                eventName: item.name,
                              );
                            },
                            child: BadgeSelector(
                              selected: false,
                              title: item.name,
                              size: 16,
                            ),
                          );
                        }).toList(),
                      ),
                      const Gap(gap: kGap * 1.5),
                    ],
                    if(categoryList.isNotEmpty) ...[
                      Text(
                        lController.getLang("Search by Categories"),
                        style: headline6
                      ),
                      const Gap(gap: kHalfGap),
                      Wrap(
                        spacing: kHalfGap,
                        runSpacing: kHalfGap,
                        children: categoryList.map((PartnerProductCategoryModel item) {
                          return InkWell(
                            onTap: (){
                              _onTabSearch(item.name, prefix: '#');
                            },
                            child: BadgeSelector(
                              selected: false,
                              title: item.name,
                              size: 16,
                            ),
                          );
                        }).toList(),
                      ),
                      const Gap(gap: kGap * 1.5),
                    ],
                    if(brandList.isNotEmpty) ...[
                      Text(
                        lController.getLang("Search by brands"),
                        style: headline6
                      ),
                      const Gap(gap: kHalfGap),
                      Wrap(
                        spacing: kQuarterGap,
                        runSpacing: kQuarterGap,
                        children: brandList.map((PartnerProductBrandModel item) {
                          double brandW = (Get.width - 4*kQuarterGap - 2*kGap) / 5;
                          brandW = min(brandW, 80);
                          return InkWell(
                            onTap: (){
                              _onTabSearch(item.name, prefix: '@');
                            },
                            // child: const SizedBox.shrink(),
                            child: ImageProduct(
                              imageUrl: item.icon!.path,
                              width: brandW,
                              height: brandW * 4/5,
                              fit: BoxFit.contain,
                              padding: const EdgeInsets.all(kHalfGap),
                            ),
                          );
                        }).toList(),
                      ),
                      const Gap(gap: kGap * 1.5),
                    ],
                  ],
                ), 
              ),
            ],
          ]
        ),
        bottomNavigationBar: GetBuilder<CustomerController>(
          builder: (controller) {
            int count = controller.countCartProducts();
            return !onSearchSubmit || count <= 0 
              ? const SizedBox.shrink()
              : Padding(
                padding: kPaddingSafeButton,
                child: ButtonOrder(
                  title: lController.getLang("Basket"),
                  qty: count,
                  total: controller.cart.total,
                  onPressed: () async {
                    await controller.readCart();
                    if(widget.backTo != null){
                      Get.until((route) => Get.currentRoute == '/ShoppingCartScreen');
                    }else {
                      Get.to(() => const ShoppingCartScreen());
                    }
                  },
                  lController: lController,
                  trimDigits: trimDigits
                ),
              );
          },
        ),
      ),
    );
  }
}
