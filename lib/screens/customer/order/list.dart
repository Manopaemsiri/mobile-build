import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/frontend_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomerOrdersScreen extends StatelessWidget {
  CustomerOrdersScreen({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  final int initialTab;
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FrontendController>(
      builder: (fc) {
        List<TabBarModel> tabList = fc.tabListshippingStatuses;

        return tabList.isEmpty
        ? Scaffold(
          backgroundColor: kGrayLightColor,
          appBar: AppBar(
            title: Text(lController.getLang("Order History")),
          ),
          body: NoDataCoffeeMug(),
        )
        : DefaultTabController(
          initialIndex: initialTab,
          length: tabList.length,
          child: Scaffold(
            backgroundColor: kGrayLightColor,
            appBar: AppBar(
              bottom: TabBar(
                isScrollable: true,
                indicatorWeight: 4,
                indicatorColor: kAppColor,
                labelColor: kAppColor,
                unselectedLabelColor: kGrayColor,
                tabs: TabBarModel.getTabBar(tabList),
              ),
              title: Text(lController.getLang("Order History")),
            ),
            body: TabBarView(children: TabBarModel.getTabBarView(tabList)),
          ),
        );
      }
    );
  }
}