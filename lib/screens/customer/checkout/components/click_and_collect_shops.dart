import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/shipping/components/shipping_item.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
// import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../partner/subscription/controllers/subscription_checkout_controller.dart';
import '../../../partner/subscription/controllers/subscription_checkout_update_controller.dart';

class ClickAndCollectShops extends StatefulWidget {
  const ClickAndCollectShops({
    super.key,
    this.subscription
  });
  final int? subscription;

  @override
  State<ClickAndCollectShops> createState() => _ClickAndCollectShopsState();
}

class _ClickAndCollectShopsState extends State<ClickAndCollectShops> {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();

  List<PartnerShippingFrontendModel> dataModel = [];

  int page = 0;
  bool isLoading = false;
  bool isEnded = false;

  late final int? subscription = widget.subscription;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> onRefresh() async {
    if(mounted){
      setState(() {
        page = 0;
        isLoading = false;
        isEnded = false;
        dataModel = [];
      });
    }
    loadData();
  }

  Future<void> loadData() async {
    if (!isEnded && !isLoading) {
      try {
        page += 1;
        if(mounted) setState(() => isLoading = true);
        String endpoint = 'checkout-click-and-collect-shipping-methods';
        if(subscription != null){
          if(subscription ==1){
            endpoint = 'subscription-click-and-collect-shipping-methods';
          }else if(subscription == 2){
            // endpoint = 'subscription-click-and-collect-shipping-methods';
          }
        }

        final res = await ApiService.processList(
          endpoint, input: {
          "paginate": {"page": page, "pp": 10},
        });
        PaginateModel? paginateModel = res?["paginate"] != null? PaginateModel.fromJson(res?["paginate"]): null;

        var len = res?["result"].length;
        for (var i = 0; i < len; i++) {
          PartnerShippingFrontendModel model = PartnerShippingFrontendModel.fromJson(res?["result"][i]);
          dataModel.add(model);
        }
        if(mounted){
          setState(() {
            dataModel;
            if (dataModel.length >= (paginateModel?.total ?? 0)) {
              isEnded = true;
              isLoading = false;
            } else if (res != null) {
              isLoading = false;
            }
          });
        }
      } catch (e) {
        if(kDebugMode) print('$e');
        if(mounted){
          setState(() {
            dataModel = [];
            isEnded = true;
            isLoading = false;
          });
        }
      }
    }
  }

