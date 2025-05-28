import 'dart:math';

import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/shopping_cart/read.dart';
import 'package:coffee2u/screens/partner/product/read.dart';
import 'package:coffee2u/screens/partner/shop/components/partner_shop_filter.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../shop/components/partner_shop_sorting.dart';

class PartnerProductCategoriesScreen extends StatefulWidget {
  const PartnerProductCategoriesScreen({
    super.key,
    this.initCategoryId,
    this.dataFilter,
  });

  final String? initCategoryId;
  final Map<String, dynamic>? dataFilter;

  @override
  State<PartnerProductCategoriesScreen> createState() => _PartnerProductCategoriesScreenState();
}

class _PartnerProductCategoriesScreenState extends State<PartnerProductCategoriesScreen> with TickerProviderStateMixin {
  final LanguageController _lController = Get.find<LanguageController>();
  final AppController aController = Get.find<AppController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  bool isPageLoading = true;

  // Main Tab
  List<TabBarModel> tabList = [];
  late TabController _tabController = TabController(length: 0, vsync: this);
  int _selectedIndex = -1;
  String? _selectedCateId;

  final ScrollController _gridScrollController = ScrollController();

  // Sub-Tab: For event categories
  final List<TabController> _eventTabController = [];
  final List<int> _selectedEventIndex = [];
  final List<String> _selectedEventCateId = [];

  // Sub-Tab: For product categories
  final List<TabController> _subCatTabController = [];
  final List<int> _selectedSubCatIndex = [];
  final List<String> _selectedSubCateID = [];
  bool showSubCategory = false;

  PartnerShopModel? _partnerShop;
  List<PartnerProductModel> _data = [];

  final TextEditingController _cKeywords = TextEditingController();
  String filterKeywords = '';
  Map<String, dynamic> filterSort = { 'name': "desc-sales-count", 'value': 'desc-salesCount' };

  List<Map<String, dynamic>> filterCategories = [];
  // [ { _id, categories: [] } ]
  List<String> filterSubCategories = [];
  List<String> filterBrands = [];
  List<String> filterProductTags = [];

  int page = 0;
  bool isLoading = false;
  bool isEnded = false;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  void dispose() {
    _cKeywords.dispose();
    _tabController.dispose();
    for (var e in _eventTabController) {
      e.dispose();
    }
    for (var e in _subCatTabController) {
      e.dispose();
    }
    // _tabController = null;
    _gridScrollController.dispose();
    super.dispose();
  }

  _initState() async {
    // Read Partner Shop
    try {
      if(_customerController.partnerShop != null && _customerController.partnerShop?.type != 9){
        final res = await ApiService.processRead("partner-shop", input: { "_id": _customerController.partnerShop?.id });
        _partnerShop = PartnerShopModel.fromJson(res?["result"]);
      }else {
        final res = await ApiService.processRead("partner-shop-center");
        _partnerShop = PartnerShopModel.fromJson(res?["result"]);
      }
    } catch (e) {
      if(kDebugMode) print('$e');
    }

    tabList = [];
    List<TabBarModel> temp = [
      TabBarModel(
        titleText: _lController.getLang("All Products"),
        body: const SizedBox.shrink(),
        categoryId: ''
      )
    ];
    _eventTabController.insert(0, TabController(length: 1, vsync: this));
    _eventTabController[0].addListener(_handleTabSelectionEvent);

    _selectedEventIndex.add(0);
    _selectedEventCateId.add('');

    // START: Events
    List<TabBarModel> res = await listEvents();
    temp.addAll(res);
    final eventLength = temp.length;
    // END: Events

    // START: Product Categories
    List<TabBarModel> res2 = await listProductCategories(eventLength);
    temp.addAll(res2);
    // END: Product Categories

    // START: Product Sub-Categories
    await listSubTabs(temp);
    // END: Product Sub-Categories
    if(_selectedIndex == -1) {
      _selectedCateId = "";
      _selectedIndex = 0;
    }

    if (mounted) {
      setState(() {
        tabList = temp;
        _tabController = TabController(length: temp.length, vsync: this, initialIndex: _selectedIndex);
        _tabController.addListener(_handleTabSelection);
      });
    }
    await loadData();
  
    if(mounted) setState(() => isPageLoading = false);
  }

