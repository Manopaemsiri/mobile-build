import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/screens/partner/product/components/add_to_cart_bottom_sheet.dart';
import 'package:coffee2u/screens/partner/product/components/youtube_view.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import '../product_reviews/list.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    super.key,
    this.productId,
    this.youtubeVideo,
    this.eventId,
    this.eventName,
    this.backTo,
    this.subscription = false,
  });

  final String? productId;
  final Widget? youtubeVideo;
  final String? eventId;
  final String? eventName;
  final String? backTo;
  final bool subscription;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final productId = widget.productId;
  late String? eventId = widget.eventId;
  late String? eventName = widget.eventName;
  
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  final AppController _aController = Get.find<AppController>();

  PartnerShopModel? shopModel;

  PartnerProductModel? data;
  List<Map<String, dynamic>> _attributes = [];
  final List<List<Map<String, dynamic>>> _attributeSet = [];
  List<FileModel> gallery = [];

  bool _isReady = false;
  int _quantity = 1;
  int _stock = 0;
  PartnerProductUnitModel? widgetUnit;
  List<PartnerProductModel> _relatedProducts = [];
  List<PartnerProductModel> _upSalesProducts = [];

  bool trimDigits = true;

  List<PartnerProductRatingModel> _partnerProductRatings = [];

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() async {
    await _readPartnerShop();
    await Future.wait([
      _readProduct(),
      _readProductRatings(),
    ]);
    if(mounted){
      setState(() {
        _stock;
        shopModel;
        _stock;
        data;
        _attributes;
        gallery;
        _isReady = true;
      });
    }
    _readproductRelateds();
  }

  Future<void> _readPartnerShop() async {
    try {
      if(_customerController.partnerShop != null
        && _customerController.partnerShop?.type != 9) {
        var res2 = await ApiService.processRead('partner-shop', input: { '_id': _customerController.partnerShop?.id });
        shopModel = PartnerShopModel.fromJson(res2!['result']);
      }else {
        final res1 = await ApiService.processRead('partner-shop-center');
        shopModel = PartnerShopModel.fromJson(res1!['result']);
      }
    } catch (e) {
      if(kDebugMode) print('$e');
    }
  }

  Future<void> _readProduct() async {
    try {
      Map<String, dynamic> input = { "_id": productId };
      input['partnerShopId'] = shopModel?.id;
      final res = await ApiService.processRead(
        "partner-product",
        input: input
      );
      data = PartnerProductModel.fromJson(res?['result']);
      _stock = data?.getMaxStock() ?? 0;
      gallery = [];
      if (data?.image != null && data?.image!.path != '') gallery.add(data!.image as FileModel);
      if (data?.gallery != null) {
        for (var f in data!.gallery!) {
          if (f.path != '') gallery.add(f);
        }
      }
      
      if(data?.isSetSaved()) {
        final pdSet = data?.productSet;
        final ids = pdSet?.map((e) => e.id).toSet();
        pdSet?.retainWhere((x) => ids?.remove(x.id) ?? false);
        pdSet?.forEach((d) {
          var temp = [
            {"title": lController.getLang("Product"), "desc": d.name},
            {"title": "SKU", "desc": d.sku}
          ];
          if(d.brand != null) temp.add({"title": lController.getLang("Brands"), "desc": d.brand!.name});
          if(d.category != null) temp.add({"title": lController.getLang("Type"), "desc": d.category!.name});
          if(d.subCategory != null) temp.add({"title": lController.getLang("Subtype"), "desc": d.subCategory!.name});
          if((d.weight) > 0.01) temp.add({"title": lController.getLang("Weight"), "desc": d.displayWeight()});
          temp.add({"title": lController.getLang("Size"), "desc": d.displayDimension()});
          _attributeSet.add(temp);
        });
      }else {
        _attributes = [{"title": "SKU", "desc": data?.sku}];
        if(data?.brand != null) _attributes.add({"title": lController.getLang("Brands"), "desc": data?.brand!.name});
        if(data?.category != null) _attributes.add({"title": lController.getLang("Type"), "desc": data?.category!.name});
        if(data?.subCategory != null) _attributes.add({"title": lController.getLang("Subtype"), "desc": data?.subCategory!.name});
        if((data?.weight ?? 0) > 0.01) _attributes.add({"title": lController.getLang("Weight"), "desc": data?.displayWeight()});
        _attributes.add({"title": lController.getLang("Size"), "desc": data?.displayDimension()});
      }
    } catch (e) {
      if(kDebugMode) print('$e');
      data = null;
    }
  }

  Future<void> _readproductRelateds() async {
    final Map<String, dynamic> input = {
      "dataFilter": {
        "productId": productId,
        "partnerShopId": shopModel?.id,
      }
    };
    var res1 = await ApiService.processList(
      "partner-product-relateds",
      input: input,
    );
    if(res1 != null && res1["result"] != null){
      List<PartnerProductModel> temp = [];
      var len = res1['result'].length;
      for (var i = 0; i < len; i++) {
        PartnerProductModel model = PartnerProductModel.fromJson(res1['result'][i]);
        temp.add(model);
      }
      _relatedProducts = temp;
    }

    var res2 = await ApiService.processList(
      "partner-product-relateds",
      input: {
        "dataFilter": {
          "type": 2,
          "productId": productId,
          "partnerShopId": shopModel?.id,
        }
      },
    );
    if(res2 != null && res2["result"] != null){
      List<PartnerProductModel> temp = [];
      var len = res2['result'].length;
      for (var i = 0; i < len; i++) {
        PartnerProductModel model = PartnerProductModel.fromJson(res2['result'][i]);
        temp.add(model);
      }
      _upSalesProducts = temp;
    }
    if(mounted) {
      setState(() {
        _relatedProducts;
        _upSalesProducts;
      });
    }
  }
  
  Future<void> _readProductRatings() async {
    try{
      final res = await ApiService.processList("partner-product-ratings", input: {
        "dataFilter": {
          'productId': productId, 
          'channel': 'C2U'
        },
        "paginate": {
          "page": 1,
          "pp": 4,
        }
      });
      _partnerProductRatings = [];
      var len = res?["result"].length;
        for (var i = 0; i < len; i++) {
          PartnerProductRatingModel model =
              PartnerProductRatingModel.fromJson(res!["result"][i]);
          _partnerProductRatings.add(model);
        }
    }catch (_){}
  }

  onPressedOrder(PartnerProductModel? dataProduct) async {
    if (dataProduct != null && _quantity > 0) {
      bool isClearance = widgetUnit == null 
        ? dataProduct.isClearance() 
        : widgetUnit!.isClearance();
      // Current product is clearance
      if(isClearance){
        await _customerController.addCart(
          dataProduct,
          _quantity,
          unit: widgetUnit,
          isClearance: isClearance,
          eventId: eventId,
          eventName: eventName,
        );
        if(widget.backTo != null){
          _customerController.clearCheckout();
          Get.until((route) => Get.currentRoute == widget.backTo);
        }else{
          Get.back();
          Get.back();
        }
      }else {
        final bool clearance = AppHelpers.checkProductClearance(_customerController.cart);
        // Cart contains clearance product
        await _customerController.addCart(
          dataProduct,
          _quantity,
          unit: widgetUnit,
          isClearance: clearance,
          eventId: eventId,
          eventName: eventName,
        );
        if(widget.backTo != null){
          _customerController.clearCheckout();
          Get.until((route) => Get.currentRoute == widget.backTo);
        }else{
          Get.back();
          Get.back();
        }
      }
    }else if (dataProduct == null) {
      ShowDialog.showForceDialog(
        lController.getLang("Error"),
        lController.getLang("text_product_error1"),
        () => Get.back(),
      );
    }else{
      ShowDialog.showForceDialog(
        lController.getLang("Error"),
        lController.getLang("text_product_error2"),
        () => Get.back(),
      );
    }
  }

  void _onTapDownPaymentInfo(PartnerProductModel product) {
    if(product.isValidDownPayment()){
      ShowDialog.showForceDialog(
        lController.getLang("Deposit"),
        lController.getLang("text_deposit_product1").replaceFirst("_VALUE_", "${product.preparingDays == 0? 30: product.preparingDays}"),
        () => Get.back(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

    if(!_isReady || data == null){
      return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Loading(),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SizedBox(
                height: appBarHeight,
                width: double.infinity,
                child: AppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarBrightness: Brightness.dark,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundColor: kWhiteColor,
                  leading: Container(
                    margin: const EdgeInsets.only(left: kGap),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kAppColor,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Platform.isIOS
                          ? Icons.arrow_back_ios_outlined
                          : Icons.arrow_back_outlined),
                        splashRadius: 1.25*kGap,
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    String widgetPrice = data!.isSetSaved()
    ? data!.displaySetSavedPrice(lController, trimDigits: trimDigits)
    : !_customerController.isCustomer() 
      ? data!.displayPrice(lController, trimDigits: trimDigits)
      : data!.displaySigninPrice(lController, trimDigits: trimDigits);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: kWhiteColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Carousel(
                    images: gallery,
                    aspectRatio: 1,
                    viewportFraction: 1,
                    margin: 0,
                    radius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    isPopImage: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, 0),
                    child: Text(
                      data!.name,
                      style: headline5.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, 0),
                    child: !_customerController.isCustomer()
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: widgetPrice,
                              style: headline5.copyWith(
                                fontFamily: 'Kanit',
                                color: kAppColor,
                                fontWeight: FontWeight.w600,
                                height: 1.45,
                              ),
                              children: [
                                TextSpan(
                                  text: " / ${data!.unit}",
                                  style: bodyText1.copyWith(
                                    fontFamily: 'Kanit',
                                    color: kDarkColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if(data?.isSetSaved() == true) ...[
                                  TextSpan(
                                    text: "   ${lController.getLang("Discount")} ${data!.setSavedPercent()}%",
                                    style: subtitle1.copyWith(
                                      fontFamily: 'Kanit',
                                      color: kAppColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " ${lController.getLang("From")} ",
                                    style: subtitle1.copyWith(
                                      fontFamily: 'Kanit',
                                      color: kGrayColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: data?.displaySetFullSavedPrice(lController, trimDigits: trimDigits),
                                    style: subtitle1.copyWith(
                                      fontFamily: 'Kanit',
                                      color: kGrayColor,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if(data!.signinPrice() < data!.getPrice()) ...[
                            InkWell(
                              onTap: () => Get.to(() => const SignInMenuScreen()),
                              child: BadgeDefault(
                                title: data!.displaySigninPrice(lController, trimDigits: trimDigits),
                                icon: FontAwesomeIcons.crown,
                                size: 15,
                              ),
                            ),
                          ],
                        ],
                      )
                      : RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: widgetPrice,
                          style: headline5.copyWith(
                            fontFamily: 'Kanit',
                            color: kAppColor,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                          children: [
                            TextSpan(
                              text: " / ${data!.unit}",
                              style: bodyText1.copyWith(
                                fontFamily: 'Kanit',
                                color: kDarkColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if(data?.isDiscounted() == true || data?.isSetSaved() == true) ...[
                              TextSpan(
                                text: "   ${lController.getLang("Discount")} ${data?.isSetSaved() == true? data!.setSavedPercent() :data!.discountPercent()}%",
                                style: subtitle1.copyWith(
                                  fontFamily: 'Kanit',
                                  color: kAppColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: " ${lController.getLang("From")} ",
                                style: subtitle1.copyWith(
                                  fontFamily: 'Kanit',
                                  color: kGrayColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: data?.isSetSaved() == true
                                ? data?.displaySetFullSavedPrice(lController, trimDigits: trimDigits)
                                : data?.displayMemberPrice(lController, trimDigits: trimDigits),
                                style: subtitle1.copyWith(
                                  fontFamily: 'Kanit',
                                  color: kGrayColor,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ),
                  if(data?.isValidDownPayment() == true) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: "${lController.getLang("Deposit")} ",
                              style: subtitle1.copyWith(
                                fontFamily: 'Kanit',
                                color: kDarkColor,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: data?.displayDownPayment(lController, trimDigits: trimDigits),
                                  style: headline6.copyWith(
                                    fontFamily: 'Kanit',
                                    color: kAppColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            child: const FaIcon(
                              FontAwesomeIcons.circleInfo,
                              color: kAppColor,
                              size: 22,
                            ),
                            onTap: () => _onTapDownPaymentInfo(data!),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if(data?.description.isNotEmpty == true) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, 0),
                      child: Text(
                        data!.description,
                        style: title,
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, 0),
                    child: Column(
                      children: [
                        if(data?.isSetSaved()) ...[
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, index) {
                              final itemSet = _attributeSet[index];
                              return TableList(list: itemSet);
                            }, 
                            separatorBuilder: (_, index) {
                              return const Gap();
                            }, 
                            itemCount: _attributeSet.length
                          )
                        ]else ...[
                          TableList(list: _attributes),
                        ]
                      ],
                    ),
                  ),
                  if (data?.youtubeVideoId != '') ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, 0),
                      child: YoutubeView(
                        youtubeId: data!.youtubeVideoId,
                        backTo: Get.currentRoute
                      ),
                    ),
                  ],
                  const Gap(),
                  
                  if(data?.rating != null && (data?.rating ?? 0) > 0)...[
                    const DividerThick(),
                    Container(
                      color: kWhiteColor,
                      padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, kGap),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lController.getLang('Customer Reviews'),
                            style: subtitle1.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 26*1.6,
                                    child: Text(
                                      numberFormat(data?.rating, digits: 1),
                                      style: headline5.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 26,
                                      ),
                                    ),
                                  ),
                                  const Gap(gap: kHalfGap),
                                  StarRating(
                                    score: data?.rating,
                                    size: 18,
                                  ),
                                  const Gap(gap: kHalfGap),
                                  Text(
                                    data?.rating == null? '': lController.getLang('rating_${(data?.rating ?? 0).floor()}'),
                                    style: subtitle1.copyWith(
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: onTapViewAllComments,
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  lController.getLang('view all'),
                                  style: bodyText1.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: kAppColor
                                  ),
                                ),
                              )

                            ],
                          ),
                          const Divider(height: kGap, thickness: 0.8),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (_, i) {

                              if(i > 2) return const SizedBox.shrink();
                              return CardReview(
                                data: _partnerProductRatings[i],
                                maxLines: 4,
                                lController: lController,
                              );
                            },
                            separatorBuilder: (_, __) => const Divider(height: 0.8, thickness: 0.8),
                            itemCount: _partnerProductRatings.length,
                          ),
                          if(_partnerProductRatings.length > 3)...[
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onTapViewAllComments,
                              child: Column(
                                children: [
                                  const Divider(height: 0.8, thickness: 0.8),
                                  const Gap(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        lController.getLang('See more'),
                                        style: bodyText1.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ],
                  
                  if (_relatedProducts.isNotEmpty && !widget.subscription) ...[
                    Container(
                      color: kWhiteSmokeColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, 0),
                            child: Text(
                              lController.getLang("Related Products"),
                              style: headline6.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kGap),
                            child: Wrap(
                              spacing: kHalfGap,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              children: _relatedProducts.map((item) {

                                return CardProduct(
                                  data: item,
                                  customerController: _customerController,
                                  lController: lController,
                                  aController: _aController,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (BuildContext context) => ProductScreen(
                                        productId: item.id!,
                                        eventId: widget.eventId,
                                        eventName: widget.eventName,
                                        backTo: widget.backTo,
                                      ))
                                    );
                                  },
                                  trimDigits: trimDigits,
                                  showStock: _customerController.isShowStock(),
                                );
                              }).toList(),
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_upSalesProducts.isNotEmpty && !widget.subscription) ...[
                    Container(
                      color: kWhiteSmokeColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, 0),
                            child: Text(
                              lController.getLang("You May Be Interested In"),
                              style: headline6.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kGap),
                            child: Wrap(
                              spacing: kHalfGap,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              children: _upSalesProducts.map((item) {

                                return CardProduct(
                                  data: item,
                                  customerController: _customerController,
                                  lController: lController,
                                  aController: _aController,
                                  showStock: _customerController.isShowStock(),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (BuildContext context) => ProductScreen(
                                        productId: item.id!,
                                        eventId: widget.eventId,
                                        eventName: widget.eventName,
                                        backTo: widget.backTo,
                                      ))
                                    );
                                  },
                                  trimDigits: trimDigits
                                );
                              }).toList(),
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SizedBox(
              height: appBarHeight,
              width: double.infinity,
              child: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.light,
                ),
                backgroundColor: Colors.transparent,
                foregroundColor: kWhiteColor,
                leading: Container(
                  margin: const EdgeInsets.only(left: kGap),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kAppColor,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Platform.isIOS
                        ? Icons.arrow_back_ios_outlined
                        : Icons.arrow_back_outlined),
                      splashRadius: 1.25*kGap,
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                actions: [
                  GetBuilder<CustomerController>(builder: (controller) {
                    return Container(
                      margin: const EdgeInsets.only(right: kGap),
                      child: controller.isCustomer() 
                        ? Center(
                          child: IconButton(
                            icon: controller.isFavoriteProduct(data!)
                              ? const Icon(Icons.favorite, color: kAppColor)
                              : const Icon(Icons.favorite_border, color: kAppColor),
                            iconSize: 2*kGap,
                            splashRadius: 1.25*kGap,
                            onPressed: () async {
                              await controller.toggleFavoriteProduct(data?.id ?? '');
                            },
                          ),
                        ): const SizedBox.shrink(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.subscription
      ? const SizedBox.shrink()
      : Padding(
        padding: kPaddingSafeButton,
        child: data?.status == 1? ButtonFull(
            title: 'Coming Soon',
            color: kGrayColor,
            onPressed: (){},
          )
          : _stock <= 0? ButtonFull(
            title: lController.getLang("Out of Stock"),
            color: kGrayColor,
            onPressed: (){},
          )
          : ButtonFull(
            title: lController.getLang("Buy Item"),
            onPressed: onTapBuyItem
          ),
      ),
    );
  }

  Future<void> onTapBuyItem() async {
    ShowDialog.showLoadingDialog();
    List<PartnerProductUnitModel> dataUnits = [];
    try {
      final res = await ApiService.processList("partner-product-units", input: {
        "dataFilter": {
          "productId": data?.id,
          "partnerShopId": shopModel?.id,
        }
      });
      final len = res?["result"].length;
      for(var i=0; i<len; i++){
        dataUnits.add(PartnerProductUnitModel.fromJson(res?["result"][i]));
      }
    } catch (e) {
      if(kDebugMode) printError(info: '$e');
    }
    Get.back();
    
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kButtonRadius),
      ),
      builder: (context) {
        return AddToCartBottomSheet(
          model: data!,
          shopModel: shopModel!,
          units: dataUnits,
          stock: _stock,
          onChangeQuantity: (int value) async {
            if(mounted) setState(() => _quantity = value);
          },
          onChangeUnit: (PartnerProductUnitModel? model) async {
            if(mounted) setState(() => widgetUnit = model);
          },
          onPressedOrder: () => onPressedOrder(data!),
          trimDigits: trimDigits,
        );
      },
    );
  }

  onTapViewAllComments() => Get.to(() => ProductReviewsScreen(productId: productId ?? ''));
}