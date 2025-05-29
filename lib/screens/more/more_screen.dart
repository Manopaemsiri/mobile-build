import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/firebase_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/screens/bottom_nav/bottom_nav.dart';
import 'package:coffee2u/screens/cms/content/read.dart';
import 'package:coffee2u/screens/customer/message/list.dart';
import 'package:coffee2u/screens/customer/my_favorite_products/list.dart';
import 'package:coffee2u/screens/customer/point_reward/read.dart';
import 'package:coffee2u/screens/customer/profile/change_password_screen.dart';
import 'package:coffee2u/screens/customer/profile/profile_screen.dart';
import 'package:coffee2u/screens/customer/subscriptions/list.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MoreScreen extends StatefulWidget {
  const MoreScreen({
    super.key
  });

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final LanguageController _lController = Get.find<LanguageController>();
  final FirebaseController controllerFirebase = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(builder: (controller) {
      String name = controller.customerModel == null
        ? 'Guest Account'
        : controller.customerModel!.displayName();
      String widgetImage = controller.customerModel?.avatar?.path ?? '';

      return Scaffold(
        backgroundColor: kWhiteSmokeColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          toolbarHeight: kToolbarHeight + kGap,
          title: controller.isCustomer()
            ? Container(
              color: kWhiteColor,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ImageProfileCircle(
                  imageUrl: widgetImage,
                ),
                title: Text(
                  name,
                  style: title.copyWith(
                    color: kAppColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _lController.getLang("Account Settings"),
                      style: subtitle2.copyWith(color: kDarkColor),
                    ),
                    const Gap(gap: kQuarterGap),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
                onTap: () => Get.to(() => const ProfileScreen()),
                trailing: systemLanguages.length > 1 
                ? GestureDetector(
                  onTap: changeLanguage,
                  child: Container(
                    height: 56*0.6,
                    width: 56*0.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kAppColor,
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/flag/${_lController.languageCode.toUpperCase()}.jpg"
                        ),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                )
                : const SizedBox.shrink()
              ),
            )
            : Container(
              color: kWhiteColor,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const SizedBox(
                  height: 56,
                  width: 56,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(defaultPath),
                  ),
                ),
                title: Text(
                  name,
                  style: title.copyWith(
                    color: kAppColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _lController.getLang("Sign In"),
                      style: subtitle2.copyWith(color: kDarkColor),
                    ),
                    const Gap(gap: kQuarterGap),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
                onTap: () => Get.to(() => const SignInMenuScreen()),
                trailing: systemLanguages.length > 1 
                ? GestureDetector(
                  onTap: changeLanguage,
                  child: Container(
                    height: 56*0.6,
                    width: 56*0.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kAppColor,
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/flag/${_lController.languageCode.toUpperCase()}.jpg"
                        ),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                )
                : const SizedBox.shrink()
              ),
            ),
          bottom: const AppBarDivider(),
        ),
        body: ListView(
          children: [
            Container(
              color: kWhiteColor,
              child: Column(
                children: [
                  if (controller.isCustomer()) ...[
                    GetBuilder<AppController>(
                      builder: (controllerApp){
                        return Column(
                          children: [
                            if(controllerApp.settings(key: 'APP_MODULE_PARTNER_SUBSCRIPTION') == '1')...[
                              const Divider(height: 1),
                              ListTile(
                                title: Text(_lController.getLang("Subscription Package")),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => Get.to(() => CustomerSubscriptionsScreen()),
                              ),
                            ],
                          ],
                        );
                      }
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(_lController.getLang("Point Reward")),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Get.to(() => const PointRewardScreen()),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(_lController.getLang("My Favorite Products")),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Get.to(() => const MyFavoriteProductsScreen()),
                    ),
                    if(controllerFirebase.isInit) ...[
                      const Divider(height: 1),
                      StreamBuilder<QuerySnapshot>(
                        stream: controllerFirebase.streamNewMessages,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          int countNewMessages = 0;
                          if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                            countNewMessages = snapshot.data!.docs.length;
                          }
                          return ListTile(
                            title: Text(_lController.getLang("Messages")),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                countNewMessages > 0
                                  ? Container(
                                    width: 20,
                                    height: 20,
                                    padding: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: kAppColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$countNewMessages',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: kWhiteColor,
                                        height: 1
                                      ),
                                    ),
                                  ): const SizedBox.shrink(),
                                const SizedBox(width: kQuarterGap),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                            onTap: () => Get.to(() => const MessagesScreen()),
                          );
                        }
                      ),
                    ],
                  ],
                  const Divider(height: 1),
                  ListTile(
                    title: Text(_lController.getLang("About Us")),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.to(() => const CmsContentScreen(
                      url: "about",
                      showCart: false,
                    )),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(_lController.getLang("Contact Us")),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.to(() => const CmsContentScreen(
                      url: "contact",
                      showCart: false,
                    )),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(_lController.getLang("Privacy Policy")),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.to(() => const CmsContentScreen(
                      url: "privacy-policy",
                      showCart: false,
                    )),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(_lController.getLang("Terms and Conditions")),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.to(() => const CmsContentScreen(
                      url: "terms-and-conditions",
                      showCart: false,
                    )),
                  ),
                  if (!controller.isCustomer()) ...[
                    const Divider(height: 1),
                    ListTile(
                      title: Text(_lController.getLang("Sign In")),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Get.to(() => const SignInMenuScreen()),
                    ),
                  ] 
                  else ...[
                    const Divider(height: 1),
                    ListTile(
                      title: Text(_lController.getLang("Change Password")),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Get.to(() => const ChangePasswordScreen()),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(_lController.getLang("Delete Your Account")),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _onTapDeleteYourAccount,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(_lController.getLang("Sign Out")),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _onTapSignOut,
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(
                kGap, 1.25*kGap, kGap, 1.25*kGap
              ),
              child: Text(
                "${_lController.getLang("Version")} $appVersion",
                textAlign: TextAlign.center,
                style: subtitle2.copyWith(
                  fontWeight: FontWeight.w400,
                  color: kGrayColor,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _onTapDeleteYourAccount() {
    ShowDialog.showOptionDialog(
      _lController.getLang("Delete Your Account"),
      "${_lController.getLang("text_delete_account_1")} ?",
      () async {
        ShowDialog.showLoadingDialog();
        await ApiService.processUpdate("request-to-delete");
        await ApiService.authSignout();
        Get.back();
        Get.back();
      },
    );
  }

  void _onTapSignOut() {
    ShowDialog.showOptionDialog(
      _lController.getLang("Sign Out"),
      "${_lController.getLang("text_sign_out_1")} ?",
      () async {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 150));
        ShowDialog.showLoadingDialog();
        await ApiService.authSignout();
        Get.back();
      },
    );
  }

  Future<void> changeLanguage() async {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Get.theme.cardColor,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kRadius))
          ),
          content: Container(
            width: min(Get.width*0.7, 300),
            constraints: BoxConstraints(
              maxHeight: min(Get.height*0.5, 465)
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(kRadius))
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    _lController.getLang('Choose Language'),
                    textAlign: TextAlign.center,
                    style: title.copyWith(
                      // fontFamily: lController.fontFamily,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                // const CustomDivider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),                                              
                  itemCount: systemLanguages.length,
                  itemBuilder: (BuildContext context, int index) {
                    String langCode = systemLanguages[index];
                    String lang = '';

                    if(langCode == 'th'){
                      lang = 'Thai';
                    }else if(langCode == 'ko'){
                      lang = 'Korean';
                    }else if(langCode == 'zh'){
                      lang = 'Chinese';
                    }else{
                      lang = 'English';
                    }

                    return GestureDetector(
                      onTap: () async {
                        ShowDialog.showLoadingDialog();
                        await _lController.refreshData(code: langCode);
                        Get.offAll(
                          () => const BottomNav(initialTab: 4, showPopup: false), 
                          transition: Transition.noTransition
                        );
                      },
                      child: Container(
                        color: langCode == _lController.languageCode? kAppColor.withValues(alpha: 0.2): null,
                        child: ListTile(
                          leading: Container(
                            height: kGap*2,
                            decoration: BoxDecoration(
                              boxShadow: [
                                 BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  spreadRadius: 3,
                                  blurRadius: kGap,
                                  offset: const Offset(0, 0),
                                ),
                              ]
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
                              child: AspectRatio(
                                aspectRatio: 3/2,
                                child: Image.asset(
                                  "assets/images/flag/${systemLanguages[index].toUpperCase()}.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            lang,
                            style: title.copyWith(
                            ),
                          ),
                        ),
                      ),
                    );
                  }, 
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}