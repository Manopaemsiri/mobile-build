// import 'dart:math';

// import 'package:coffee2u/apis/api_service.dart';
// import 'package:coffee2u/config/index.dart';
// import 'package:coffee2u/controller/app_controller.dart';
// import 'package:coffee2u/controller/customer_controller.dart';
// import 'package:coffee2u/controller/language_controller.dart';
// import 'package:coffee2u/models/index.dart';
// import 'package:coffee2u/screens/customer/shopping_cart/read.dart';
// import 'package:coffee2u/screens/partner/product/read.dart';
// import 'package:coffee2u/screens/partner/shop/components/partner_shop_filter.dart';
// import 'package:coffee2u/screens/partner/shop/components/product_item.dart';
// import 'package:coffee2u/widgets/index.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sliver_tools/sliver_tools.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// class PartnerShopScreen extends StatefulWidget {
//   const PartnerShopScreen({
//     super.key,
//     this.shopId,
//   });
//   final String? shopId;

//   @override
//   State<PartnerShopScreen> createState() => _PartnerShopScreenState();
// }

// class _PartnerShopScreenState extends State<PartnerShopScreen> with TickerProviderStateMixin {
//   late final shopId = widget.shopId;

//   final LanguageController lController = Get.find<LanguageController>();
//   final AppController aController = Get.find<AppController>();

//   bool isPageLoading = true;
//   final String io = "";

//   List<TabBarModel> tabList = [];
//   late TabController _tabController = TabController(length: 0, vsync: this);
//   int _selectedIndex = 0;
//   String _selectedCateID = '';

//   List<TabController> subCatTabController = [];
//   List<int> selectedSubCatIndex = [];
//   List<String> selectedSubCateID = [];
//   bool showSubCategory = false;

//   final List<TabController> _eventTabController = [];
//   final List<int> _selectedEventIndex = [];
//   final List<String> _selectedEventCateID = [];

//   late PartnerShopModel model = PartnerShopModel();

//   int page = 0;
//   bool isLoading = false;
//   bool isEnded = false;

//   List<PartnerProductModel> _data = [];

//   String filterKeywords = '';
//   String filterSort = '';
//   List<String> filterSubCategories = [];
//   List<String> filterBrands = [];

//   bool enabledBrandSelection = false;
//   double brandW = min((Get.width - 4*kQuarterGap - 2*kGap) / 5, 80);

//   _initState() async {
//     Map<String, dynamic> input = {};
//     if(shopId != null) {
//       input['_id'] = shopId;
//     }
//     await ApiService.processRead("partner-shop", input: input ).then((value) {
//       if(mounted){
//         setState(() {
//           model = PartnerShopModel.fromJson(value?["result"]);
//         });
//       }
//     });

//     tabList = [];
//     List<TabBarModel> temp = [];

//     final res1 = await ApiService.processList('partner-events');
//     final len1 = res1?["result"].length ?? 0;
//     for(var i=0; i<len1; i++){
//       List<PartnerProductCategoryModel> cates = [
//         PartnerProductCategoryModel.fromJson({
//           "id": "",
//           "name": lController.getLang("All Products"),
//           "icon": { "path": "assets/icons/category-all.png" },
//         })
//       ];
//       var res3 = await ApiService.processList('partner-product-categories', input: {
//         "dataFilter": { "eventId": res1?["result"][i]["_id"] }
//       });
//       if(res3 != null && res3["result"] != null){
//         final len3 = res3["result"].length ?? 0;
//         for(var j=0; j<len3; j++){
//           cates.add(PartnerProductCategoryModel.fromJson(res3["result"][j]));
//         }
//       }
//       temp.add(
//         TabBarModel(
//           isEvent: true,
//           titleText: res1?["result"][i]["name"] ?? '',
//           eventId: res1?["result"][i]["_id"],
//           eventCategories: cates,
//           body: const SizedBox.shrink(),
//         ),
//       );
//       setState(() {
//         _eventTabController.add(TabController(length: cates.length, vsync: this));
//         _eventTabController[i].addListener(_handleTabSelectionEvent);
//         _selectedEventIndex.add(0);
//         _selectedEventCateID.add(cates.first.id ?? '');
//       });
//     }
    
