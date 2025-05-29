import 'dart:io';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateVersionScreen extends StatefulWidget {
  const UpdateVersionScreen({
    super.key,
    required this.res
  });
  final Map<String, dynamic> res;

  @override
  State<UpdateVersionScreen> createState() => _UpdateVersionScreenState();
}

class _UpdateVersionScreenState extends State<UpdateVersionScreen> {
  late final Map<String, dynamic> res = widget.res;
  String currentVersion = '';
  String newVersion = '';
  String url = '';

  @override
  void initState() {
    getData();
    super.initState();
  }

  int compareVersions(String version1, String version2) {
    List<int> parts1 = version1.split('.').map(int.parse).toList();
    List<int> parts2 = version2.split('.').map(int.parse).toList();
    int maxLength = parts1.length > parts2.length ? parts1.length : parts2.length;
    for (int i = 0; i < maxLength; i++) {
      int part1 = i < parts1.length ? parts1[i] : 0;
      int part2 = i < parts2.length ? parts2[i] : 0;
      if (part1 < part2) {
        return -1;
      } else if (part1 > part2) {
        return 1;
      }
    }
    return 0;
  }

  Future<void> getData() async {
    currentVersion = appVersion;

    final List<String> allowVersions = [];
    final len = res['result']?['versions']?.length ?? 0;
    for (var i = 0; i < len; i++) {
      allowVersions.add(res['result']?['versions'][i].trim());
    }

    if (allowVersions.isNotEmpty) {
      String maxVersion = allowVersions.reduce((a, b) {
        if (compareVersions(a, b) >= 0) {
          return a;
        } else {
          return b;
        }
      });
      newVersion = res['result']?['version'] ?? maxVersion;
    }

    if(Platform.isIOS){
      url = (res['result']?['appStoreUrl'] ?? '').trim();
    }else {
      url = (res['result']?['googlePlayUrl'] ?? '').trim();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double _appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

    return GetBuilder<LanguageController>(
      builder: (lController) {
        final String desc = lController.getLang("text_update_2")
          .replaceFirst('_VALUE1_', appName)
          .replaceFirst('_VALUE2_', newVersion) //New Version
          .replaceFirst('_VALUE3_', currentVersion); // Old Version
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: kWhiteColor,
            body: ListView(
              padding: kPadding,
              children: [
                Gap(gap: _appBarHeight * 1.75),
                Column(
                  children: [
                    Image.asset(
                      "assets/images/logo-app-512.png",
                      width: 110,
                    ),
                    const Gap(gap: 30),

                    Text(
                      lController.getLang("text_update_1"),
                      textAlign: TextAlign.center,
                      style: title.copyWith(
                        fontWeight: FontWeight.w600
                      )
                    ),
                    const Gap(),

                    Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: subtitle1
                    ),
                  ],
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: kPaddingSafeButton,
              child: ButtonFull(
                title: lController.getLang("text_update_3"),
                onPressed: onTap
              ),
            ),
          ),
        );
      }
    );
  }

  void onTap() async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      if(kDebugMode) print('Could not launch $url');
      ShowDialog.showForceDialog(
        'Error', 
        'text_update_error_1', 
        () => Get.back()
      );
    }
  }
}