import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:coffee2u/firebase_options.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class FirebaseController extends GetxController {
  bool isInit = false;

  late CollectionReference chatrooms;
  Stream<QuerySnapshot<Object?>>? streamChatrooms;
  Stream<QuerySnapshot<Object?>>? streamNewMessages;

  late CollectionReference chatroomsMessages;
  Stream<QuerySnapshot<Object?>>? streamMessages;

  // Order Status + Subscription
  late CollectionReference orderStatuses;
  Stream<QuerySnapshot<Object?>>? streamOrderStatuses;
  Stream<QuerySnapshot<Object?>>? streamNewOrderStatuses;

  _onInit() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    chatrooms = FirebaseFirestore.instance.collection('customer_chatrooms');
    chatroomsMessages = FirebaseFirestore.instance.collection('customer_chatroom_messages');

    orderStatuses = FirebaseFirestore.instance.collection('customer_order_statuses');

    isInit = true;
  }

  @override
  void onInit() {
    _onInit();
    super.onInit();
  }

  // START: Chatroom
  Future<bool> sendMessage(CustomerChatroomModel model, {
    bool checkRoom = false,
    String text = '',
    List<String> images = const []
  }) async {
    try {
      if (model.isValid() && model.firebaseChatroomId != '') {
        await ApiService.processUpdate("chatroom", input: {
          "_id": model.id,
          "isArchived": 0
        });

        if (checkRoom) {
          var room = await chatrooms.doc(model.firebaseChatroomId).get();
          if (!room.exists) {
            await chatrooms.doc(model.firebaseChatroomId).set(model.toJson());
          }
        }

        String now = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
        final message = {
          "createdAt": now,
          "fromCustomer": true,
          "images": images,
          "sender": model.customer,
          "text": text
        };

        await chatroomsMessages.doc(model.firebaseChatroomId)
          .collection('data').doc().set(message);

        await chatrooms.doc(model.firebaseChatroomId).update({
          "customer": model.customer,
          "partnerShop": model.partnerShop,
          "isReadAdmin": false,
          "isReadPartner": false,
          "isReadSalesManager": false,
          "isReadCustomer": true,
          "recentMessage": message,
          "updatedAt": now
        });

        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> readMessage(CustomerChatroomModel model) async {
    try {
      if (model.isValid() && model.firebaseChatroomId != '') {
        var room = await chatrooms.doc(model.firebaseChatroomId).get();
        if (room.exists) {
          await chatrooms.doc(model.firebaseChatroomId)
              .update({ "isReadCustomer": true });
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateChatrooms(String? customerId) async {
    try {
      if (customerId == null || customerId == '') {
        streamChatrooms = null;
        streamNewMessages = null;
      } else if (isInit) {
        streamChatrooms = chatrooms
          .where('customer._id', isEqualTo: customerId)
          .orderBy('updatedAt', descending: true)
          .snapshots();

        streamNewMessages = chatrooms
          .where('customer._id', isEqualTo: customerId)
          .where('isReadCustomer', isEqualTo: false)
          .orderBy('updatedAt', descending: true)
          .snapshots();
      }
    } catch (err) {
      if (kDebugMode) printError(info: '$err');
    }
    update();
  }

  Stream<QuerySnapshot> subscribeChatroom(String firebaseChatroomId) {
    return chatroomsMessages
      .doc(firebaseChatroomId)
      .collection('data')
      .orderBy('createdAt', descending: true)
      .snapshots();
  }

  // START: Order Status + Subscription 
  Future<bool> readOrderStatus(String docId) async {
    try {
      var status = await orderStatuses.doc(docId).get();
      if (status.exists) {
        await orderStatuses.doc(docId).update({ "isReadCustomer": true });
      }
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> deleteOrderStatus(String docId) async {
    try {
      var status = await orderStatuses.doc(docId).get();
      if (status.exists) {
        await orderStatuses.doc(docId).delete();
      }
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateOrderStatuses(String? customerId, {int? type}) async {
    try {
      if (customerId == null || customerId.isEmpty) {
        streamOrderStatuses = null;
        streamNewOrderStatuses = null;
      } else if (isInit) {
        var query = orderStatuses.where('customer._id', isEqualTo: customerId);
        if (type != null) query = query.where('type', isEqualTo: type);

        streamOrderStatuses = query
           .orderBy('updatedAt', descending: true)
          .snapshots();

         streamNewOrderStatuses = query
           .where('isReadCustomer', isEqualTo: false)
          .orderBy('updatedAt', descending: true)
         .snapshots();
      }
    } catch (err) { 
        debugPrint('err');
        if (kDebugMode) printError(info: '$err');
    }
    update();
  }
}