  Future<List<TabBarModel>> listEvents() async {
    List<TabBarModel> temp = [];
    try {
      final res = await ApiService.processList('partner-events');
      final length = res?["result"].length ?? 0;

      for(var i = 1; i <= length; i++) {
        final eventId = res?["result"][i-1]["_id"];
        final eventName = res?["result"][i-1]["name"] ?? '';
        if(eventId == widget.initCategoryId) {
          _selectedCateId = eventId;
          _selectedIndex = i;
        }
        List<PartnerProductCategoryModel> eventCates = [
          PartnerProductCategoryModel.fromJson({
            "id": "",
            "name": _lController.getLang("All Products"),
            "icon": { "path": "assets/icons/category-all.png" },
          })
        ];
        var res2 = await ApiService.processList('partner-product-categories', input: {
          "dataFilter": { "eventId": eventId }
        });
        if(res2 != null && res2["result"] != null){
          final length2 = res2["result"].length ?? 0;
          for(var j = 0; j < length2; j++){
            eventCates.add(PartnerProductCategoryModel.fromJson(res2["result"][j]));
          }
        }
        temp.add(
          TabBarModel(
            isEvent: true,
            titleText: eventName,
            eventId: eventId,
            eventCategories: eventCates,
            body: const SizedBox.shrink(),
          ),
        );
        _eventTabController.add(TabController(length: eventCates.length, vsync: this));
        _eventTabController[i].addListener(_handleTabSelectionEvent);

        _selectedEventIndex.add(0);
        _selectedEventCateId.add(eventCates.first.id ?? '');
      }
      return temp;
    } catch (e) {
      if(kDebugMode) print('$e');
      return [];
    }
  }
  Future<List<TabBarModel>> listProductCategories(int value) async {
    // parameters : value is eventLength
    List<TabBarModel> temp = [];
    try {
      final res = await ApiService.processList("partner-product-categories");
      final length = res?["result"].length;
      for (var i = 0; i < length; i++) {
        PartnerProductCategoryModel category = PartnerProductCategoryModel.fromJson(res?["result"][i]);
        if(category.id == widget.initCategoryId){
          _selectedCateId = category.id!;
          _selectedIndex = i+value;
        }
        temp.add(
          TabBarModel(
            titleText: category.name,
            categoryId: category.id!,
            body: const SizedBox.shrink(),
          ),
        );
      }
      return temp;
    } catch (e) {
      if(kDebugMode) print('$e');
      return [];
      
    }
  }
  Future<void> listSubTabs(List<TabBarModel> values) async {
    // Sub-tabs for products
    final res1 = await ApiService.processRead("setting", input: { "name": "APP_PARTNER_SHOP_SUB_TABS" });
    List<PartnerProductSubCategoryModel> subCate2 = [];
    if((res1?["result"] == "1" || res1?["result"] == 1)){
      if(mounted) setState(() => showSubCategory = true);
      final res2 = await ApiService.processList("partner-product-sub-categories");
      final length2 = res2?["result"].length ?? 0;
      for (var i = 0; i < length2; i++) {
        PartnerProductSubCategoryModel model = PartnerProductSubCategoryModel.fromJson(res2?["result"][i]);
        subCate2.add(model);
      }
    }
    for(var i = 0; i < values.length; i++) {
      String catId = values[i].categoryId ?? '';
      values[i].subCategories = [
        PartnerProductSubCategoryModel.fromJson({
          "id": "",
          "name": _lController.getLang("All Products"),
          "icon": { "path": "assets/icons/category-all.png" },
        }),
        ...subCate2.where((d) => d.category?.id == catId).toList(),
      ];
      _subCatTabController.add(TabController(length: values[i].subCategories?.length ?? 0, vsync: this));
      _subCatTabController[i].addListener(_handleTabSelectionSubCat);
      _selectedSubCatIndex.add(0);
      if((values[i].subCategories?.length ?? 0) > 0) _selectedSubCateID.add(values[i].subCategories?[0].id ?? '');
    }
  }
  
