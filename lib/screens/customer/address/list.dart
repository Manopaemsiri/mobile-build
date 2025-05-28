import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/address/read.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import '../../partner/subscription/controllers/subscription_checkout_controller.dart';
import '../../partner/subscription/controllers/subscription_checkout_update_controller.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({
    super.key,
    this.subscription,
    this.subscriptionId
  });
  final int? subscription;
  final String? subscriptionId;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  final AppController controllerApp = Get.find<AppController>();
  CustomerGroupModel? _customerGroup;

  bool loading = true;
  List<CustomerShippingAddressModel> dataModel = [];

  Future<void> shippingAddressList({bool updateState = false}) async {
    try {
      dataModel = [];
      final res = await ApiService.processList("shipping-addresses");
      var len = res?["result"].length;
      for (var i = 0; i < len; i++) {
        dataModel.add(CustomerShippingAddressModel.fromJson(res!["result"][i]));
      }
      if(mounted && updateState) setState(() => loading = false);
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }
  Future<void> readCustomerGroup() async {
    if(controllerCustomer.customerModel?.group != null){
      try {
        final res = await ApiService.processRead("group");
        if(res?["result"].isNotEmpty) _customerGroup = CustomerGroupModel.fromJson(res!["result"]);
        _customerGroup = _customerGroup ?? controllerCustomer.customerModel?.group;
      } catch (e) {
        _customerGroup = null;
        if(kDebugMode) printError(info: e.toString());
      }
    }
  }

  void _initState() async {
    await Future.wait([
      controllerApp.getSetting(),
      shippingAddressList(),
    ]);
    if(controllerApp.enabledCustomerGroup && widget.subscription == null) await readCustomerGroup();
    
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
          lController.getLang("Shipping Addresses"),
        ),
        bottom: const AppBarDivider(),
      ),
      body: loading
      ? Center(child: Loading())
      : GetBuilder<CustomerController>(
        builder: (controller) {
          
          return ListView(
            padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, kGap),
            children: [
              !loading && dataModel.isEmpty
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
                      CustomerShippingAddressModel item = dataModel[index];
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
                                                value: item.id == controller.shippingAddress?.id
                                                  && (widget.subscription == 2? item == controller.shippingAddress: true),
                                                onChanged: (bool value) async {
                                                  if(item.id != controller.shippingAddress?.id || widget.subscription == 2){
                                                    ShowDialog.showLoadingDialog();
                                                    await ApiService.processUpdate(
                                                      "shipping-address-set-selected",
                                                      input: { "_id": item.id }
                                                    );
                                                    await controllerCustomer.readCart(needLoading: false);
                                                    await Future.wait([
                                                      controller.updateShippingAddress(item),
                                                      controllerCustomer.clearStateToNull(),
                                                      AppHelpers.updatePartnerShop(controllerCustomer),
                                                    ]);
                                                                                                        
                                                    if (widget.subscription != null) {
                                                      await ApiService.processUpdate(
                                                        'customer-subscription',
                                                        input: {
                                                         '_id': widget.subscriptionId,
                                                         'shippingAddressId': item.id,
                                                        },
                                                      );
                                                    }
                                                    if(widget.subscription == 1){
                                                      Get.find<SubscriptionCheckoutController>().updateShippingAddress(controller.shippingAddress);
                                                    }else if(widget.subscription == 2){
                                                      Get.find<SubscriptionCheckoutUpdateController>().updateShippingAddress(controller.shippingAddress);
                                                    }
                                                    Get.back();
                                                  }
                                                },
                                                activeTrackColor: kAppColor,
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
                                              Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) =>
                                                  AddressAddScreen(
                                                    isEditMode: true,
                                                    addressModel: item
                                                  ),
                                              )).then((value) async {
                                                if(value != null && value?['refresh'] == true) {
                                                  await controllerCustomer.clearStateToNull();
                                                  await AppHelpers.updatePartnerShop(controllerCustomer);
                                                  shippingAddressList(updateState: true);
                                                  if(widget.subscription == 1){
                                                    Get.find<SubscriptionCheckoutController>().updateShippingAddress(controller.shippingAddress);
                                                  }else if(widget.subscription == 2){
                                                    Get.find<SubscriptionCheckoutUpdateController>().updateShippingAddress(controller.shippingAddress);
                                                  }
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
              !loading && dataModel.length < 3
                ? const SizedBox(height: kGap)
                : const SizedBox(height: 0),
              !loading && dataModel.length < 3 && (_customerGroup == null || !controllerApp.enabledCustomerGroup)
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
                        builder: (context) => const AddressAddScreen(),
                      )).then((value) async {
                        if(value != null && value?['refresh'] == true) {
                          await AppHelpers.updatePartnerShop(controllerCustomer);
                          shippingAddressList(updateState: true);
                          if(widget.subscription == 1) {
                            Get.find<SubscriptionCheckoutController>().updateShippingAddress(controller.shippingAddress);
                          }else if(widget.subscription == 2){
                            Get.find<SubscriptionCheckoutUpdateController>().updateShippingAddress(controller.shippingAddress);
                          }
                        }
                      });
                    },
                  ),
                )
                : const SizedBox(height: 0)
            ]
          );
        }
      ),
    );
  }
}