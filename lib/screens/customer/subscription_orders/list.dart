import 'package:coffee2u/screens/customer/order/read.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/index.dart';
import '../../../controller/language_controller.dart';
import '../../../models/index.dart';
import '../../../widgets/index.dart';
import '../../../widgets/loading/shimmer_customer_subscription_list.dart';
import 'controllers/subscription_orders_controller.dart';
import 'widgets/card_subscription_order.dart';

class CustomerSubscriptionOrdersScreen extends StatelessWidget {
  CustomerSubscriptionOrdersScreen({
    super.key,
    required this.subscriptionId
  });
  final String subscriptionId;
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CustomerSubscriptionOrdersController>(
      init: CustomerSubscriptionOrdersController(subscriptionId: subscriptionId),
      builder: (controller) {

        return Scaffold(
          appBar: AppBar(
            title: Text(
              lController.getLang('Billing Information'),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.onRefresh(),
            child: controller.isEnded && controller.data.isEmpty
            ? NoData()
            : ListView(
              padding: const EdgeInsets.only(bottom: kGap),
              children: [
                const Gap(gap: kGap),
                Column(
                  children: [
                    controller.data.isEmpty
                    ? const SizedBox.shrink()
                    : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: kGap),
                      shrinkWrap: true,
                      itemCount: controller.data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, int index) {
                        CustomerSubscriptionPlanModel item = controller.data[index];
                        
                        return CardSubscriptionOrder(
                          data: item,
                          index: index,
                          dataLength: controller.data.length,
                          onTap: (d) => Get.to(() => CustomerOrderScreen(orderId: d)),
                          lController: lController,
                        );
                      },
                      separatorBuilder: (context, index) => const Gap(gap: kHalfGap),
                    ),
                    controller.isEnded
                    ? Padding(
                      padding: const EdgeInsets.only(top: kGap, bottom: kGap),
                      child: Text(
                        lController.getLang("No more data"),
                        textAlign: TextAlign.center,
                        style: title.copyWith(
                          fontWeight: FontWeight.w500,
                          color: kGrayColor
                        ),
                      ),
                    )
                    : VisibilityDetector(
                      key: const Key('loader-widget'),
                      onVisibilityChanged: controller.onLoadMore,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: kGap),
                        child: ShimmerCustomerSubscriptionList(),
                      ),
                    ),
                  ],
                ),
              ]
            ),
          ),
        );
      }
    );
  }
}