  void onLoadMore(info) async {
    if (info.visibleFraction > 0 && !isEnded && !isLoading) await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang("Select Shop")),
        bottom: const AppBarDivider(),
      ),
      body: isEnded && dataModel.isEmpty && !isLoading
      ? NoDataCoffeeMug()
      : RefreshIndicator(
        onRefresh: onRefresh,
        color: kAppColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          child: Column(
            children: [
              dataModel.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                shrinkWrap: true,
                itemCount: dataModel.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  PartnerShippingFrontendModel d = dataModel[index];

                  return ShippingItem(
                    model: d,
                    onSelect: (val, _) => _onSelect(val),
                    lController: lController,
                    shopShopDetail: true,
                    showImage: true,
                    size: 46,
                  );
                },
              ),
              isEnded
              ? Padding(
                padding: const EdgeInsets.only(top: kGap, bottom: kGap),
                child: Text(
                  lController.getLang("No more data"),
                  textAlign: TextAlign.center,
                  style: title.copyWith(
                    fontWeight: FontWeight.w500,
                    color: kGrayColor
                  ),
                ),
              )
              : VisibilityDetector(
                key: const Key('loader-widget'),
                onVisibilityChanged: onLoadMore,
                child: const ListLoading()
              ),
            ],
          )
        ),
      ),
    );
  }

  _onSelect(PartnerShippingFrontendModel value) async {
    List<WorkingHourModel> dataWhs = value.shop?.workingHours ?? [];
    Map<String, Map<String, int>> dataCwhs = {};
    for(int j=0; j<7; j++){
      int dataJ = dataWhs.indexWhere((x) => x.dayIndex == j && x.isOpened == 1);
      if(dataJ >= 0){
        WorkingHourModel dataWh = dataWhs[dataJ];
        dataCwhs["$j"] = {
          "startH": int.parse(dataWh.startTime!.substring(0, 2)),
          "startM": int.parse(dataWh.startTime!.substring(3, 5)),
          "endH": int.parse(dataWh.endTime!.substring(0, 2)),
          "endM": int.parse(dataWh.endTime!.substring(3, 5)),
        };
      }
    }
    
    DateTime dataNow = DateTime.now();
    DateTime dataToday = DateTime(dataNow.year, dataNow.month, dataNow.day);
    List<DateTime> dataDates = [];
    for(int i=0; i<31; i++){
      DateTime tempData = DateTime(dataNow.year, dataNow.month, dataNow.day+i);
      Map<String, int>? dataT = dataCwhs["${tempData.weekday % 7}"];
      if(dataT != null){
        if(i != 0){
          dataDates.add(tempData);
        }else{
          int dataNh = dataNow.hour + 1;
          if(dataNh < dataT["endH"]! || (dataNh == dataT["endH"] && dataNow.minute < dataT["endM"]!)){
            dataDates.add(tempData);
          }
        }
      }
    }

    DateTime? selectedDate = await showDatePicker(
      context: context, 
      initialDate: dataDates.first, 
      firstDate: dataDates.first, 
      lastDate: dataDates.last,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      selectableDayPredicate: (DateTime tempData){
        return dataDates.contains(tempData);
      }
    );
    if(selectedDate != null){
      bool isSameDay = dataToday == selectedDate;

      Map<String, int>? dataT = dataCwhs["${selectedDate.weekday % 7}"];
      int startH = dataT?["startH"] ?? 0;
      int startM = dataT?["startM"] ?? 0;
      int endH = dataT?["endH"] ?? 0;
      int endM = dataT?["endM"] ?? 0;

      int initH = startH;
      int initM = startM;
      if(isSameDay){
        initH = dataNow.hour + 1;
        initM = (dataNow.minute / 5).ceil() * 5;
        startH = initH;
        startM = initM;
        if(startM >= 60){
          initH += 1;
          initM = 0;
          startH += 1;
          startM = 0;
        }
      }

      TimeOfDay? selectedTime = await _showCustomTimePicker(
        initH, initM, startH, startM, endH, endM
      );
      if(selectedTime != null) {
        ShowDialog.showLoadingDialog();
        value.pickupDate = selectedDate;
        value.pickupTime = selectedTime.hour.toString().padLeft(2, '0')
          +':'+selectedTime.minute.toString().padLeft(2, '0');

        if(subscription == null){
          controllerCustomer.setDiscountShipping(null, needUpdate: true);
          await controllerCustomer.updateCartShop(value.shop?.id ?? '', needLoading: false);
          await controllerCustomer.setShippingMethod(value);
          if(Get.isDialogOpen == true) Get.back();
          Get.until((route) => route.settings.name == '/CheckOutScreen');
        }else{
          if(subscription == 1){
            await Get.find<SubscriptionCheckoutController>().updateShippingMethod(value);
            if(Get.isDialogOpen == true) Get.back();
            Get.until((route) => route.settings.name == '/PartnerProductSubscriptionCheckoutScreen');
          }else if(subscription == 2){
            await Get.find<SubscriptionCheckoutUpdateController>().updateShippingMethod(value);
            if(Get.isDialogOpen == true) Get.back();
            Get.until((route) => route.settings.name == '/PartnerProductSubscriptionUpdateCheckoutScreen');
          }

        }
      }
    }
  }

  Future<TimeOfDay?> _showCustomTimePicker(
    int initH, int initM,
    int startH, int startM, int endH, int endM
  ) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initH, minute: initM),
      // anchorPoint: ,
      // selectableTimePredicate: (TimeOfDay? tempData){
      //   if(tempData == null){
      //     return false;
      //   }else{
      //     if(tempData.hour < startH || tempData.hour > endH){
      //       return false;
      //     }else{
      //       return tempData.minute % 5 == 0;
      //     }
      //   }
      // },
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if(time == null){
      return null;
    }else {
      bool res = true;
      if(time.hour < startH || time.hour > endH){
        res = false;
      }else if(time.hour == startH && time.minute < startM){
        res = false;
      }else if(time.hour == endH && time.minute > endM){
        res = false;
      }
      if(res){
        return time;
      }else{
        await ShowDialog.showForceDialog(
          lController.getLang('Wrong Time'),
          '${lController.getLang("text_pick_up_1")}\n'
            +startH.toString().padLeft(2, '0')
            +':'+startM.toString().padLeft(2, '0')
            +' - '
            +endH.toString().padLeft(2, '0')
            +':'+endM.toString().padLeft(2, '0'),
          (){
            Get.back();
            return _showCustomTimePicker(
              initH, initM, startH, startM, endH, endM
            );
          }
        );
        return null;
      }
    }
  }
}
