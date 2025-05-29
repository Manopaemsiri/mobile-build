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
                List<CustomerChatroomModel> _data = [];
                List<dynamic> _list = snapshot.data?.docs ?? [];
                int len = _list.length;
                for(var i=0; i<len; i++){
                  var _d = _list[i].data();
                  CustomerChatroomModel model = CustomerChatroomModel(
                    id: _d["_id"],
                    customer: _d["customer"],
                    partnerShop: _d["partnerShop"],
                    firebaseChatroomId: _d["firebaseChatroomId"],
                    isReadAdmin: _d["isReadAdmin"],
                    isReadPartner: _d["isReadPartner"],
                    isReadSalesManager: _d["isReadSalesManager"],
                    isReadCustomer: _d["isReadCustomer"],
                    recentMessage: _d["recentMessage"] ?? {},
                    createdAt: _d["createdAt"] == null
                      ? DateTime.now(): DateTime.parse(_d["createdAt"]),
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
                    CustomerChatroomModel d = _data[index];
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