import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/seller/shop/components/seller_shop_item.dart';
import 'package:coffee2u/screens/seller/shop/read.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';


class TabNearBy extends StatefulWidget {
  const TabNearBy({
    super.key,
    this.lat,
    this.lng,
  });

  final double? lat;
  final double? lng;

  @override
  State<TabNearBy> createState() => _TabNearByState();
}

class _TabNearByState extends State<TabNearBy> {
  final LanguageController lController = Get.find<LanguageController>();
  List<SellerShopModel> _data = [];

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
      _data = [];
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

        ApiService.processList("seller-shops", input: {
          "paginate": {"page": page, "pp": 10},
          "dataFilter": {
            "lat": widget.lat,
            "lng": widget.lng,
          }
        }).then((value) {
          PaginateModel paginateModel = PaginateModel.fromJson(value?["paginate"]);

          var len = value?["result"].length;
          for (var i = 0; i < len; i++) {
            SellerShopModel model = SellerShopModel.fromJson(value!["result"][i]);
            _data.add(model);
          }

          if(mounted) {
            setState(() {
              _data;
              if (_data.length >= paginateModel.total!) {
                isEnded = true;
                isLoading = false;
              } else if (value != null) {
                isLoading = false;
              }
            });
          }
        });
      } catch (e) {}
    }
  }

  void onLoadMore(info) async {
    if (info.visibleFraction > 0 && !isEnded && !isLoading) {
      await loadData();
    }
  }

  Widget loaderWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Container(
              padding: kPadding,
              color: kWhiteColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: kLightColor, width: 0.5),
                      borderRadius: BorderRadius.circular(4),
                      color: kGrayLightColor,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0.7, thickness: 0.7),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        color: kAppColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _data.isEmpty
                ? const SizedBox(height: 0)
                : ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    SellerShopModel item = _data[index];
                    return SellerShopItem(
                      model: item,
                      onTap: () => Get.to(() => SellerShopScreen(
                        shopId: item.id ?? '',
                        lat: widget.lat,
                        lng: widget.lng
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
          )
        ),
      ),
    );
  }
}