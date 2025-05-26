import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';


class PointRewardsScreen extends StatefulWidget {
  const PointRewardsScreen({
    Key? key,
  }): super(key: key);

  @override
  State<PointRewardsScreen> createState() => _PointRewardsScreenState();
}

class _PointRewardsScreenState extends State<PointRewardsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  List<CustomerPointModel> _data = [];

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

        ApiService.processList("points", input: {
          "paginate": { "page": page, "pp": 10 },
        }).then((value) {
          PaginateModel paginateModel = PaginateModel.fromJson(value?["paginate"]);
          var len = value?["result"].length;
          for (var i = 0; i < len; i++) {
            CustomerPointModel model = CustomerPointModel.fromJson(value!["result"][i]);
            _data.add(model);
          }

          setState(() {
            _data;
            if (_data.length >= paginateModel.total!) {
              isEnded = true;
              isLoading = false;
            } else if (value != null) {
              isLoading = false;
            }
          });
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
      itemCount: 1,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: double.infinity,
          height: 118,
          child: Center(
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang("Point Reward")),
        bottom: const AppBarDivider(),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: onRefresh,
            color: kAppColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _data.isEmpty
                    ? const SizedBox(height: 0)
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        CustomerPointModel item = _data[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: kPadding,
                              color: kWhiteColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      item.displayType(),
                                      Text(
                                        dateFormat(
                                          item.createdAt ?? DateTime.now(),
                                          format: 'dd/MM/y kk:mm'
                                        ),
                                        style: caption.copyWith(
                                          color: kGrayColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: kHalfGap),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: kHalfGap),
                                        child: Text(
                                          item.displayDescription(lController),
                                          style: subtitle1.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: kDarkLightColor
                                          ),
                                        ),
                                      ),
                                      item.displayPoints(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 0.7, thickness: 0.7),
                          ],
                        );
                      },
                    ),
                  isEnded
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: kGap, bottom: kGap),
                        child: Text(
                          lController.getLang("No more data"),
                          textAlign: TextAlign.center,
                          style: title.copyWith(
                            fontWeight: FontWeight.w500,
                            color: kGrayColor
                          ),
                        ),
                      ),
                    )
                    : VisibilityDetector(
                      key: const Key('loader-widget'),
                      onVisibilityChanged: onLoadMore,
                      child: loaderWidget()
                    ),
                  const SizedBox(height: kGap),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}