//     final res2 = await ApiService.processList("partner-product-categories");
//     final len2 = res2?["result"].length ?? 0;
//     for(var i=0; i<len2; i++){
//       PartnerProductCategoryModel category =
//         PartnerProductCategoryModel.fromJson(res2?["result"][i]);
//       temp.add(
//         TabBarModel(
//           titleText: category.name,
//           categoryId: category.id!,
//           body: const SizedBox.shrink(),
//         ),
//       );
//     }

//     final res3 = await ApiService.processRead("setting", input: { "name": "APP_PARTNER_SHOP_SUB_TABS" });
//     List<PartnerProductSubCategoryModel> subCate2 = [];
//     if((res3?["result"] == "1" || res3?["result"] == 1)){
//       if(mounted) setState(() => showSubCategory = true); 
//       final res4 = await ApiService.processList("partner-product-sub-categories");
//       final len4 = res4?["result"].length ?? 0;
//       for (var i = 0; i < len4; i++) {
//         PartnerProductSubCategoryModel model = PartnerProductSubCategoryModel.fromJson(res4?["result"][i]);
//         subCate2.add(model);
//       }
//     }
//     for(var i=0; i<temp.length; i++){
//       String catId = temp[i].categoryId ?? '';
//       temp[i].subCategories = [
//         PartnerProductSubCategoryModel.fromJson({
//           "id": "",
//           "name": lController.getLang("All Products"),
//           "icon": { "path": "assets/icons/category-all.png" },
//         }),
//         ...subCate2.where((d) => d.category?.id == catId).toList(),
//       ];
//       setState(() {
//         subCatTabController.add(TabController(length: temp[i].subCategories?.length ?? 0, vsync: this));
//         subCatTabController[i].addListener(_handleTabSelectionSubCat);
//         selectedSubCatIndex.add(0);
//         if((temp[i].subCategories?.length ?? 0) > 0) selectedSubCateID.add(temp[i].subCategories?[0].id ?? '');
//       });
//     }
    
//     final res4 = await ApiService.processRead("setting", input: { "name": "APP_PARTNER_SHOP_SELECT_BRANDS" });
//     if((res4?["result"] == "1" || res4?["result"] == 1)){
//       setState(() => enabledBrandSelection = true);
//     }

//     if(mounted){
//       setState(() {
//         tabList = temp;
//         _selectedCateID = temp.isNotEmpty? temp[0].categoryId ?? '': '';
//         _tabController = TabController(length: temp.length, vsync: this);
//         _tabController.addListener(_handleTabSelection);
//       });
//     }
//     loadData();
  
//     setState(() => isPageLoading = false);
//   }

//   @override
//   void initState() {
//     _initState();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _handleTabSelection() async {
//     if(mounted && !_tabController.indexIsChanging && !isLoading){
//       int _index = _tabController.index;
//       _showBrandSelection(_index);
//       setState((){
//         filterKeywords = '';
//         filterSort = '';
//         filterSubCategories = [];
//         filterBrands = [];
//         _selectedIndex = _index;
//         _selectedCateID = tabList[_index].isEvent 
//           ? tabList[_index].eventId! 
//           : tabList[_index].categoryId!;

//         page = 0;
//         isLoading = false;
//         isEnded = false;
//         _data = [];
//       });
//       await loadData();
//     }
//   }
//   void _handleTabSelectionEvent() async {
//     if(mounted && !_eventTabController[_selectedIndex].indexIsChanging && !isLoading){
//       var temp = tabList[_selectedIndex];
//       setState((){
//         filterKeywords = '';
//         filterSort = '';
//         filterSubCategories = [];
//         filterBrands = [];
//         _selectedEventIndex[_selectedIndex] = _eventTabController[_selectedIndex].index;
//         _selectedEventCateID[_selectedIndex] = _selectedEventIndex[_selectedIndex] == 0
//           ? '': temp.eventCategories?[_selectedEventIndex[_selectedIndex]].id ?? '';

