import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:get/get.dart';

import '../../../../utils/formater.dart';
import '../../my_product_coupon/my_product_coupon_screen.dart';

class MyProductCouponTab extends StatefulWidget {
  const MyProductCouponTab({
    super.key,
    this.isCashCoupon = false,
  });

  final bool isCashCoupon;

  @override
  State<MyProductCouponTab> createState() => _MyProductCouponTabState();
}

class _MyProductCouponTabState extends State<MyProductCouponTab> {
  final LanguageController _lController = Get.find<LanguageController>();
  List<PartnerProductCouponLogModel> _data = [];

  int page = 0;
  bool isLoading = false;
  bool isEnded = false;

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
        final res = await ApiService.processList(
          "my-partner-product-coupon-logs",
          input: {
            "paginate": { "page": page, "pp": 10 },
            "dataFilter": {
              "isUsed": 0,
              "isCashCoupon": widget.isCashCoupon? 1: 0,
            },
          },
        );
        PaginateModel paginateModel = PaginateModel.fromJson(res?["paginate"]);

        var len = res?["result"].length;
        for (var i = 0; i < len; i++) {
          PartnerProductCouponLogModel model = 
            PartnerProductCouponLogModel.fromJson(res!["result"][i]);
          _data.add(model);
        }

        if(mounted){
          setState(() {
            _data;
            if (_data.length >= paginateModel.total!) {
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

  Widget loaderWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Loading(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: kAppColor,
      child: SingleChildScrollView(
        padding: kPadding,
        child: isEnded && _data.isEmpty
          ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: NoDataCoffeeMug(),
            )
          )
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _data.isEmpty
              ? const SizedBox(height: 0)
              : ListView.builder(
                shrinkWrap: true,
                itemCount: _data.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  PartnerProductCouponLogModel item = _data[index];
                  PartnerProductCouponModel coupon = _data[index].coupon!;
                  
                  return CardProductCoupon2(
                    model: coupon,
                    onPressed: () => Get.to(() => MyProductCouponScreen(
                      id: item.id!,
                    )),
                    expireDate: item.expiredAt != null
                      ? item.status > 0
                        ? _lController.getLang("Expires on").replaceFirst('_VALUE_', dateFormat(item.expiredAt!, format: 'dd/MM/y'))
                        : _lController.getLang("text_available_coupon_14")
                      : null,
                  );
                },
              ),
              isEnded
              ? Padding(
                padding: const EdgeInsets.only(top: kGap, bottom: kGap),
                child: Text(
                  _lController.getLang("No more data"),
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
                child: loaderWidget()
              ),
            ],
          ),
      ),
    );
  }
}
