import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/point_reward/components/my_product_coupon_tab.dart';
import 'package:coffee2u/screens/customer/point_reward/components/my_shipping_coupon_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCouponsScreen extends StatefulWidget {
  const MyCouponsScreen({
    Key? key,
    this.enabledProductCoupons = false,
    this.enabledShippingCoupons = false,
    this.enabledCashCoupons = false,
  }): super(key: key);
  
  final bool enabledProductCoupons;
  final bool enabledShippingCoupons;
  final bool enabledCashCoupons;

  @override
  State<MyCouponsScreen> createState() => _MyCouponsScreenState();
}

class _MyCouponsScreenState extends State<MyCouponsScreen> {
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    List<TabBarModel> tabList = [];
    if(widget.enabledProductCoupons){
      tabList.add(TabBarModel(
        titleText: lController.getLang("product coupon short"),
        body: const MyProductCouponTab(isCashCoupon: false),
      ));
    }
    if(widget.enabledShippingCoupons){
      tabList.add(TabBarModel(
        titleText: lController.getLang("shipping coupon short"),
        body: const MyShippingCouponTab(),
      ));
    }
    if(widget.enabledCashCoupons){
      tabList.add(TabBarModel(
        titleText: lController.getLang("Cash Coupon"),
        body: const MyProductCouponTab(isCashCoupon: true),
      ));
    }

    return DefaultTabController(
      length: tabList.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            indicatorWeight: 4,
            indicatorColor: kAppColor,
            labelColor: kAppColor,
            unselectedLabelColor: kGrayColor,
            tabs: TabBarModel.getTabBar(tabList),
          ),
          title: Text(lController.getLang("My Coupons")),
        ),
        body: TabBarView(children: TabBarModel.getTabBarView(tabList)),
      ),
    );
  }
}