//         page = 0;
//         isLoading = false;
//         isEnded = false;
//         _data = [];
//       });
//       await loadData();
//     }
//   }
//   void _handleTabSelectionSubCat() async {
//     if(mounted && !subCatTabController[_selectedIndex].indexIsChanging && !isLoading){
//       var temp = tabList[_selectedIndex];
//       setState((){
//         // filterKeywords = '';
//         // filterSort = '';
//         // filterSubCategories = [];
//         // filterBrands = [];
//         selectedSubCatIndex[_selectedIndex] = subCatTabController[_selectedIndex].index;
//         selectedSubCateID[_selectedIndex] = selectedSubCatIndex[_selectedIndex] == 0
//           ? '': temp.subCategories?[selectedSubCatIndex[_selectedIndex]].id ?? '';

//         page = 0;
//         isLoading = false;
//         isEnded = false;
//         _data = [];
//       });
//       await loadData();
//     }
//   }

//   void _showBrandSelection(int index) async {
//     if(enabledBrandSelection){
//       var res = await ApiService.processList("partner-product-brands", input: {
//         "dataFilter": {
//           "categoryId": tabList[index].isEvent? '': tabList[index].categoryId!,
//           "eventId": tabList[index].isEvent? tabList[index].eventId!: '',
//         }
//       });
//       int len = res?["result"].length ?? 0;
//       if(len > 1){
//         List<PartnerProductBrandModel> _brands = [];
//         for(var i=0; i<len; i++){
//           PartnerProductBrandModel _b = 
//             PartnerProductBrandModel.fromJson(res?["result"][i]);
//           _brands.add(_b);
//         }
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               backgroundColor: Get.theme.cardColor,
//               titlePadding: EdgeInsets.zero,
//               title: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(
//                       kOtGap, kHalfGap, kOtGap, kHalfGap,
//                     ),
//                     child: Text(
//                       lController.getLang('Choose Product Brands'),
//                       textAlign: TextAlign.center,
//                       style: title.copyWith(
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   const Divider(height: 0.8, thickness: 0.8),
//                 ],
//               ),
//               contentPadding: EdgeInsets.zero,
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(kRadius))
//               ),
//               content: Container(
//                 width: min(Get.width*0.7, 300),
//                 constraints: BoxConstraints(
//                   maxHeight: min(Get.height*0.5, 350),
//                 ),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       GestureDetector(
//                         onTap: () => Get.back(),
//                         child: Row(
//                           children: [
//                             const SizedBox(width: kHalfGap),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: kHalfGap,
//                               ),
//                               child: Container(
//                                 padding: kHalfPadding,
//                                 decoration: BoxDecoration(
//                                   color: kAppColor,
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: Image.asset(
//                                   "assets/images/logo-app-white.png",
//                                   width: brandW - kGap,
//                                   height: brandW*4/5 - 2*kGap,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: kOtGap),
//                             Expanded(
//                               child: Text(
//                                 lController.getLang('All Brands'),
//                                 style: subtitle1.copyWith(
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: kGap),
//                           ],
//                         ),
//                       ),
//                       const Divider(height: 0.8, thickness: 0.8),
//                       ListView.separated(
//                         shrinkWrap: true,
//                         physics: const BouncingScrollPhysics(),                                              
//                         itemCount: _brands.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final PartnerProductBrandModel brand = _brands[index];
//                           return GestureDetector(
//                             onTap: () async {
//                               if(!isLoading){
//                                 if(brand.id != null && brand.id!.isNotEmpty){
//                                   setState((){
//                                     filterBrands = [ brand.id ?? '' ];
//                                     page = 0;
//                                     isLoading = false;
//                                     isEnded = false;
//                                     _data = [];
//                                   });
//                                   await loadData();
//                                 }
//                                 Get.back();
//                               }
//                             },
//                             child: Row(
//                               children: [
//                                 const SizedBox(width: kHalfGap),
//                                 ImageProduct(
//                                   imageUrl: brand.icon!.path,
//                                   width: brandW,
//                                   height: brandW*4/5,
//                                   fit: BoxFit.contain,
//                                   padding: kHalfPadding,
//                                   decoration: const BoxDecoration(
//                                     color: kWhiteColor,
//                                   ),
//                                 ),
//                                 const SizedBox(width: kOtGap),
//                                 Expanded(
//                                   child: Text(
//                                     brand.name,
//                                     style: subtitle1.copyWith(
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: kGap),
//                               ],
//                             ),
//                           );
//                         }, 
//                         separatorBuilder: (BuildContext context, int index){
//                           return const Divider(height: 0.8, thickness: 0.8);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actionsPadding: EdgeInsets.zero,
//               actions: [
//                 const Divider(height: 0.8, thickness: 0.8),
//                 Padding(
//                   padding: kOtPadding,
//                   child: Center(
//                     child: Text(
//                       lController.getLang('text_shop_3'),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.center,
//                       style: subtitle2.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: kDarkGrayColor,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//         );
//       }
//     }
//   }

