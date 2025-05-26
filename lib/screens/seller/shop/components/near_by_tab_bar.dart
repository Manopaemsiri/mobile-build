import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NearByTabBar extends StatefulWidget {
  const NearByTabBar({
    Key? key,
    required this.onChange,
  }): super(key: key);

  final Function(int index) onChange;

  @override
  State<NearByTabBar> createState() => _NearByTabBarState();
}

class _NearByTabBarState extends State<NearByTabBar> with SingleTickerProviderStateMixin {
  final LanguageController lController = Get.find<LanguageController>();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: _tabController,
        indicatorWeight: 4,
        indicatorColor: kAppColor,
        labelColor: kAppColor,
        unselectedLabelColor: kGrayColor,
        onTap: (int index) {
          widget.onChange(index);
        },
        tabs: [
          Tab(
            child: Text(
              lController.getLang("Coffee Near By"),
              style: title.copyWith(
                fontWeight: FontWeight.w500
              )
            ),
          ),
          Tab(
            child: Text(
              lController.getLang("Map View"),
              style: title.copyWith(
                fontWeight: FontWeight.w500
              )
            ),
          ),
        ],
      ),
    );
  }
}