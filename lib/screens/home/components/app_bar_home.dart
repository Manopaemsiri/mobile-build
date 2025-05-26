import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/customer/address/components/address_selection.dart';
import 'package:coffee2u/screens/partner/search/read.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHome({
    Key? key,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
    required this.lController
  }) : super(key: key);

  @override
  final Size preferredSize;
  final LanguageController lController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: AddressSelection(padding: kPadding, lController: lController,),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _onTapSearch,
        ),
      ],
    );
  }

  void _onTapSearch() {
    Get.to(() => const SearchScreen());
  }
}
