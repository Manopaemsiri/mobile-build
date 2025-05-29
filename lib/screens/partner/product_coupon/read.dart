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

const double _flex = 2.5;
final double _screenwidth = DeviceUtils.getDeviceWidth();
final double _cardWidth = _screenwidth / _flex;


class PartnerProductCouponScreen extends StatefulWidget {
  const PartnerProductCouponScreen({
    super.key,
    required this.id,
    this.canRedeem = false,
    this.queryParams,
  });

  final String id;
  final bool canRedeem;
  final Map<String, dynamic>? queryParams;

  @override
  State<PartnerProductCouponScreen> createState() => _PartnerProductCouponScreenState();
}

class _PartnerProductCouponScreenState extends State<PartnerProductCouponScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  bool isLoading = true;
  PartnerProductCouponModel _model = PartnerProductCouponModel();
  final AppController _appController = Get.find<AppController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  int _points = 0;

  List<PartnerShopModel> _partnerShops = [];
  List<CustomerTierModel> _customerTiers = [];

  _initState() async {
    PartnerProductCouponModel item = PartnerProductCouponModel();
    Map<String, dynamic> _input = { "_id": widget.id };
    if(widget.queryParams?.isNotEmpty == true){
      _input.addAll(widget.queryParams ?? {});
    }
    var res1 = await ApiService.processRead(
      "partner-product-coupon",
      input: _input,
    );
    if(res1!["result"] != null && res1["result"]!["_id"] != null){
      item = PartnerProductCouponModel.fromJson(res1["result"]);
    }
    if(item.isValid()){
      if(mounted) setState(() => _model = item);
      if(_appController.enabledMultiPartnerShops && item.forAllPartnerShops == 1 && false){
        var res2 = await ApiService.processList('partner-shops', input: {
          "dataFilter": {
            "lat": _customerController.shippingAddress?.lat,
            "lng": _customerController.shippingAddress?.lng,
          }
        });
        if(res2!["result"] != null){
          List<PartnerShopModel> temp = [];
          var len = res2['result'].length;
          for(var i = 0; i < len; i++){
            PartnerShopModel model = PartnerShopModel.fromJson(res2["result"][i]);
            temp.add(model);
          }
          if(mounted){
            setState(() {
              _partnerShops = temp;
            });
          }
        }
      }
      if(item.forAllCustomerTiers == 1){
        var res2 = await ApiService.processList('customer-tiers');
        if(res2!["result"] != null){
          List<CustomerTierModel> temp = [];
          var len = res2['result'].length;
          for(var i = 0; i < len; i++){
            CustomerTierModel model = CustomerTierModel.fromJson(res2["result"][i]);
            temp.add(model);
          }
          if(mounted) setState(() => _customerTiers = temp);
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
      if (_model.image != null && _model.image!.path != '') {
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
        bottomNavigationBar: _customerController.isCustomer() && widget.canRedeem
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

  Widget body1(PartnerProductCouponModel item, List<FileModel>? gallery) {
    String _date = lController.getLang("From")
      +' '+dateFormat(item.startAt ?? DateTime.now())+' '
      +lController.getLang("To")
      +' '+dateFormat(item.endAt ?? DateTime.now());
    String _content = item.description == ''
      ? item.shortDescription: item.description;

    List<PartnerShopModel> _forPartnerShops = item.forPartnerShops;
    List<CustomerTierModel> _forCustomerTiers = item.forCustomerTiers;

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
                  _date,
                  style: subtitle1.copyWith(
                    color: kDarkColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  item.displayType(lController)
                    + (item.displayDiscount(lController, trimDigits: true).isNotEmpty 
                      ? ' '+item.displayDiscount(lController, trimDigits: true): ''),
                  style: title.copyWith(
                    color: kAppColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
                
                if(_content != '') ...[
                  const Gap(gap: kOtGap),
                  Text(
                    _content,
                    style: subtitle1.copyWith(
                      color: kDarkColor
                    ),
                  ),
                ],
              
                const SizedBox(height: kHalfGap),
              ],
            )
          ),

          if(_appController.enabledMultiPartnerShops && false) ...[
            if (item.forAllPartnerShops == 0 && _forPartnerShops.isNotEmpty) ...[
              const Gap(gap: kHalfGap),
              SectionTitle(
                titleText: lController.getLang("Promotional Shops"),
              ),
              SizedBox(
                height: 194.0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _forPartnerShops.length,
                    itemBuilder: (context, index) {
                      PartnerShopModel shop = _forPartnerShops[index];
                      if (shop.status == 0) {
                        return const SizedBox.shrink();
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? kGap - 2 : 0,
                            right: index == _forPartnerShops.length - 1? kGap - 2: 0
                          ),
                          child: CardShop(
                            width: _cardWidth,
                            model: shop,
                            showDistance: false,
                            onPressed: () => _onTapShop(shop.id ?? ''),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const Gap(gap: kGap),
            ],
            if(item.forAllPartnerShops == 1 && _partnerShops.isNotEmpty) ...[
              const Gap(gap: kHalfGap),
              SectionTitle(
                titleText: lController.getLang("Promotional Shops"),
              ),
              SizedBox(
                height: 194.0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _partnerShops.length,
                    itemBuilder: (context, index) {
                      PartnerShopModel shop = _partnerShops[index];
                      if (shop.status == 0) {
                        return const SizedBox.shrink();
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? kGap - 2 : 0,
                            right: index == _partnerShops.length - 1? kGap - 2: 0
                          ),
                          child: CardShop(
                            width: _cardWidth,
                            model: shop,
                            showDistance: true,
                            onPressed: () => _onTapShop(shop.id??''),
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
          if(item.forAllCustomerTiers == 0 && _forCustomerTiers.isNotEmpty) ...[
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
                  itemCount: _forCustomerTiers.length,
                  itemBuilder: (context, index) {
                    CustomerTierModel d = _forCustomerTiers[index];
              
                    if (d.status == 0) {
                      return const SizedBox.shrink();
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? kGap - 2 : 0,
                          right: index == _forCustomerTiers.length - 1? kGap - 2: 0
                        ),
                        child: CardGeneral(
                          width: _cardWidth,
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
          if(item.forAllCustomerTiers == 1 && _customerTiers.isNotEmpty) ...[
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
                  itemCount: _customerTiers.length,
                  itemBuilder: (context, index) {
                    CustomerTierModel d = _customerTiers[index];
              
                    if (d.status == 0) {
                      return const SizedBox.shrink();
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? kGap - 2 : 0,
                          right: index == _customerTiers.length - 1? kGap - 2: 0
                        ),
                        child: CardGeneral(
                          width: _cardWidth,
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
            "redeem-partner-product-coupon",
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

  _onTapShop(String shopId) {
    // Get.to(
    //   () => PartnerShopScreen(shopId: shopId),
    // );
  }
}