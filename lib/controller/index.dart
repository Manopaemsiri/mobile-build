import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/frontend_controller.dart';
import 'package:coffee2u/controller/firebase_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/controller/partner_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:get/get.dart';

class ControllerConfig extends Bindings {
  @override
  void dependencies() {
    Get.put<AppController>(AppController());
    Get.put<LanguageController>(LanguageController());
    Get.put<FrontendController>(FrontendController());
    Get.put<FirebaseController>(FirebaseController());
    Get.put<PartnerController>(PartnerController());
    Get.put<CustomerController>(CustomerController());
  }
}
