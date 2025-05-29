// import 'dart:math';
// import 'dart:developer' as log1;
import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double widgetFlex = 2.5;
final double screenwidth = DeviceUtils.getDeviceWidth();
final double cardWidth = screenwidth / widgetFlex;


class PartnerShippingCouponScreen extends StatefulWidget {
  const PartnerShippingCouponScreen({
    super.key,
    required this.id,
    this.canRedeem = false,
    this.queryParams,
  });

  final String id;
  final bool canRedeem;
  final Map<String, dynamic>? queryParams;

  @override
  State<PartnerShippingCouponScreen> createState() => _PartnerShippingCouponScreenState();
}

class _PartnerShippingCouponScreenState extends State<PartnerShippingCouponScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  bool isLoading = true;
  PartnerShippingCouponModel _model = PartnerShippingCouponModel();
  final AppController controllerApp = Get.find<AppController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  int _points = 0;

  List<PartnerShopModel> partnerShops = [];
  List<CustomerTierModel> customerTiers = [];

  _initState() async {
    PartnerShippingCouponModel item = PartnerShippingCouponModel();
    Map<String, dynamic> dataInput = {
      "_id": widget.id,
    };
    if(widget.queryParams?.isNotEmpty == true) dataInput.addAll(widget.queryParams ?? {});
    var res1 = await ApiService.processRead(
      "partner-shipping-coupon",
      input: dataInput,
    );
    if(res1!["result"] != null && res1["result"]!["_id"] != null){
      item = PartnerShippingCouponModel.fromJson(res1["result"]);
    }
    if(item.isValid()){
      if(mounted) setState(() => _model = item);
      // if(controllerApp.enabledMultiPartnerShops && item.forAllPartnerShops == 1 && false){
      //   var res2 = await ApiService.processList('partner-shops', input: {
      //     "dataFilter": {
      //       "lat": controllerCustomer.shippingAddress?.lat,
      //       "lng": controllerCustomer.shippingAddress?.lng,
      //     }
      //   });
      //   if(res2!["result"] != null){
      //     List<PartnerShopModel> temp = [];
      //     var len = res2['result'].length;
      //     for (var i = 0; i < len; i++) {
      //       PartnerShopModel model = PartnerShopModel.fromJson(res2["result"][i]);
      //       temp.add(model);
      //     }
      //     if(mounted){
      //       setState(() {
      //         partnerShops = temp;
      //       });
      //     }
      //   }
      // }
      if(item.forAllCustomerTiers == 1){
        var res2 = await ApiService.processList('customer-tiers');
        if(res2!["result"] != null){
          List<CustomerTierModel> temp = [];
          var len = res2['result'].length;
          for (var i = 0; i < len; i++) {
            CustomerTierModel model = CustomerTierModel.fromJson(res2["result"][i]);
            temp.add(model);
          }
          if(mounted) setState(() => customerTiers = temp);
        }
      }
    }

    if(widget.canRedeem){
      var res2 = await ApiService.processRead('total-points');
      if(mounted) setState(() => _points = res2!['result']['data'] ?? 0);
    }

    if(mounted) setState(() => isLoading = false);
  }
  
  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!isLoading && _model.isValid()){
      List<FileModel>? gallery = [];
      if (_model.image != null && _model.image!.path.isNotEmpty) {
        gallery.add(_model.image as FileModel);
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(
            _model.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: body1(_model, gallery),
        bottomNavigationBar: controllerCustomer.isCustomer() && widget.canRedeem
          ? Padding(
            padding: kPaddingSafeButton,
            child: IgnorePointer(
              ignoring: _points >= _model.redeemPoints? false: true,
              child: ButtonFull(
                title: "${lController.getLang("Redeem")} ${numberFormat(_model.redeemPoints.toDouble(), digits: 0)} ${lController.getLang("Points")}",
                color: _points >= _model.redeemPoints? kAppColor: kGrayColor,
                onPressed: _onTabRedeem,
              ),
            ),
          )
          : const SizedBox.shrink(),
      );
    }else{
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: isLoading
            ? Loading()
            : NoDataCoffeeMug(),
        ),
      );
    }
  }

  Widget body1(PartnerShippingCouponModel item, List<FileModel>? gallery) {
    String dataDate = lController.getLang("From")
      +' '+dateFormat(item.startAt ?? DateTime.now())+' '
      +lController.getLang("To")
      +' '+dateFormat(item.endAt ?? DateTime.now());
    String widgetContent = item.description == ''
      ? item.shortDescription: item.description;

    // List<PartnerShopModel> forPartnerShops = item.forPartnerShops;
    List<CustomerTierModel> forCustomerTiers = item.forCustomerTiers;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gallery == null || gallery.isEmpty
            ? const SizedBox.shrink()
            : Carousel(
              images: gallery,
              aspectRatio: 16 / 10,
              viewportFraction: 1,
              margin: 0,
              radius: const BorderRadius.all(Radius.circular(0)),
              isPopImage: true,
            ),
    
          Container(
            width: double.infinity,
            padding: kPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    item.name,
                    style: headline5.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.4
                    ),
                  ),
                ),
                
                const Gap(gap: kOtGap),
                Text(
                  dataDate,
                  style: subtitle1.copyWith(
                    color: kDarkColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  '${lController.getLang("Shipping discount")} ${item.displayDiscount(lController, trimDigits : true)}',
                  style: title.copyWith(
                    color: kAppColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
                
                if(widgetContent != '') ...[
                  const Gap(gap: kOtGap),
                  Text(
                    widgetContent,
                    style: subtitle1.copyWith(
                      color: kDarkColor
                    ),
                  ),
                ],
              
                const SizedBox(height: kHalfGap),
              ],
            )
          ),
    
          // if(controllerApp.enabledMultiPartnerShops && false) ...[
          //   if (item.forAllPartnerShops == 0 && forPartnerShops.isNotEmpty) ...[
          //     const Gap(gap: kHalfGap),
          //     SectionTitle(
          //       titleText: lController.getLang("Promotional Shops"),
          //     ),
          //     SizedBox(
          //       height: 194.0,
          //       child: Container(
          //         alignment: Alignment.centerLeft,
          //         child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           shrinkWrap: true,
          //           itemCount: forPartnerShops.length,
          //           itemBuilder: (context, index) {
          //             PartnerShopModel shop = forPartnerShops[index];
          //             if (shop.status == 0) {
          //               return const SizedBox.shrink();
          //             } else {
          //               return Padding(
          //                 padding: EdgeInsets.only(
          //                   left: index == 0 ? kGap - 2 : 0,
          //                   right: index == forPartnerShops.length - 1? kGap - 2: 0
          //                 ),
          //                 child: CardShop(
          //                   width: cardWidth,
          //                   model: shop,
          //                   showDistance: false,
          //                   onPressed: () => _onTapShop(shop.id ?? '')
          //                 ),
          //               );
          //             }
          //           },
          //         ),
          //       ),
          //     ),
          //     const Gap(gap: kGap),
          //   ],
          //   if (item.forAllPartnerShops == 1 && partnerShops.isNotEmpty) ...[
          //     const Gap(gap: kHalfGap),
          //     SectionTitle(
          //       titleText: lController.getLang("Promotional Shops"),
          //     ),
          //     SizedBox(
          //       height: 194.0,
          //       child: Container(
          //         alignment: Alignment.centerLeft,
          //         child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           shrinkWrap: true,
          //           itemCount: partnerShops.length,
          //           itemBuilder: (context, index) {
          //             PartnerShopModel shop = partnerShops[index];
          //             if (shop.status == 0) {
          //               return const SizedBox.shrink();
          //             } else {
          //               return Padding(
          //                 padding: EdgeInsets.only(
          //                   left: index == 0 ? kGap - 2 : 0,
          //                   right: index == partnerShops.length - 1? kGap - 2: 0
          //                 ),
          //                 child: CardShop(
          //                   width: cardWidth,
          //                   model: shop,
          //                   showDistance: true,
          //                   onPressed: () => _onTapShop(shop.id ?? '')
          //                 ),
          //               );
          //             }
          //           },
          //         ),
          //       ),
          //     ),
          //     const Gap(gap: kGap),
          //   ],
          // ],
          
          if(item.shippings.isNotEmpty) ...[
            const Gap(gap: kHalfGap),
            SectionTitle(
              titleText: lController.getLang("Related Shipping Methods"),
            ),
            SizedBox(
              height: 168.0,
              child: Container(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: item.shippings.length,
                  itemBuilder: (context, index) {
                    PartnerShippingModel d = item.shippings[index];
                  
                    if (d.status == 0) {
                      return const SizedBox.shrink();
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? kGap - 2 : 0,
                          right: index == forCustomerTiers.length - 1? kGap - 2: 0
                        ),
                        child: CardGeneral(
                          width: cardWidth,
                          titleText: d.displayName,
                          image: d.icon?.path ?? "",
                          boxFit: BoxFit.contain,
                          maxLines: 2,
                          onPressed: () => {}
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const Gap(gap: kGap),
          ],
          if(item.forAllCustomerTiers == 0 && forCustomerTiers.isNotEmpty) ...[
            const Gap(gap: kHalfGap),
            SectionTitle(
              titleText: lController.getLang("Promotional Customer Tiers"),
            ),
            SizedBox(
              height: 146.0,
              child: Container(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: forCustomerTiers.length,
                  itemBuilder: (context, index) {
                    CustomerTierModel d = forCustomerTiers[index];
                  
                    if (d.status == 0) {
                      return const SizedBox.shrink();
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? kGap - 2 : 0,
                          right: index == forCustomerTiers.length - 1? kGap - 2: 0
                        ),
                        child: CardGeneral(
                          width: cardWidth,
                          titleText: d.name,
                          image: d.icon?.path ?? "",
                          onPressed: () => {}
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const Gap(gap: kGap),
          ],
          if(item.forAllCustomerTiers == 1 && customerTiers.isNotEmpty) ...[
            const Gap(gap: kHalfGap),
            SectionTitle(
              titleText: lController.getLang("Promotional Customer Tiers"),
            ),
            SizedBox(
              height: 148.0,
              child: Container(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: customerTiers.length,
                  itemBuilder: (context, index) {
                    CustomerTierModel d = customerTiers[index];
                  
                    if (d.status == 0) {
                      return const SizedBox.shrink();
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? kGap - 2 : 0,
                          right: index == customerTiers.length - 1? kGap - 2: 0
                        ),
                        child: CardGeneral(
                          width: cardWidth,
                          titleText: d.name,
                          image: d.icon?.path ?? "",
                          onPressed: () => {}
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const Gap(gap: kGap),
          ],
    
        ],
      ),
    );
  }

  _onTabRedeem() async {
    if(_points >= _model.redeemPoints){
      ShowDialog.showForceDialog(
        lController.getLang("Confirm Coupon Redemption"),
        "${lController.getLang("text_coupon1")} ${numberFormat(_model.redeemPoints.toDouble(), digits: 0)} ${lController.getLang("Points")}",
        () async {
          Get.back();
          bool res = await ApiService.processCreate(
            "redeem-partner-shipping-coupon",
            input: { "couponId": _model.id },
            needLoading: true,
          );
          if(res){
            ShowDialog.showForceDialog(
              lController.getLang("Successfully redeemed the coupon"),
              lController.getLang("text_coupon2"),
              (){
                Get.back();
                Get.back();
              },
            );
          }
        },
        onCancel: () => Get.back(),
        confirmText: lController.getLang("Yes"),
        cancelText: lController.getLang("No"),
      );
    }
  }

  // _onTapShop(String shopId) {
  //   Get.to(
  //     () => PartnerShopScreen(shopId: shopId),
  //   );
  // }
}