  void _handleTabSelection() async {
    if(mounted && !_tabController.indexIsChanging && !isLoading){
      setState(() {
        _resetScroll();
        _clearFilterAndSort();
        _selectedIndex = _tabController.index;
        _selectedCateId = tabList[_selectedIndex].isEvent 
          ? tabList[_selectedIndex].eventId! 
          : tabList[_selectedIndex].categoryId!;

        _clearPaginate();
      });
      await loadData();
    }
  }
  void _handleTabSelectionEvent() async {
    if(mounted && !_eventTabController[_selectedIndex].indexIsChanging && !isLoading){
      var temp = tabList[_selectedIndex];
      setState((){
        _resetScroll();
        _clearFilterAndSort();
        _selectedEventIndex[_selectedIndex] = _eventTabController[_selectedIndex].index;
        _selectedEventCateId[_selectedIndex] = _selectedEventIndex[_selectedIndex] == 0
          ? '': temp.eventCategories?[_selectedEventIndex[_selectedIndex]].id ?? '';

        _clearPaginate();
      });
      await loadData();
    }
  }
  void _handleTabSelectionSubCat() async {
    if(mounted && !_subCatTabController[_selectedIndex].indexIsChanging && !isLoading){
      var temp = tabList[_selectedIndex];
      setState((){
        _resetScroll();

        // filterKeywords = '';
        // filterSort = '';
        // filterCategories = [];
        // filterSubCategories = [];
        // filterBrands = [];
        // filterProductTags = [];
        _selectedSubCatIndex[_selectedIndex] = _subCatTabController[_selectedIndex].index;
        _selectedSubCateID[_selectedIndex] = _selectedSubCatIndex[_selectedIndex] == 0
          ? '': temp.subCategories?[_selectedSubCatIndex[_selectedIndex]].id ?? '';

        _clearPaginate();
      });
      await loadData();
    }
  }

  void _resetScroll() {
    setState(() {
      _gridScrollController.jumpTo(0);
    });
  }

  void onLoadMore(info) async {
    if (info.visibleFraction > 0 && !isEnded && !isLoading) await loadData();
  }

  void _onTap(String id, {String eventId='', String eventName=''}) 
    => Get.to(() => ProductScreen(
      productId: id,
      eventId: eventId,
      eventName: eventName,
    ));

  Future<void> loadData() async {
    if (mounted && !isEnded && !isLoading) {
      try {
        page += 1;
        if(mounted) setState(() => isLoading = true);

        Map<String, dynamic> dataFilter = {
          "partnerShopId": _partnerShop?.id,
          "categoryId": _selectedCateId
        };

        if(filterKeywords != ''){
          dataFilter['keywords'] = filterKeywords;
        }
        if(filterSort.isNotEmpty && filterSort?['value'] != null){
          dataFilter['sort'] = filterSort['value'];
        }

        if(filterCategories.isNotEmpty){
          List<String> _filterCategories = filterCategories.expand((item) {
            if (item.containsKey('categories') && item['categories']?.isNotEmpty == true) {
              return item['categories'];
            } else {
              return [item['id']];
            }
          }).map((e) => e.toString()).toList();
          dataFilter['categoryIds'] = _filterCategories;
        }
        if(filterSubCategories.isNotEmpty){
          dataFilter['subCategoryIds'] = filterSubCategories;
        }
        if(filterBrands.isNotEmpty){
          dataFilter['brandIds'] = filterBrands;
        }
        if(filterProductTags.isNotEmpty){
          dataFilter['productTags'] = filterProductTags;
        }

        if(tabList[_selectedIndex].isEvent){
          dataFilter['eventId'] = tabList[_selectedIndex].eventId;
          dataFilter['categoryId'] = _selectedEventCateId[_selectedIndex];
        }
        if((tabList[_selectedIndex].subCategories?.length ?? 0) > 0){
          dataFilter['subCategoryId'] = _selectedSubCateID[_selectedIndex];
        }
        final res = await ApiService.processList("partner-products", input: {
          "dataFilter": dataFilter,
          "paginate": {
            "page": page,
            "pp": 26,
          }
        });
        List<PartnerProductModel> temp = _data;
        PaginateModel paginateModel = PaginateModel.fromJson(res?["paginate"]);

        var len = res?["result"].length;
        for (var i = 0; i < len; i++) {
          PartnerProductModel model = PartnerProductModel.fromJson(res!["result"][i]);
          temp.add(model);
        }

        if(mounted){
          // if(tabList[_selectedIndex].categoryId == _selectedCateId){
          _data = temp;
          if (temp.length == paginateModel.total) {
            isEnded = true;
            isLoading = false;
          } else if (res != null) {
            isLoading = false;
          }
          // }
          setState(() {});
        }
      } catch (e) {
        if(kDebugMode) print('$e');
      }
    }
  }

  
  
