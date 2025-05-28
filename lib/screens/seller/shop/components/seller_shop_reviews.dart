import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/seller/shop/components/review_body.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SellerShopReviews extends StatefulWidget {
  const SellerShopReviews({
    super.key,
    required this.model,
  });

  final SellerShopModel model;

  @override
  State<SellerShopReviews> createState() => _SellerShopReviewsState();
}

class _SellerShopReviewsState extends State<SellerShopReviews> {
  final LanguageController lController = Get.find<LanguageController>();
  Map<String, dynamic> _report = {};

  _initState() async {
    var res = await ApiService.processRead(
      'report-seller-shop-rating',
      input: { "_id": widget.model.id }
    );
    if(res!["result"] != null){
      Map<String, dynamic> _d = res["result"];
      setState(() {
        _report = {
          "count": int.parse(_d["count"].toString()),
          "averageRating": double.parse(_d["averageRating"].toString()),
          "totalRating1": int.parse(_d["totalRating1"].toString()),
          "totalRating2": int.parse(_d["totalRating2"].toString()),
          "totalRating3": int.parse(_d["totalRating3"].toString()),
          "totalRating4": int.parse(_d["totalRating4"].toString()),
          "totalRating5": int.parse(_d["totalRating5"].toString()),
        };
      });
    }
  }
  
  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: kPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            _report["count"] == null
                              ? '0 ${lController.getLang("Reviews")}'
                              : '${_report["count"]} ${lController.getLang("Reviews")}',
                            style: subtitle1.copyWith(
                              fontFamily: "CenturyGothic",
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          const SizedBox(height: kQuarterGap),
                          Text(
                            _report["averageRating"] == null || _report["averageRating"] == 0
                              ? 'N/A'
                              : numberFormat(_report["averageRating"], digits: 1),
                            style: headline2.copyWith(
                              fontFamily: "CenturyGothic",
                              fontWeight: FontWeight.w600,
                              letterSpacing: _report["averageRating"] == null || _report["averageRating"] == 0
                                ? -6: 0
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 1.5*kGap),
                      Expanded(
                        child: Column(
                          children: _report["count"] == null || _report["count"] == 0
                            ? [
                              _buildReviewStarProgress(5, 0, 0),
                              _buildReviewStarProgress(4, 0, 0),
                              _buildReviewStarProgress(3, 0, 0),
                              _buildReviewStarProgress(2, 0, 0),
                              _buildReviewStarProgress(1, 0, 0),
                            ]
                            : [
                              _buildReviewStarProgress(
                                5, _report["totalRating5"] / _report["count"],
                                _report["totalRating5"]
                              ),
                              _buildReviewStarProgress(
                                4, _report["totalRating4"] / _report["count"],
                                _report["totalRating4"]
                              ),
                              _buildReviewStarProgress(
                                3, _report["totalRating3"] / _report["count"],
                                _report["totalRating3"]
                              ),
                              _buildReviewStarProgress(
                                2, _report["totalRating2"] / _report["count"],
                                _report["totalRating2"]
                              ),
                              _buildReviewStarProgress(
                                1, _report["totalRating1"] / _report["count"],
                                _report["totalRating5"]
                              ),
                            ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0.7, thickness: 0.7),
                ReviewBody(model: widget.model),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStarProgress(double rating, double percent, int score) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          unratedColor: kLightColor,
          itemCount: 5,
          itemSize: 16,
        ),
        Expanded(
          child: LinearPercentIndicator(
            lineHeight: 6.0,
            percent: percent,
            barRadius: const Radius.circular(4),
            progressColor: Colors.amber,
            backgroundColor: kLightColor,
          ),
        ),
        const Gap(gap: kQuarterGap),
        Text("$score", style: caption),
      ],
    );
  }
}