//   void onLoadMore(info) async {
//     if (info.visibleFraction > 0 && !isEnded && !isLoading) {
//       await loadData();
//     }
//   }

//   void _onTap(String id, {String eventId='', String eventName=''}) {
//     Get.to(() => ProductScreen(
//       productId: id,
//       shopModel: model,
//       eventId: eventId,
//       eventName: eventName,
//     ));
//   }

//   Future<void> loadData() async {
//     if(mounted && !isEnded && !isLoading){
//       try {
//         page += 1;
//         setState(() => isLoading = true);

//         Map<String, dynamic> dataFilter = {
//           "categoryId": _selectedCateID,
//         };
//         if(shopId != null){
//           dataFilter['partnerShopId'] = shopId;
//         }

//         if(filterKeywords != ''){
//           dataFilter['keywords'] = filterKeywords;
//         }
//         if(filterSort != ''){
//           dataFilter['sort'] = filterSort;
//         }

//         if(filterSubCategories.isNotEmpty){
//           dataFilter['subCategoryIds'] = filterSubCategories;
//         }
//         if(filterBrands.isNotEmpty){
//           dataFilter['brandIds'] = filterBrands;
//         }

//         if(tabList[_selectedIndex].isEvent){
//           dataFilter['eventId'] = tabList[_selectedIndex].eventId;
//           dataFilter['categoryId'] = _selectedEventCateID[_selectedIndex];
//         }
//         if((tabList[_selectedIndex].subCategories?.length ?? 0) > 0){
//           dataFilter['subCategoryId'] = selectedSubCateID[_selectedIndex];
//         }

//         await ApiService.processList("partner-products", input: {
//           "dataFilter": dataFilter,
//           "paginate": {
//             "page": page,
//             "pp": 26,
//           }
//         }).then((value) async {
//           List<PartnerProductModel> temp = _data;
//           PaginateModel? paginateModel = value?["paginate"] is Map<String, dynamic>? PaginateModel.fromJson(value!["paginate"]): null;

//           var len = value?["result"].length;
//           for(var i = 0; i < len; i++){
//             PartnerProductModel model = PartnerProductModel.fromJson(value!["result"][i]);
//             temp.add(model);
//           }

//           if(mounted){
//             setState((){
//               _data = temp;
//             });
//             if(temp.length == paginateModel?.total){
//               setState(() {
//                 isEnded = true;
//                 isLoading = false;
//               });
//             }else if(value != null){
//               setState(() {
//                 isLoading = false;
//               });
//             }
//           }
//         });
//       } catch (e) {
//         if(kDebugMode) printError(info: '$e');
//       }
//     }
//   }

//   Widget loaderWidget() {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: 7,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (BuildContext context, int index) {
//         return Container(
//           color: kWhiteColor,
//           child: Column(
//             children: [
//               Padding(
//                 padding: kPadding,
//                 child: Row(
//                   children: const [
//                     SizedBox(
//                       width: 88,
//                       height: 88,
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                         ),
//                       )
//                     ),
//                     Expanded(
//                       child: Text(''),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1),
//             ],
//           ),
//         );
//       },
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     double eventCard = min(84, Get.width/5);

//     if(isPageLoading){
//       return Scaffold(
//         appBar: AppBar(),
//         body: Center(
//           child: Loading(),
//         ),
//       );
//     }else{
//       String _name = model.name ?? '';
//       bool _isOpen = model.isOpen();
//       List<FileModel> _gallery = [];

//       if(model.image != null){
//         _gallery.add(model.image!);
//       }
//       if(model.gallery != null){
//         _gallery.addAll(model.gallery!);
//       }

