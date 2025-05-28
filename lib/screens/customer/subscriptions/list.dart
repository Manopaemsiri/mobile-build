import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/customer/subscriptions/read.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/index.dart';
import '../../../models/customer_subscription_model.dart';
import '../../../widgets/index.dart';
import '../../../widgets/loading/shimmer_customer_subscription_list.dart';
import 'controllers/customer_subscriptions_controller.dart';
import 'widgets/card_customer_subscription.dart';

class CustomerSubscriptionsScreen extends StatelessWidget {
  CustomerSubscriptionsScreen({super.key});
  final lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lController.getLang('Subscription Package')
        ),
      ),
      body: GetBuilder<CustomerSubscriptionsController>(
        init: CustomerSubscriptionsController(),
        builder: (controller) {
          
          return RefreshIndicator(
            onRefresh: () => controller.onRefresh(),
            child: controller.isEnded && controller.data.isEmpty
            ? NoDataCoffeeMug()
            : ListView(
              padding: const EdgeInsets.only(bottom: kGap) + const EdgeInsets.symmetric(horizontal: kGap),
              children: [
                const Gap(gap: kGap),
                Column(
                  children: [
                    controller.data.isEmpty
                    ? const SizedBox.shrink()
                    : ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: controller.data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        CustomerSubscriptionModel item = controller.data[index];
                        return CardCustomerSubscription(
                          data: item,
                          onTap: onTap,
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
                      child: const ShimmerCustomerSubscriptionList(),
                    ),
                  ],
                ),
              ]
            ),
          );
        },
      ),
    );
  }

  Widget widgetBody(CustomerSubscriptionsController controller) {
    return Container();

  }

  onTap(String id) 
    => Get.to(() => CustomerSubscriptionScreen(id: id));
}