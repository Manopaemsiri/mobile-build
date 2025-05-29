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
  final CustomerController _customerController = Get.find<CustomerController>();

  List<PartnerShippingFrontendModel> _data = [];

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
        _data = [];
      });
    }
    loadData();
  }

  Future<void> loadData() async {
    if (!isEnded && !isLoading) {
      try {
        page += 1;
        if(mounted) setState(() => isLoading = true);
        String _endpoint = 'checkout-click-and-collect-shipping-methods';
        if(subscription != null){
          if(subscription ==1){
            _endpoint = 'subscription-click-and-collect-shipping-methods';
          }else if(subscription == 2){
            // _endpoint = 'subscription-click-and-collect-shipping-methods';
          }
        }

        final res = await ApiService.processList(
          _endpoint, input: {
          "paginate": {"page": page, "pp": 10},
        });
        PaginateModel? paginateModel = res?["paginate"] != null? PaginateModel.fromJson(res?["paginate"]): null;

        var len = res?["result"].length;
        for (var i = 0; i < len; i++) {
          PartnerShippingFrontendModel model = PartnerShippingFrontendModel.fromJson(res?["result"][i]);
          _data.add(model);
        }
        if(mounted){
          setState(() {
            _data;
            if (_data.length >= (paginateModel?.total ?? 0)) {
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
            _data = [];
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
      body: isEnded && _data.isEmpty && !isLoading
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
              _data.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                shrinkWrap: true,
                itemCount: _data.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  PartnerShippingFrontendModel d = _data[index];

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
    List<WorkingHourModel> _whs = value.shop?.workingHours ?? [];
    Map<String, Map<String, int>> _cwhs = {};
    for(int j=0; j<7; j++){
      int _j = _whs.indexWhere((x) => x.dayIndex == j && x.isOpened == 1);
      if(_j >= 0){
        WorkingHourModel _wh = _whs[_j];
        _cwhs["$j"] = {
          "startH": int.parse(_wh.startTime!.substring(0, 2)),
          "startM": int.parse(_wh.startTime!.substring(3, 5)),
          "endH": int.parse(_wh.endTime!.substring(0, 2)),
          "endM": int.parse(_wh.endTime!.substring(3, 5)),
        };
      }
    }
    
    DateTime _now = DateTime.now();
    DateTime _today = DateTime(_now.year, _now.month, _now.day);
    List<DateTime> _dates = [];
    for(int i=0; i<31; i++){
      DateTime _d = DateTime(_now.year, _now.month, _now.day+i);
      Map<String, int>? _t = _cwhs["${_d.weekday % 7}"];
      if(_t != null){
        if(i != 0){
          _dates.add(_d);
        }else{
          int _nh = _now.hour + 1;
          if(_nh < _t["endH"]! || (_nh == _t["endH"] && _now.minute < _t["endM"]!)){
            _dates.add(_d);
          }
        }
      }
    }

    DateTime? _selectedDate = await showDatePicker(
      context: context, 
      initialDate: _dates.first, 
      firstDate: _dates.first, 
      lastDate: _dates.last,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      selectableDayPredicate: (DateTime _d){
        return _dates.contains(_d);
      }
    );
    if(_selectedDate != null){
      bool _isSameDay = _today == _selectedDate;

      Map<String, int>? _t = _cwhs["${_selectedDate.weekday % 7}"];
      int _startH = _t?["startH"] ?? 0;
      int _startM = _t?["startM"] ?? 0;
      int _endH = _t?["endH"] ?? 0;
      int _endM = _t?["endM"] ?? 0;

      int _initH = _startH;
      int _initM = _startM;
      if(_isSameDay){
        _initH = _now.hour + 1;
        _initM = (_now.minute / 5).ceil() * 5;
        _startH = _initH;
        _startM = _initM;
        if(_startM >= 60){
          _initH += 1;
          _initM = 0;
          _startH += 1;
          _startM = 0;
        }
      }

      TimeOfDay? _selectedTime = await _showCustomTimePicker(
        _initH, _initM, _startH, _startM, _endH, _endM
      );
      if(_selectedTime != null) {
        ShowDialog.showLoadingDialog();
        value.pickupDate = _selectedDate;
        value.pickupTime = _selectedTime.hour.toString().padLeft(2, '0')
          +':'+_selectedTime.minute.toString().padLeft(2, '0');

        if(subscription == null){
          _customerController.setDiscountShipping(null, needUpdate: true);
          await _customerController.updateCartShop(value.shop?.id ?? '', needLoading: false);
          await _customerController.setShippingMethod(value);
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
    int _initH, int _initM,
    int _startH, int _startM, int _endH, int _endM
  ) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _initH, minute: _initM),
      // anchorPoint: ,
      // selectableTimePredicate: (TimeOfDay? _d){
      //   if(_d == null){
      //     return false;
      //   }else{
      //     if(_d.hour < _startH || _d.hour > _endH){
      //       return false;
      //     }else{
      //       return _d.minute % 5 == 0;
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
      if(time.hour < _startH || time.hour > _endH){
        res = false;
      }else if(time.hour == _startH && time.minute < _startM){
        res = false;
      }else if(time.hour == _endH && time.minute > _endM){
        res = false;
      }
      if(res){
        return time;
      }else{
        await ShowDialog.showForceDialog(
          lController.getLang('Wrong Time'),
          '${lController.getLang("text_pick_up_1")}\n'
            +_startH.toString().padLeft(2, '0')
            +':'+_startM.toString().padLeft(2, '0')
            +' - '
            +_endH.toString().padLeft(2, '0')
            +':'+_endM.toString().padLeft(2, '0'),
          (){
            Get.back();
            return _showCustomTimePicker(
              _initH, _initM, _startH, _startM, _endH, _endM
            );
          }
        );
        return null;
      }
    }
  }
}
