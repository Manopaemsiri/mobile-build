// import 'dart:developer';
// import 'dart:io';

// import 'package:coffee2u/apis/api_service.dart';
// import 'package:coffee2u/constants/app_constants.dart';
// import 'package:coffee2u/data/local_storage/local_storage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:permission_handler/permission_handler.dart';


// class NotificationService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   static void init() async {
//     await FirebaseMessaging.instance.setAutoInitEnabled(true);

//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     log('User permission ${settings.authorizationStatus}');
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       log('User granted permission ${settings.authorizationStatus}');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       log('User granted provisional permission');
//     } else {
//       log('User declined or has not accepted permission');
//       final prefAndroid = await LocalStorage.getBool(prefAndroidNotification) ?? false;
//       if(Platform.isAndroid && prefAndroid != true){
//         await Permission.notification.request();
//         await LocalStorage.saveBool(prefAndroidNotification, true);
//       }
//     }

//     _messaging.onTokenRefresh.listen(onFcmTokenRefresh);

//     FirebaseMessaging.onMessage.listen(onMessaging);
//     FirebaseMessaging.onMessageOpenedApp.listen(onMessaging);

//     final message = await _messaging.getInitialMessage();
//     await onMessaging(message);
//   }

//   static onMessaging(RemoteMessage? message) async {
//     if (message != null) {
//       // NotiModel model = NotiModel(
//       //   title: message.notification?.title,
//       //   body: message.notification?.body,
//       //   sentTime: message.sentTime?.toIso8601String() ??
//       //       DateTime.now().toIso8601String(),
//       // );

//       // save to local storage
//       // await LocalStorage.addNoti(model);
//     }
//   }

//   static Future<void> onMessagingBackground(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     await onMessaging(message);

//     bool _supportAppBadge = await FlutterAppBadger.isAppBadgeSupported();
//     if (_supportAppBadge) {
//       int count = await LocalStorage.getAlertCount();
//       count += 1;
//       if (count > 0) {
//         FlutterAppBadger.updateBadgeCount(count);
//       } else {
//         FlutterAppBadger.removeBadge();
//       }
//       LocalStorage.save(prefAlertCount, count.toString());
//     }
//   }

//   static Future<String> getFcmToken() async {
//     try {
//       String? token = await _messaging.getToken(
//         vapidKey: firebaseMessagingKey,
//       );
//       return token ?? '';
//     } catch (e) {
//       throw Exception(e);
//     }
//   }

//   static Future<void> onFcmTokenRefresh(String? token) async {
//     ApiService.processUpdate('fcm-token', input: {"fcmToken": token ?? ''});
//   }
// }
