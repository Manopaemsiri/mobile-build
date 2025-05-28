import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/product_coupon/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';


class PartnerProductCouponsScreen extends StatefulWidget {
  const PartnerProductCouponsScreen({
    super.key
  });

  @override
  State<PartnerProductCouponsScreen> createState() => _PartnerProductCouponsScreenState();
}

class _PartnerProductCouponsScreenState extends State<PartnerProductCouponsScreen> {
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

        ApiService.processList("partner-product-coupons", input: {
          "paginate": { "page": page, "pp": 10 }
        }).then((value) {
          PaginateModel paginateModel =
              PaginateModel.fromJson(value?["paginate"]);

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

  Widget loaderWidget() =>
    const ShimmerCmsList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lController.getLang("Promotional Product Coupons")
        ),
        bottom: const AppBarDivider(),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: onRefresh,
            color: kAppColor,
            child: SingleChildScrollView(
              padding: kPadding,
              child: Column(
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
                          onPressed: () => Get.to(() => PartnerProductCouponScreen(id: item.id!)),
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
              )
            ),
          ),
        ],
      ),
    );
  }
}
