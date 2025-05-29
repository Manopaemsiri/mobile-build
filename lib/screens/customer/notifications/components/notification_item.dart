import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/firebase_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/order/read.dart';
import 'package:coffee2u/screens/customer/subscriptions/read.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.model,
    required this.lController
  });

  final CustomerNotiModel model;
  final LanguageController lController;


  @override
  Widget build(BuildContext context) {
    final FirebaseController controllerFirebase = Get.find<FirebaseController>();
    return Dismissible(
      key: Key(model.id ?? ''),
      direction: DismissDirection.endToStart,
      onDismissed: (_){
        controllerFirebase.deleteOrderStatus(model.id ?? '');
      },
      background: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kGap, vertical: kQuarterGap
        ),
        decoration: const BoxDecoration(
          color: kAppColor,
        ),
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: kHalfGap),
          child: Icon(
            Icons.delete,
            size: 24,
            color: kWhiteColor,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          controllerFirebase.readOrderStatus(model.id ?? '');
          if(model.isSubscription){
            Get.to(() => CustomerSubscriptionScreen(id: model.id ?? ''));
          }else{
            Get.to(() => CustomerOrderScreen(orderId: model.id ?? ''));
          }
        },
        child: Container(
          color: kWhiteColor,
          padding: const EdgeInsets.fromLTRB(kGap, kGap, 0, kGap),
          child: Column(
            children: [
              Row(
                children: [
                  ImageProduct(
                    imageUrl: model.isSubscription? (model.subscription["image"] ?? '') 
                      : (model.partnerShop["icon"] ?? ''),
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(width: kQuarterGap),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        model.isSubscription
                          ? '📦 ${model.subscription["name"] ?? ''}'
                          : '🧾 ${lController.getLang("Order")} #${model.order["orderId"]}',
                        style: subtitle1.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.3
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.isSubscription 
                              ? (model.subscription["description"] ?? '')
                              : '${lController.getLang("Shipping Status")} : ${model.shippingStatus}',
                            style: subtitle2.copyWith(
                              fontWeight: FontWeight.w400
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            Utils.timeAgo(model.updatedAt),
                            style: caption
                          ),
                        ],
                      ),
                      trailing: BadgeOnline(
                        isOnline: !model.isReadCustomer,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}