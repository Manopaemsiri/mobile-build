import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';

class TabBarModel {
  TabBarModel({
    required this.titleText,
    this.isEvent = false,
    this.categoryId,
    this.eventId,
    this.eventCategories,
    this.subCategoryId,
    this.subCategories,
    required this.body,
  });

  final String titleText;
  final bool isEvent;
  final String? categoryId;
  final String? eventId;
  final List<PartnerProductCategoryModel>? eventCategories;
  String? subCategoryId;
  List<PartnerProductSubCategoryModel>? subCategories;
  final Widget body;

  static List<Tab> getTabBar(List<TabBarModel> tabList) {
    return tabList.map((e) {
      return Tab(
        child: Text(
          e.titleText,
          style: title.copyWith(fontWeight: FontWeight.w500),
        ),
      );
    }).toList();
  }

  static List<Widget> getTabBarView(List<TabBarModel> tabList) {
    return tabList.map((e) => e.body).toList();
  }
}
