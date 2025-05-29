import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/product_coupon/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:get/get.dart';

class RedeemProductCouponTab extends StatefulWidget {
  const RedeemProductCouponTab({
    super.key,
    this.isCashCoupon = false,
  });

  final bool isCashCoupon;

  @override
  State<RedeemProductCouponTab> createState() => _RedeemProductCouponTabState();
}

class _RedeemProductCouponTabState extends State<RedeemProductCouponTab> {
  final LanguageController lController = Get.find<LanguageController>();
  List<PartnerProductCouponModel> dataModel = [];

  int page = 0;
  bool isLoading = false;
  bool isEnded = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> onRefresh() async {
    setState(() {
      page = 0;
      isLoading = false;
      isEnded = false;
      dataModel = [];
    });
    loadData();
  }

  Future<void> loadData() async {
    if (!isEnded && !isLoading) {
      try {
        page += 1;
        setState(() {
          isLoading = true;
        });

        ApiService.processList(
          "redeem-partner-product-coupons",
          input: {
            "paginate": { "page": page, "pp": 10 },
            "dataFilter": {
              "isCashCoupon": widget.isCashCoupon? 1: 0,
            },
          },
        ).then((value) {
          PaginateModel paginateModel = PaginateModel.fromJson(value?["paginate"]);

          var len = value?["result"].length;
          for (var i = 0; i < len; i++) {
            PartnerProductCouponModel model = 
              PartnerProductCouponModel.fromJson(value!["result"][i]);
            dataModel.add(model);
          }

          setState(() {
            dataModel;
            if (dataModel.length >= paginateModel.total!) {
              isEnded = true;
              isLoading = false;
            } else if (value != null) {
              isLoading = false;
            }
          });
        });
      } catch(_) {}
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
      ) 
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
            )
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
                      PartnerProductCouponModel item = dataModel[index];
                      return CardProductCoupon2(
                        model: item,
                        onPressed: () => Get.to(() => PartnerProductCouponScreen(
                          id: item.id!,
                          canRedeem: true,
                          queryParams: const { "isRedeemPoints": 1 }
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
