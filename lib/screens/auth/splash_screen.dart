import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/data/local_storage/local_storage.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/screens/bottom_nav/bottom_nav.dart';
import 'package:coffee2u/screens/languages/list.dart';
import 'package:coffee2u/screens/update_version/read.dart';
import 'package:coffee2u/services/deep_link_service.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with DeepLinkService {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();

  final List<String> allowVersions = [];
  Map<String, dynamic>? res;

  @override
  void initState() {
    _initState();
    super.initState();
  }
  _initState() async {
    await Future.wait([
      lController.initData(),
      _checkMobileVersion(),
    ]);

    if(!allowVersions.contains(appVersion)) {
      Get.to(() => UpdateVersionScreen(res: res ?? {}));
    }else {
      await controllerCustomer.syncData();
      if(controllerCustomer.isCustomer()){
        Get.offAll(() => const BottomNav());
      }else {
        final skipIntro = await LocalStorage.getSkipIntro();
        if(skipIntro == true){
          Get.offAll(() => const SignInMenuScreen(isFirstState: true));
        }else {
          // New User & Campaign launch
          Utils.appReferrrer();
          Get.offAll(() => const LanguagesScreen(), transition: Transition.noTransition);
        }
      }
      initUniLinks();
    }
  }
  Future<void> _checkMobileVersion() async {
    try {
      res = await ApiService.processRead('mobile-check-version');
      final len = res?['result']?['versions']?.length ?? 0;
      for (var i = 0; i < len; i++) {
        allowVersions.add(res?['result']?['versions'][i].trim());
      }
    } catch (e) {
      if(kDebugMode) printError(info: '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kWhiteColor,
        child: Center(
          child: Image.asset(
            "assets/images/logo-app-512.png",
            width: 128,
            height: 128,
          ),
        ),
      ),
    );
  }
}