  @override
  Widget build(BuildContext context) {
    double eventCard = min(84, Get.width/5);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Theme(
        data: Theme.of(context).copyWith(
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: kWhiteColor
            )
          )
        ),
        child: Scaffold(
          backgroundColor: kWhiteSmokeColor,
          appBar: AppBar(
            leadingWidth: 24+kGap*2,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: kAppColor
            ),
            backgroundColor: kAppColor,
            title: IgnorePointer(
              ignoring: isPageLoading? true: false,
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  controller: _cKeywords,
                  decoration: InputDecoration(
                    hintText: _lController.getLang("Search") + '...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: kGap),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kRadius),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: _cKeywords.value.text.isNotEmpty
                      ? IconButton(
                        onPressed: () {
                          setState(() {
                            filterKeywords = '';
                            _cKeywords.clear();
                          });
                        },
                        icon: const Icon(Icons.close),
                      )
                      : const Icon(Icons.search),
                  ),
                  onChanged: (value){
                    if(mounted) setState(() {});
                  },
                  textInputAction: TextInputAction.search,
                  onEditingComplete: (){
                    FocusScope.of(context).unfocus();
                    if(mounted){
                      setState(() {
                        filterKeywords = _cKeywords.value.text;
                        _clearPaginate();
                      });
                    }
                    
                    loadData();
                  },
                ),
              ),
            ),
          ),
          body: isPageLoading
          ? Center(
            child: Loading(),
          )
          : CustomScrollView(
            controller: _gridScrollController,
            slivers: [
              if(tabList.isNotEmpty) ...[
                MultiSliver(
                  pushPinnedChildren: true,
                  children: [
                    SliverPinnedHeader(
                      child: Container(
                        color: kWhiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                            //   child: TextFormField(
                            //     // controller: _cKeywords,
                            //     decoration: InputDecoration(
                            //       hintText: _lController.getLang("Search")+'...',
                            //       border: const OutlineInputBorder(),
                            //       contentPadding: const EdgeInsets.all(kOtGap),
                            //     ),
                            //     textInputAction: TextInputAction.search,
                            //     onFieldSubmitted: (String temp){
                            //       FocusScope.of(context).unfocus();
                            //       // widget.onSubmit(
                            //       //   _cKeywords.text,
                            //       //   sortKey,
                            //       //   selectedSubCategories,
                            //       //   selectedBrands,
                            //       // );
                            //     },
                            //   ),
                            // ),
                            TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              indicatorWeight: 4,
                              indicatorColor: kAppColor,
                              labelColor: kAppColor,
                              unselectedLabelColor: kGrayColor,
                              tabs: TabBarModel.getTabBar(tabList),
                            ),
                            const Divider(height: 1, thickness: 2),
                          ],
                        ),
                      ),
                    ),

                    if(_eventTabController.isNotEmpty && tabList[_selectedIndex].isEvent)...[
                      if(_eventTabController[_selectedIndex].length > 2 && showSubCategory)...[
                        SliverPinnedHeader(
                          child: Container(
                            color: const Color(0xFFEEEEEE),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TabBar(
                                  controller: _eventTabController[_selectedIndex],
                                  isScrollable: true,
                                  indicatorColor: kAppColor,
                                  padding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.zero,
                                  indicator: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  indicatorWeight: 0,
                                  onTap: (i) {
                                    if(isLoading && mounted) setState(() => _eventTabController[_selectedIndex].index = _selectedEventIndex[_selectedIndex]);
                                  },
                                  tabs: tabList[_selectedIndex].eventCategories!.asMap().entries.map((entry){
                                    int idx = entry.key;
                                    PartnerProductCategoryModel d = entry.value;

                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeInCubic,
                                      height: eventCard,
                                      width: eventCard,
                                      padding: const EdgeInsets.fromLTRB(kHalfGap, kQuarterGap, kHalfGap, kQuarterGap),
                                      decoration: BoxDecoration(
                                        color: _selectedEventIndex[_selectedIndex] == idx
                                          ? kAppColor: null,
                                        border: Border(
                                          right: BorderSide(
                                            color: kWhiteColor,
                                            width: idx == 4 && idx == tabList[_selectedIndex].eventCategories!.length - 1? 0: 2,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: (eventCard)/2.6,
                                            width: (eventCard)/2.6,
                                            child: idx == 0 && d.icon?.path != null && d.icon?.path != "" 
                                              ? Image.asset(
                                                d.icon?.path ?? '',
                                                color: _selectedEventIndex[_selectedIndex] == idx
                                                  ? kWhiteColor: kGrayColor,
                                              )
                                              : d.icon?.path != null && d.icon?.path != "" 
                                                ? ColorFiltered(
                                                  colorFilter:  ColorFilter.mode(
                                                    _selectedEventIndex[_selectedIndex] == idx
                                                      ? Colors.transparent: kGrayColor,
                                                    BlendMode.srcATop,
                                                  ),
                                                  child: ImageUrl(
                                                    imageUrl: d.icon?.path ?? '',
                                                    showMugIcon: true,
                                                  ),
                                                )
                                                : Image.asset(
                                                  "assets/icons/coffee_mug.png",
                                                  color: null,
                                                ),
                                          ),
                                          const Gap(gap: kHalfGap),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.topCenter,
                                            child: SizedBox(
                                              height: 35,
                                              width: eventCard,
                                              child: Text(
                                                d.name,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: bodyText2.copyWith(
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w500,
                                                  color: _selectedEventIndex[_selectedIndex] == idx
                                                    ? kWhiteColor: kGrayColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ]
                    else if(_subCatTabController.isNotEmpty && _subCatTabController[_selectedIndex].length > 0)...[
                      if(_subCatTabController[_selectedIndex].length > 2 && showSubCategory)...[
                        SliverPinnedHeader(
                          child: Container(
                            color: const Color(0xFFEEEEEE),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TabBar(
                                  controller: _subCatTabController[_selectedIndex],
                                  isScrollable: true,
                                  indicatorColor: kAppColor,
                                  padding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.zero,
                                  indicator: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  indicatorWeight: 0,
                                  onTap: (i) {
                                    if(isLoading && mounted) setState(() => _subCatTabController[_selectedIndex].index = _selectedSubCatIndex[_selectedIndex]);
                                  },
                                  tabs: tabList[_selectedIndex].subCategories!.asMap().entries.map((entry){
                                    int idx = entry.key;
                                    PartnerProductSubCategoryModel d = entry.value;

                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeInCubic,
                                      height: eventCard,
                                      width: eventCard,
                                      padding: const EdgeInsets.fromLTRB(kHalfGap, kQuarterGap, kHalfGap, kQuarterGap),
                                      decoration: BoxDecoration(
                                        color: _selectedSubCatIndex[_selectedIndex] == idx
                                          ? kAppColor: null,
                                        border: Border(
                                          right: BorderSide(
                                            color: kWhiteColor,
                                            width: idx == 4 && idx == tabList[_selectedIndex].subCategories!.length - 1? 0: 2,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: (eventCard)/2.6,
                                            width: (eventCard)/2.6,
                                            child: idx == 0 && d.icon?.path != null && d.icon?.path != "" 
                                              ? Image.asset(
                                                d.icon?.path ?? '',
                                                color: _selectedSubCatIndex[_selectedIndex] == idx
                                                  ? kWhiteColor: kGrayColor,
                                              )
                                              : d.icon?.path != null && d.icon?.path != "" 
                                                ? ColorFiltered(
                                                  colorFilter:  ColorFilter.mode(
                                                    _selectedSubCatIndex[_selectedIndex] == idx
                                                      ? Colors.transparent: kGrayColor,
                                                    BlendMode.srcATop,
                                                  ),
                                                  child: ImageUrl(
                                                    imageUrl: d.icon?.path ?? '',
                                                    showMugIcon: true,
                                                    
                                                  ),
                                                )
                                                : Image.asset(
                                                  "assets/icons/coffee_mug.png",
                                                  color: null
                                                ),
                                          ),
                                          const Gap(gap: kHalfGap),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.topCenter,
                                            child: SizedBox(
                                              height: 35,
                                              width: eventCard,
                                              child: Text(
                                                d.name,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: bodyText2.copyWith(
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w500,
                                                  color: _selectedSubCatIndex[_selectedIndex] == idx
                                                    ? kWhiteColor: kGrayColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ],
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 1
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: kGap) + const EdgeInsets.only(top: kGap),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     mainAxisSize: MainAxisSize.max,
                            //     children: [
                            //       RichText(
                            //         text: TextSpan(
                            //           text: '${_lController.getLang('sorting')} : ',
                            //           style: subtitle1.copyWith(
                            //             color: kDarkColor,
                            //             fontFamily: 'Kanit',
                            //             fontWeight: FontWeight.w400
                            //           ),
                            //           children: [
                            //             TextSpan(
                            //               text: 'สินค้าขายดี',
                            //               style: subtitle1.copyWith(
                            //                 color: kDarkColor,
                            //                 fontFamily: 'Kanit',
                            //                 fontWeight: FontWeight.w400
                            //               ),
                            //             )
                            //           ]
                            //         )
                            //       ),
                            //       InkWell(
                            //         borderRadius: BorderRadius.circular(kRadius),
                            //         onTap: () => searchProducts(),
                            //         child: RichText(
                            //           text: TextSpan(
                            //             style: subtitle1.copyWith(
                            //               color: kDarkColor,
                            //               fontFamily: 'Kanit',
                            //               fontWeight: FontWeight.w400
                            //             ),
                            //             children: [
                            //               const WidgetSpan(
                            //                 alignment: PlaceholderAlignment.middle,
                            //                 child: Icon(
                            //                   Icons.filter_alt_outlined,
                            //                   size: 20,
                            //                 )
                            //               ),
                            //               TextSpan(
                            //                 text: _lController.getLang('ตัวเลือก'),
                            //                 style: subtitle1.copyWith(
                            //                   color: kDarkColor,
                            //                   fontFamily: 'Kanit',
                            //                   fontWeight: FontWeight.w400
                            //                 ),
                            //               )
                            //             ]
                            //           )
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // 2 
                            AbsorbPointer(
                              absorbing: _data.isEmpty && isLoading? true: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: kGap) + const EdgeInsets.only(top: kGap),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: InkWell(
                                        onTap: onPressedSorting,
                                        child: RichText(
                                          text: TextSpan(
                                            text: '${_lController.getLang('sorting')} : ',
                                            style: subtitle1.copyWith(
                                              color: kDarkColor,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400
                                            ),
                                            children: [
                                              TextSpan(
                                                text: filterSort?['name'] != null
                                                ? _lController.getLang(filterSort['name'] ?? '')
                                                : '-',
                                                style: subtitle1.copyWith(
                                                  color: kDarkColor,
                                                  fontFamily: 'Kanit',
                                                  fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              const WidgetSpan(
                                                alignment: PlaceholderAlignment.middle,
                                                child: Icon(
                                                  Icons.expand_more_rounded,
                                                  size: 20,
                                                )
                                              )
                                            ]
                                          )
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        maxHeight: 24,
                                        maxWidth: 24
                                      ),
                                      onPressed: () => searchProducts(),
                                      icon: const Icon(Icons.filter_alt_outlined)
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if(isEnded && _data.isEmpty)...[
                              Padding(
                                padding: const EdgeInsets.only(top: kGap),
                                child: NoDataCoffeeMug()
                              )
                            ]else ...[
                              CardProductGrid(
                                key: ValueKey<String>(tabList[_selectedIndex].titleText),
                                data: _data,
                                customerController: _customerController,
                                lController: _lController,
                                aController: aController,
                                onTap: (item) => _onTap(
                                  item.id!,
                                  eventId: tabList[_selectedIndex].isEvent 
                                    ? tabList[_selectedIndex].eventId ?? '': '',
                                  eventName: tabList[_selectedIndex].isEvent 
                                    ? tabList[_selectedIndex].titleText: '',
                                ),
                                showStock: _customerController.isShowStock(),
                                trimDigits: true,
                              ),
                            ]
                          ],
                        ),
                        if (isEnded && _data.isNotEmpty) ...[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: kGap, bottom: 2*kGap),
                              child: Text(
                                _lController.getLang("No more data"),
                                textAlign: TextAlign.center,
                                style: title.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: kGrayColor,
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
                            )
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          bottomNavigationBar: isPageLoading
          ? const SizedBox.shrink()
          : GetBuilder<CustomerController>(
            builder: (controller) {
              int count = controller.countCartProducts();
              return IgnorePointer(
                ignoring: count > 0 ? false : true,
                child: Visibility(
                  visible: count > 0 ? true : false,
                  child: Padding(
                    padding: kPaddingSafeButton,
                    child: ButtonOrder(
                      title: _lController.getLang("Basket"),
                      qty: count,
                      total: controller.cart.total,
                      onPressed: () async {
                        await controller.readCart();
                        Get.to(() => const ShoppingCartScreen());
                      },
                      lController: _lController
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  onPressedSorting() async {

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kButtonRadius),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.8,
          minChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {

            return PartnerShopSorting(
              initFilterSort: filterSort,
              lController: _lController,
              onSubmit: (value) {
                if(mounted){
                  setState(() {
                    filterSort = value;
                    _clearPaginate();
                  });
                }
                
                loadData();
              },
            );
          }
        );
      },
    );
  }

  searchProducts() async {
    
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kButtonRadius),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.8,
          minChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {

            return PartnerShopFilter(
              shopId: _partnerShop?.id,
              categoryId: tabList[_selectedIndex].isEvent
                ? '': tabList[_selectedIndex].categoryId!,
              eventId: tabList[_selectedIndex].isEvent 
                ? tabList[_selectedIndex].eventId!: '',
              showSubCategory: !showSubCategory,
              initFilterCategories: filterCategories,
              initFilterSubCategories: filterSubCategories,
              initFilterBrands: filterBrands,
              initFilterProductTags: filterProductTags,
              lController: _lController,
              onSubmit: ({
                selectedCategories = const [],
                selectedSubCategories = const [],
                selectedBrands = const [],
                selectedProductTags = const []
              }){
                if(mounted){
                  setState(() {
                    filterCategories = selectedCategories;
                    filterSubCategories = selectedSubCategories;
                    filterBrands = selectedBrands;
                    filterProductTags = selectedProductTags;
                    _clearPaginate();
                  });
                }
                
                loadData();
              },
            );
          }
        );
      },
    );
  }

  void _clearFilterAndSort() {
    // filterKeywords = '';
    filterSort = { 'name': "desc-sales-count", 'value': 'desc-salesCount' };
    filterCategories = [];
    filterSubCategories = [];
    filterBrands = [];
    filterProductTags = [];
  }
  void _clearPaginate() {
    page = 0;
    isLoading = false;
    isEnded = false;
    _data = [];
  }
}