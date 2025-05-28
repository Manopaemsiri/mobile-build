import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/firebase_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/message/components/message_item.dart';
import 'package:coffee2u/screens/customer/message/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  final FirebaseController _firebaseController = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(lController.getLang("Messages")),
        ),
        body: !_customerController.isCustomer() || _firebaseController.streamChatrooms == null
          ? NoDataCoffeeMug()
          : StreamBuilder<QuerySnapshot>(
            stream: _firebaseController.streamChatrooms,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return NoDataCoffeeMug();
              } else {
                List<CustomerChatroomModel> dataModel = [];
                List<dynamic> widgetList = snapshot.data?.docs ?? [];
                int len = widgetList.length;
                for(var i=0; i<len; i++){
                  var tempData = widgetList[i].data();
                  CustomerChatroomModel model = CustomerChatroomModel(
                    id: tempData["_id"],
                    customer: tempData["customer"],
                    partnerShop: tempData["partnerShop"],
                    firebaseChatroomId: tempData["firebaseChatroomId"],
                    isReadAdmin: tempData["isReadAdmin"],
                    isReadPartner: tempData["isReadPartner"],
                    isReadSalesManager: tempData["isReadSalesManager"],
                    isReadCustomer: tempData["isReadCustomer"],
                    recentMessage: tempData["recentMessage"] ?? {},
                    createdAt: tempData["createdAt"] == null
                      ? DateTime.now(): DateTime.parse(tempData["createdAt"]),
                    updatedAt: tempData["updatedAt"] == null
                      ? DateTime.now(): DateTime.parse(tempData["updatedAt"]),
                  );
                  dataModel.add(model);
                }

                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider(height: 1);
                  },
                  itemCount: dataModel.length,
                  itemBuilder: (c, index) {
                    CustomerChatroomModel d = dataModel[index];
                    return MessageItem(
                      model: d,
                      onPressed: () => Get.to(() => MessageScreen(model: d)), 
                      lController: lController,
                    );
                  },
                );
              }
            },
          ),
      ),
    );
  }
}