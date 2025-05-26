import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/point_reward/detail.dart';
import 'package:coffee2u/screens/customer/point_reward/list.dart';
import 'package:coffee2u/screens/customer/point_reward/my_coupons.dart';
import 'package:coffee2u/screens/customer/point_reward/redeems.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointRewardScreen extends StatefulWidget {
  const PointRewardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PointRewardScreen> createState() => _PointRewardScreenState();
}

class _PointRewardScreenState extends State<PointRewardScreen> {
  final LanguageController lController = Get.find<LanguageController>();

  bool isLoading = true;
  int _points = 0;
  DateTime? _resetDate;
  CustomerTierModel? _tier;
  Map<String, dynamic> _settings = {};

  _initState() async {
    try {
      var res1 = await ApiService.processRead('total-points');
      _points = res1!['result']['data'] ?? 0;
      _resetDate = res1['result']['pointResetDate'] == null
        ? null: DateTime.parse(res1['result']['pointResetDate']);
      _tier = res1['result']['tier'] == null
        ? null: CustomerTierModel.fromJson(res1['result']['tier']);

      var res2 = await ApiService.processRead('settings');
      _settings = res2!['result'];

      isLoading = false;
      if(mounted) setState(() {});
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }
  _refreshData() async {
    var res1 = await ApiService.processRead('total-points');
    _points = res1!['result']['data'] ?? 0;
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang("Point Reward")),
      ),
      body: isLoading
        ? Center(child: Loading())
        : ListView(
          padding: kPadding,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 16/10,
                    child: ImageUrl(
                      imageUrl: _tier?.icon?.path ?? '',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  bottom: kGap * 2,
                  right: kGap * 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Utils.numberComma(_points),
                        style: headline3.copyWith(
                          fontFamily: "CenturyGothic",
                          color: kWhiteColor,
                          fontWeight: FontWeight.w600,
                          height: 0.8,
                        ),
                      ),
                      const SizedBox(width: kQuarterGap),
                      Text(
                        lController.getLang("Points"),
                        style: title.copyWith(
                          fontFamily: "Kanit",
                          color: kWhiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if(_tier != null) ...[
              const SizedBox(height: kHalfGap),
              const SizedBox(height: kQuarterGap),
              Text(
                "${lController.getLang("Earn 1 point every")} "
                  + priceFormat(_tier!.pointEarnRate, lController, digits: 0, trimDigits: true) 
                  + " ${lController.getLang("spent")}",
                textAlign: TextAlign.center,
                style: title.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if(_resetDate != null) ...[
                Text(
                  '${lController.getLang("Points Expiry Date")} ${dateFormat(_resetDate ?? DateTime.now())}',
                  textAlign: TextAlign.center,
                  style: subtitle1.copyWith(
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ],

            Padding(
              padding: const EdgeInsets.fromLTRB(kGap, kGap*1.5, kGap, 0),
              child: Column(
                children: [
                  ButtonCustom(
                    title: lController.getLang("History").toUpperCase(),
                    width: double.infinity,
                    height: 2.5 * kGap,
                    textStyle: title.copyWith(fontWeight: FontWeight.w500),
                    onPressed: () => Get.to(() => const PointRewardsScreen()),
                  ),
                  if(
                    _settings['APP_ENABLE_FEATURE_PARTNER_PRODUCT_COUPON'] == '1' 
                    || _settings['APP_ENABLE_FEATURE_PARTNER_CASH_COUPON'] == '1' 
                    || _settings['APP_ENABLE_FEATURE_PARTNER_SHIPPING_COUPON'] == '1' 
                  ) ...[
                    const SizedBox(height: kHalfGap),
                    ButtonCustom(
                      title: lController.getLang("point redeem").toUpperCase(),
                      width: double.infinity,
                      height: 2.5 * kGap,
                      isOutline: true,
                      textStyle: title.copyWith(fontWeight: FontWeight.w500),
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                            RedeemCouponsScreen(
                              enabledProductCoupons: _settings['APP_ENABLE_FEATURE_PARTNER_PRODUCT_COUPON'] == '1',
                              enabledShippingCoupons: _settings['APP_ENABLE_FEATURE_PARTNER_SHIPPING_COUPON'] == '1',
                              enabledCashCoupons: _settings['APP_ENABLE_FEATURE_PARTNER_CASH_COUPON'] == '1',
                            ),
                        )).then((value) {
                          _refreshData();
                        });
                      },
                    ),
                    const SizedBox(height: kHalfGap),
                    ButtonCustom(
                      title: lController.getLang("My Coupons").toUpperCase(),
                      width: double.infinity,
                      height: 2.5 * kGap,
                      isOutline: true,
                      textStyle: title.copyWith(fontWeight: FontWeight.w500),
                      onPressed: () => Get.to(() => MyCouponsScreen(
                        enabledProductCoupons: _settings['APP_ENABLE_FEATURE_PARTNER_PRODUCT_COUPON'] == '1',
                        enabledShippingCoupons: _settings['APP_ENABLE_FEATURE_PARTNER_SHIPPING_COUPON'] == '1',
                        enabledCashCoupons: _settings['APP_ENABLE_FEATURE_PARTNER_CASH_COUPON'] == '1',
                      )),
                    ),
                  ],
                  const SizedBox(height: kHalfGap),
                  ButtonCustom(
                    title: lController.getLang("Tier Detail").toUpperCase(),
                    width: double.infinity,
                    height: 2.5 * kGap,
                    isOutline: true,
                    textStyle: title.copyWith(fontWeight: FontWeight.w500),
                    onPressed: () => Get.to(() => const PointRewardDetailScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}