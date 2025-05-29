import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/seller/shop/components/review_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';


class ReviewBody extends StatefulWidget {
  const ReviewBody({
    super.key,
    required this.model,
  });

  final SellerShopModel model;

  @override
  State<ReviewBody> createState() => _ReviewBodyState();
}

class _ReviewBodyState extends State<ReviewBody> {
  final LanguageController lController = Get.find<LanguageController>();
  final List<SellerShopRatingModel> dataModel = [];

  int page = 0;
  bool isLoading = false;
  bool isEnded = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    if (!isEnded && !isLoading) {
      try {
        page += 1;
        setState(() {
          isLoading = true;
        });

        ApiService.processList("seller-shop-ratings", input: {
          "paginate": { "page": page, "pp": 10 },
          "dataFilter": { "sellerShopId": widget.model.id }
        }).then((value) {
          PaginateModel paginateModel = PaginateModel.fromJson(value?["paginate"]);

          var len = value?["result"].length;
          for (var i = 0; i < len; i++) {
            SellerShopRatingModel model = SellerShopRatingModel.fromJson(value!["result"][i]);
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
    return const SizedBox(
      width: double.infinity,
      height: 200,
      child: Text(''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        dataModel.isEmpty
          ? const SizedBox.shrink()
          : ListView.builder(
            shrinkWrap: true,
            itemCount: dataModel.length,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              SellerShopRatingModel item = dataModel[index];
              return ReviewItem(
                model: item
              );
            },
          ),
        isEnded
          ? Padding(
            padding: const EdgeInsets.only(top: kGap, bottom: kGap),
            child: Text(
              dataModel.isEmpty? ''
                : lController.getLang("No more data"),
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
    );
  }
}