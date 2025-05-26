import 'dart:async';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/subscription/read.dart';
import 'package:coffee2u/screens/partner/subscription/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/index.dart';
import '../../../widgets/index.dart';
import '../../../widgets/loading/shimmer_partner_subscription_list.dart';
import '../../../widgets/loading/shimmer_partner_subscription_list_grid.dart';
import 'controllers/subscriptions_controller.dart';

class SubscriptionSearchController extends GetxController {
  bool isSearching = false;
  String searchQuery = '';
  List<PartnerProductSubscriptionModel> filteredData = [];

  Timer? _debounce;

  void toggleSearch(List<PartnerProductSubscriptionModel> allData) {
    isSearching = !isSearching;

    if (isSearching && searchQuery.isEmpty) {
      filteredData = allData;
    }
    update();
  }

  void search(String query, List<PartnerProductSubscriptionModel> allData) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchQuery = query.toLowerCase();

      filteredData = allData.where((item) {
        final name = item.name.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
      update();
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}

class PartnerProductSubscriptionsScreen extends StatelessWidget {
  const PartnerProductSubscriptionsScreen({
    Key? key,
    required this.lController,
  }) : super(key: key);

  final LanguageController lController;

  @override
  Widget build(BuildContext context) {
    Get.put(SubscriptionSearchController());

    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang('Subscription Package')),
        actions: [
          GetBuilder<SubscriptionSearchController>(
            builder: (searchCtrl) {
              return IconButton(
                icon: Icon(searchCtrl.isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  final allData = Get.find<SubscriptionsController>().data;
                  searchCtrl.toggleSearch(allData);
                },
              );
            },
          )
        ],
      ),
      body: GetBuilder<SubscriptionsController>(
        init: SubscriptionsController(),
        builder: (controller) {
          return Column(
            children: [
              GetBuilder<SubscriptionSearchController>(
                builder: (searchCtrl) {
                  return searchCtrl.isSearching
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kGap),
                        child: TextField(
                        decoration: InputDecoration(
                          hintText: 'ค้นหาแพ็กเกจ...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1, color: kAppColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                            onChanged: (value) => searchCtrl.search(value, controller.data),
                            onSubmitted: (value) {
                              searchCtrl.search(value, controller.data);
                              searchCtrl.isSearching = false; 
                              searchCtrl.update();           
                            },
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),

              Expanded(
                child: GetBuilder<SubscriptionSearchController>(
                  builder: (searchCtrl) {
                    final dataToShow = searchCtrl.filteredData.isNotEmpty || searchCtrl.searchQuery.isNotEmpty
                      ? searchCtrl.filteredData
                      : controller.data;

                    return RefreshIndicator(
                      onRefresh: () => controller.onRefresh(),
                      child: dataToShow.isEmpty
                          ? NoDataCoffeeMug() 
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kGap),
                              itemCount: dataToShow.length + 1,
                              itemBuilder: (context, index) {
                                if (index == dataToShow.length) {
                                  return controller.isEnded
                                    ? const SizedBox.shrink()
                                    : VisibilityDetector(
                                        key: const Key('loader-widget'),
                                        onVisibilityChanged: controller.onLoadMore,
                                        child: const ShimmerPartnerSubscriptionList(),
                                  );
                                }

                                final item = dataToShow[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: kGap),
                                  child: SubscriptionCardList(
                                    data: item,
                                    onTap: onTap,
                                    lController: lController,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }

      onTap(String id) => Get.to(() => PartnerProductSubscriptionScreen(id: id, lController: lController));
    }
