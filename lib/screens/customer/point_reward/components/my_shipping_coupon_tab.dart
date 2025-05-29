import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:get/get.dart';

import '../../my_shipping_coupon/my_shipping_coupon_screen.dart';

class MyShippingCouponTab extends StatefulWidget {
  const MyShippingCouponTab({
    super.key,
  });

  @override
  State<MyShippingCouponTab> createState() => _MyShippingCouponTabState();
}

class _MyShippingCouponTabState extends State<MyShippingCouponTab> {
  final LanguageController lController = Get.find<LanguageController>();
  List<PartnerShippingCouponLogModel> dataModel = [];

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

        final res = await ApiService.processList(
          "my-partner-shipping-coupon-logs",
          input: {
            "paginate": { "page": page, "pp": 10 },
            "dataFilter": { "isUsed": 0 },
          },
        );
        PaginateModel paginateModel = PaginateModel.fromJson(res?["paginate"]);

        var len = res?["result"].length;
        for (var i = 0; i < len; i++) {
          PartnerShippingCouponLogModel model = 
            PartnerShippingCouponLogModel.fromJson(res!["result"][i]);
          dataModel.add(model);
        }

        if(mounted){
          setState(() {
            dataModel;
            if (dataModel.length >= paginateModel.total!) {
              isEnded = true;
              isLoading = false;
            } else if (res != null) {
              isLoading = false;
            }
          });
        }
      } catch (e) {
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
    if (info.visibleFraction > 0 && !isEnded && !isLoading) {
      await loadData();
    }
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
        child: isEnded && dataModel.isEmpty
        ? SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center (
           child: NoDataCoffeeMug(),
          ), 
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            dataModel.isEmpty
            ? const SizedBox(height: 0)
            : ListView.builder(
              shrinkWrap: true,
              itemCount: dataModel.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                PartnerShippingCouponLogModel item = dataModel[index];
                PartnerShippingCouponModel coupon = dataModel[index].coupon!;

                return CardShippingCoupon2(
                  model: coupon,
                  onPressed: () => Get.to(() => MyShippingCouponScreen(
                    id: item.id!,
                  )),
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
              child: loaderWidget()
            ),
          ],
        ),
      ),
    );
  }
}
