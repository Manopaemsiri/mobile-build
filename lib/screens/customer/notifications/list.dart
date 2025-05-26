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
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final CustomerController _customerController = Get.find<CustomerController>();
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang("Notification")),
        bottom: const AppBarDivider(),
      ),
            body: !_customerController.isCustomer() || _firebaseController.streamOrderStatuses == null
        ? NoDataCoffeeMug()
        : StreamBuilder<QuerySnapshot>(
          stream: _firebaseController.streamOrderStatuses,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return NoDataCoffeeMug();
            } else {
              List<CustomerNotiModel> _data = [];
              List<dynamic> _list = snapshot.data?.docs ?? [];
              int len = _list.length;
              for(var i=0; i<len; i++){
                var _d = _list[i].data();
                CustomerNotiModel model = CustomerNotiModel(
                  id: _d["_id"],
                  type: _d["type"] ?? 1,
                  customer: _d["customer"],
                  partnerShop: _d["partnerShop"],
                  order: _d["order"] ?? {},
                  subscription: _d["subscription"] ?? {},
                  isReadCustomer: _d["isReadCustomer"],
                  shippingStatus: _d["shippingStatus"] ?? '',
                  shippingSubStatus: _d["shippingSubStatus"] ?? '',
                  updatedAt: _d["updatedAt"] == null
                    ? DateTime.now(): DateTime.parse(_d["updatedAt"]),
                );
                _data.add(model);
              }

              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(height: 1);
                },
                itemCount: _data.length,
                itemBuilder: (c, index) {
                  CustomerNotiModel d = _data[index];
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