//       return Scaffold(
//         backgroundColor: kWhiteColor,
//         appBar: AppBar(
//           title: Text(
//             _name,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           actions: [
//             InkWell(
//               onTap: () {
//                 showModalBottomSheet(
//                   backgroundColor: Colors.transparent,
//                   isScrollControlled: true,
//                   context: context,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(kButtonRadius),
//                   ),
//                   builder: (context) {
//                     return DraggableScrollableSheet(
//                       initialChildSize: 0.8,
//                       maxChildSize: 0.8,
//                       minChildSize: 0.8,
//                       expand: false,
//                       builder: (context, scrollController) {
//                         return PartnerShopFilter(
//                           categoryId: tabList[_selectedIndex].isEvent
//                             ? '': tabList[_selectedIndex].categoryId!,
//                           eventId: tabList[_selectedIndex].isEvent 
//                             ? tabList[_selectedIndex].eventId!: '',
//                           showSubCategory: !showSubCategory,
//                           initFilterKeywords: filterKeywords,
//                           initFilterSort: filterSort,
//                           initFilterCategory: filterSubCategories,
//                           initFilterBrands: filterBrands,
//                           onSubmit: (
//                             String keywordsText,
//                             String searchText,
//                             List<String> filterSubCategoryList,
//                             List<String> filterBrandList
//                           ) {
//                             setState(() {
//                               filterKeywords = keywordsText;
//                               filterSort = searchText;
//                               filterSubCategories = filterSubCategoryList;
//                               filterBrands = filterBrandList;
//                               page = 0;
//                               isLoading = false;
//                               isEnded = false;
//                               _data = [];
//                             });
//                             loadData();
//                           },
//                         );
//                       }
//                     );
//                   },
//                 );
//               },
//               child: const Padding(
//                 padding: kPadding,
//                 child: Icon(Icons.tune),
//               ),
//             ),
//             // InkWell(
//             //   onTap: () => Get.to(() => SearchScreen(initShop: model)),
//             //   child: const Padding(
//             //     padding: EdgeInsets.fromLTRB(kQuarterGap, kGap, kGap, kGap),
//             //     child: Icon(Icons.search),
//             //   ),
//             // ),
//           ],
//         ),
//         body: CustomScrollView(
//           slivers: [
//             if(model.id != null) ...[
//               SliverToBoxAdapter(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(kGap, kQuarterGap, kGap, 0),
//                       child: Row(
//                         children: [
//                           model.displayIsOpen(subtitle1, lController),
//                           const SizedBox(width: kHalfGap),
//                           if(_isOpen) ...[
//                             Text(
//                               model.todayOpenRange(),
//                               style: subtitle1,
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(kOtGap, kHalfGap, kOtGap, kHalfGap),
//                       child: Carousel(
//                         images: _gallery,
//                         aspectRatio: 16 / 8,
//                         viewportFraction: 1,
//                         margin: kQuarterGap,
//                         isPopImage: true,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//             if(tabList.isNotEmpty) ...[
//               MultiSliver(
//                 pushPinnedChildren: true,
//                 children: [
//                   SliverPinnedHeader(
//                     child: Container(
//                       color: kWhiteColor,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TabBar(
//                             controller: _tabController,
//                             isScrollable: true,
//                             indicatorWeight: 4,
//                             indicatorColor: kAppColor,
//                             labelColor: kAppColor,
//                             unselectedLabelColor: kGrayColor,
//                             onTap: (int i){
//                               if(isLoading){
//                                 setState(() => _tabController.index = _selectedIndex);
//                               }else if(_selectedIndex == i){
//                                 _showBrandSelection(i);
//                               }
//                             },
//                             tabs: TabBarModel.getTabBar(tabList),
//                           ),
//                           const Divider(height: 0, thickness: 2),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if(_eventTabController.isNotEmpty && tabList[_selectedIndex].isEvent)...[
//                     if(_eventTabController[_selectedIndex].length > 2 && showSubCategory)...[
//                       SliverPinnedHeader(
//                         child: Container(
//                           color: const Color(0xFFEEEEEE),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               TabBar(
//                                 controller: _eventTabController[_selectedIndex],
//                                 isScrollable: true,
//                                 indicatorColor: kAppColor,
//                                 padding: EdgeInsets.zero,
//                                 labelPadding: EdgeInsets.zero,
//                                 indicator: const BoxDecoration(
//                                   color: Colors.transparent,
//                                 ),
//                                 indicatorWeight: 0,
//                                 onTap: (i) {
//                                   if(isLoading) setState(() => _eventTabController[_selectedIndex].index = _selectedEventIndex[_selectedIndex]);
//                                 },
//                                 tabs: tabList[_selectedIndex].eventCategories!.asMap().entries.map((entry){
//                                   int idx = entry.key;
//                                   PartnerProductCategoryModel d = entry.value;

