import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/billing_address/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import '../../partner/subscription/controllers/subscription_checkout_controller.dart';
import '../../partner/subscription/controllers/subscription_checkout_update_controller.dart';

class BillingAddressesScreen extends StatefulWidget {
  const BillingAddressesScreen({
    super.key,
    this.subscription,
  });
  final int? subscription;

  @override
  State<BillingAddressesScreen> createState() => _BillingAddressesScreenState();
}

class _BillingAddressesScreenState extends State<BillingAddressesScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final AppController controllerApp = Get.find<AppController>();
  
  List<CustomerBillingAddressModel> dataModel = [];

  CustomerGroupModel? _customerGroup;

  bool loading = true;
  
  Future<void> billingAddressList({bool updateState = false}) async {
    try {
      dataModel = [];
      final res = await ApiService.processList("billing-addresses");
      var len = res?["result"].length;
      for (var i = 0; i < len; i++) {
        dataModel.add(CustomerBillingAddressModel.fromJson(res!["result"][i]));
      }

      if(mounted && updateState) setState(() {});
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }
  Future<void> readCustomerGroup() async {
    if(Get.find<CustomerController>().customerModel?.group != null){
      try {
        final res = await ApiService.processRead("group");
        if(res?["result"].isNotEmpty) _customerGroup = CustomerGroupModel.fromJson(res!["result"]);
        _customerGroup = _customerGroup ?? Get.find<CustomerController>().customerModel?.group;
      } catch (e) {
        if(kDebugMode) printError(info: e.toString());
      }
    }
  }

  void _initState() async {
    await Future.wait([
      billingAddressList(),
      controllerApp.getSetting(),
    ]);
    if(controllerApp.enabledCustomerGroup) await readCustomerGroup();
    if(mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lController.getLang("Billing Addresses"),
        ),
        bottom: const AppBarDivider(),
      ),
      body: loading
      ? Center(child: Loading())
      : GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, kGap),
              child: Column(
                children: [
                  GetBuilder<CustomerController>(builder: (controller) {
                    return Column(children: [
                      dataModel.isNotEmpty
                        ? Card(
                          clipBehavior: Clip.hardEdge,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, kHalfGap),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(kRadius),
                            onTap: () async {
                              await ApiService.processUpdate("billing-address-set-selected");
                              await controller.updateBillingAddress(null);
                              if(widget.subscription == 1){ 
                                Get.find<SubscriptionCheckoutController>().updateBillingAddress(null);
                              }else if(widget.subscription == 2){
                                Get.find<SubscriptionCheckoutUpdateController>().updateBillingAddress(null);
                              }
                              Get.back();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: kPadding,
                              child: Text(
                                lController.getLang("No billing address"),
                                style: title.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
                      dataModel.isEmpty
                        ? Card(
                          child: Padding(
                            padding: const EdgeInsets.only(top: kHalfGap, bottom: kQuarterGap),
                            child: NoDataCoffeeMug(),
                          ),
                        )
                        : Card(
                          margin: EdgeInsets.zero,
                          child: Column(
                            children: List.generate(dataModel.length, (index) {
                              CustomerBillingAddressModel item = dataModel[index];
                              return SizedBox(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: kPadding,
                                      child: SizedBox(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.displayAddress(lController, sep: '\n', withCountry: true),
                                              style: subtitle1,
                                            ),
                                            const Gap(gap: kQuarterGap),
                                            Text(
                                              '${lController.getLang('Telephone Number')} ${item.telephone}',
                                              style: subtitle1,
                                            ),
                                            const Gap(gap: kHalfGap),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      lController.getLang("toggle_status"),
                                                      style: subtitle2.copyWith(
                                                        fontWeight: FontWeight.w500
                                                      ),
                                                    ),
                                                    Transform.scale(
                                                      scale: 0.7,
                                                      child: CupertinoSwitch(
                                                        value: item.id == controller.billingAddress?.id
                                                          && (widget.subscription == 2? item == controller.billingAddress: true),
                                                        onChanged: (bool value) async {
                                                          await ApiService.processUpdate(
                                                            "billing-address-set-selected",
                                                            input: { "_id": item.id }
                                                          );
                                                          await controller.updateBillingAddress(item);
                                                          if(widget.subscription == 1){
                                                            Get.find<SubscriptionCheckoutController>().updateBillingAddress(item);
                                                          }else if(widget.subscription == 2){
                                                            Get.find<SubscriptionCheckoutUpdateController>().updateBillingAddress(item);
                                                          }
                                                        },
                                                        activeColor: kAppColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if((_customerGroup?.enableAddressCorrection() == true && controllerApp.enabledCustomerGroup) 
                                                || _customerGroup == null 
                                                || !controllerApp.enabledCustomerGroup)...[
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.border_color_outlined
                                                    ),
                                                    splashRadius: 1.45*kGap,
                                                    onPressed: () {
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        BillingAddressScreen(
                                                          isEditMode: true,
                                                          addressModel: item
                                                        )
                                                      )).then((value) {
                                                        billingAddressList(updateState: true);
                                                        if(widget.subscription == 1){
                                                          Get.find<SubscriptionCheckoutController>().updateBillingAddress(controller.billingAddress);
                                                        }else if(widget.subscription == 2){
                                                          Get.find<SubscriptionCheckoutUpdateController>().updateBillingAddress(controller.billingAddress);
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ]
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(height: 1),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      dataModel.length < 3
                        ? const SizedBox(height: kGap)
                        : const SizedBox(height: 0),
                      dataModel.length < 3 && (_customerGroup == null || !controllerApp.enabledCustomerGroup)
                        ? Card(
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.add_circle_outline,
                              color: kGreenColor,
                            ),
                            title: Text(
                              lController.getLang("Add New Address"),
                              style: subtitle1.copyWith(
                                color: kGreenColor,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const BillingAddressScreen(),
                              )).then((value) {
                                billingAddressList(updateState: true);
                                if(widget.subscription == 1){
                                  Get.find<SubscriptionCheckoutController>().updateBillingAddress(controller.billingAddress);
                                }else if(widget.subscription == 2){
                                  Get.find<SubscriptionCheckoutUpdateController>().updateBillingAddress(controller.billingAddress);
                                } 
                              });
                            },
                          ),
                        )
                        : const SizedBox(height: 0)
                    ]);
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
