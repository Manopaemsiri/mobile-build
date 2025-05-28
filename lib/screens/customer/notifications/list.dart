import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/firebase_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/notifications/components/notification_item.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  final FirebaseController controllerFirebase = Get.find<FirebaseController>();
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang("Notification")),
        bottom: const AppBarDivider(),
      ),
            body: !controllerCustomer.isCustomer() || controllerFirebase.streamOrderStatuses == null
        ? NoDataCoffeeMug()
        : StreamBuilder<QuerySnapshot>(
          stream: controllerFirebase.streamOrderStatuses,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return NoDataCoffeeMug();
            } else {
              List<CustomerNotiModel> dataModel = [];
              List<dynamic> widgetList = snapshot.data?.docs ?? [];
              int len = widgetList.length;
              for(var i=0; i<len; i++){
                var temp = widgetList[i].data();
                CustomerNotiModel model = CustomerNotiModel(
                  id: temp["_id"],
                  type: temp["type"] ?? 1,
                  customer: temp["customer"],
                  partnerShop: temp["partnerShop"],
                  order: temp["order"] ?? {},
                  subscription: temp["subscription"] ?? {},
                  isReadCustomer: temp["isReadCustomer"],
                  shippingStatus: temp["shippingStatus"] ?? '',
                  shippingSubStatus: temp["shippingSubStatus"] ?? '',
                  updatedAt: temp["updatedAt"] == null
                    ? DateTime.now(): DateTime.parse(temp["updatedAt"]),
                );
                dataModel.add(model);
              }

              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(height: 1);
                },
                itemCount: dataModel.length,
                itemBuilder: (c, index) {
                  CustomerNotiModel d = dataModel[index];
                  return NotificationItem(
                    model: d, lController: lController,
                  );
                },
              );
            }
          },
        ),
    );
  }
}