//                                   return AnimatedContainer(
//                                     duration: const Duration(milliseconds: 250),
//                                     curve: Curves.easeInCubic,
//                                     height: eventCard,
//                                     width: eventCard,
//                                     padding: const EdgeInsets.fromLTRB(kHalfGap, kQuarterGap, kHalfGap, kQuarterGap),
//                                     decoration: BoxDecoration(
//                                       color: _selectedEventIndex[_selectedIndex] == idx
//                                         ? kAppColor: null,
//                                       border: Border(
//                                         right: BorderSide(
//                                           color: kWhiteColor,
//                                           width: idx == 4 && idx == tabList[_selectedIndex].eventCategories!.length - 1? 0: 2,
//                                         ),
//                                       ),
//                                     ),
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         SizedBox(
//                                           height: (eventCard)/2.6,
//                                           width: (eventCard)/2.6,
//                                           child: idx == 0 && d.icon?.path != null && d.icon?.path != "" 
//                                             ? Image.asset(
//                                               d.icon?.path ?? '',
//                                               color: _selectedEventIndex[_selectedIndex] == idx
//                                                 ? kWhiteColor: kGrayColor,
//                                             )
//                                             : d.icon?.path != null && d.icon?.path != "" 
//                                               ? ColorFiltered(
//                                                 colorFilter:  ColorFilter.mode(
//                                                   _selectedEventIndex[_selectedIndex] == idx
//                                                    ? Colors.transparent: kGrayColor,
//                                                   BlendMode.srcATop,
//                                                 ),
//                                                 child: ImageUrl(
//                                                   imageUrl: d.icon?.path ?? '',
//                                                   showMugIcon: true,
//                                                 ),
//                                               )
//                                               : Image.asset(
//                                                 "assets/icons/coffee_mug.png",
//                                                 color: null,
//                                               ),
//                                         ),
//                                         const Gap(gap: kHalfGap),
//                                         FittedBox(
//                                           fit: BoxFit.scaleDown,
//                                           alignment: Alignment.topCenter,
//                                           child: SizedBox(
//                                             height: 35,
//                                             width: eventCard,
//                                             child: Text(
//                                               d.name,
//                                               maxLines: 2,
//                                               textAlign: TextAlign.center,
//                                               style: bodyText2.copyWith(
//                                                 height: 1.2,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: _selectedEventIndex[_selectedIndex] == idx
//                                                   ? kWhiteColor: kGrayColor,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ]
//                   ]
//                   else if(subCatTabController.isNotEmpty && subCatTabController[_selectedIndex].length > 0)...[
//                     if(subCatTabController[_selectedIndex].length > 2 && showSubCategory)...[
//                       SliverPinnedHeader(
//                         child: Container(
//                           color: const Color(0xFFEEEEEE),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               TabBar(
//                                 controller: subCatTabController[_selectedIndex],
//                                 isScrollable: true,
//                                 indicatorColor: kAppColor,
//                                 padding: EdgeInsets.zero,
//                                 labelPadding: EdgeInsets.zero,
//                                 indicator: const BoxDecoration(
//                                   color: Colors.transparent,
//                                 ),
//                                 indicatorWeight: 0,
//                                 onTap: (i) {
//                                   if(isLoading) setState(() => subCatTabController[_selectedIndex].index = selectedSubCatIndex[_selectedIndex]);
//                                 },
//                                 tabs: tabList[_selectedIndex].subCategories!.asMap().entries.map((entry){
//                                   int idx = entry.key;
//                                   PartnerProductSubCategoryModel d = entry.value;

//                                   return AnimatedContainer(
//                                     duration: const Duration(milliseconds: 250),
//                                     curve: Curves.easeInCubic,
//                                     height: eventCard,
//                                     width: eventCard,
//                                     padding: const EdgeInsets.fromLTRB(kHalfGap, kQuarterGap, kHalfGap, kQuarterGap),
//                                     decoration: BoxDecoration(
//                                       color: selectedSubCatIndex[_selectedIndex] == idx
//                                         ? kAppColor: null,
//                                       border: Border(
//                                         right: BorderSide(
//                                           color: kWhiteColor,
//                                           width: idx == 4 && idx == tabList[_selectedIndex].subCategories!.length - 1? 0: 2,
//                                         ),
//                                       ),
//                                     ),
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         SizedBox(
//                                           height: (eventCard)/2.6,
//                                           width: (eventCard)/2.6,
//                                           child: idx == 0 && d.icon?.path != null && d.icon?.path != "" 
//                                             ? Image.asset(
//                                               d.icon?.path ?? '',
//                                               color: selectedSubCatIndex[_selectedIndex] == idx
//                                                 ? kWhiteColor: kGrayColor,
//                                             )
//                                             : d.icon?.path != null && d.icon?.path != "" 
//                                               ? ColorFiltered(
//                                                 colorFilter:  ColorFilter.mode(
//                                                   selectedSubCatIndex[_selectedIndex] == idx
//                                                    ? Colors.transparent: kGrayColor,
//                                                   BlendMode.srcATop,
//                                                 ),
//                                                 child: ImageUrl(
//                                                   imageUrl: d.icon?.path ?? '',
//                                                   showMugIcon: true,
                                                  
//                                                 ),
//                                               )
//                                               : Image.asset(
//                                                 "assets/icons/coffee_mug.png",
//                                                 color: null
//                                               ),
//                                         ),
//                                         const Gap(gap: kHalfGap),
//                                         FittedBox(
//                                           fit: BoxFit.scaleDown,
//                                           alignment: Alignment.topCenter,
//                                           child: SizedBox(
//                                             height: 35,
//                                             width: eventCard,
//                                             child: Text(
//                                               d.name,
//                                               maxLines: 2,
//                                               textAlign: TextAlign.center,
//                                               style: bodyText2.copyWith(
//                                                 height: 1.2,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: selectedSubCatIndex[_selectedIndex] == idx
//                                                   ? kWhiteColor: kGrayColor,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ]
//                   ],
//                   isEnded && _data.isEmpty
//                     ? Padding(
//                       padding: const EdgeInsets.only(top: kGap),
//                       child: NoDataCoffeeMug(),
//                     )
//                     : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         _data.isEmpty
//                           ? const SizedBox.shrink()
//                           : Column(
//                             children: List.generate(_data.length, (index) {
//                               PartnerProductModel item = _data[index];
//                               return ProductItem(
//                                 data: item,
//                                 onTap: () => _onTap(
//                                   item.id!,
//                                   eventId: tabList[_selectedIndex].isEvent 
//                                     ? tabList[_selectedIndex].eventId ?? '': '',
//                                   eventName: tabList[_selectedIndex].isEvent 
//                                     ? tabList[_selectedIndex].titleText: '',
//                                 ),
//                                 onTapAdd: () {}, 
//                                 lController: lController,
//                                 aController: aController,
//                               );
//                             }),
//                           ),
//                         if(isEnded && _data.isNotEmpty) ...[
//                           Center(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: kGap, bottom: 2*kGap),
//                               child: Text(
//                                 lController.getLang("No more data"),
//                                 textAlign: TextAlign.center,
//                                 style: title.copyWith(
//                                   fontWeight: FontWeight.w500,
//                                   color: kGrayColor,
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                         if(!isEnded) ...[
//                           VisibilityDetector(
//                             key: const Key('loader-widget'),
//                             onVisibilityChanged: onLoadMore,
//                             child: loaderWidget()
//                           ),
//                         ],
//                       ],
//                     ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
//         bottomNavigationBar: GetBuilder<CustomerController>(
//           builder: (controller) {
//             int count = controller.countCartProducts();
//             return IgnorePointer(
//               ignoring: count > 0 ? false : true,
//               child: Visibility(
//                 visible: count > 0 ? true : false,
//                 child: Padding(
//                   padding: kPaddingSafeButton,
//                   child: ButtonOrder(
//                     title: lController.getLang("Basket"),
//                     qty: count,
//                     total: controller.cart.total,
//                     onPressed: () async {
//                       await controller.readCart();
//                       Get.to(() => const ShoppingCartScreen());
//                     }, 
//                     lController: lController
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     }
//   }
// }
