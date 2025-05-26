import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/cms/content/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CmsContentsScreen extends StatefulWidget {
  const CmsContentsScreen({
    Key? key, 
    this.category
  }) : super(key: key);
  final CmsCategoryModel? category;

  @override
  State<CmsContentsScreen> createState() => _CmsContentsScreenState();
}

class _CmsContentsScreenState extends State<CmsContentsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  List<CmsContentModel> _data = [];

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
        setState(() => isLoading = true);

        ApiService.processList("cms-contents", input: {
          "paginate": { "page": page, "pp": 10 },
          "dataFilter": { "categoryUrl": widget.category?.url }
        }).then((value) {
          PaginateModel paginateModel =
              PaginateModel.fromJson(value?["paginate"]);

          var len = value?["result"].length;
          for (var i = 0; i < len; i++) {
            CmsContentModel model =
                CmsContentModel.fromJson(value!["result"][i]);
            _data.add(model);
          }

          if(mounted){
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
      } catch (_) {}
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
        title: Text(widget.category?.title ?? lController.getLang('Contents')),
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
                  _data.isEmpty
                  ? const SizedBox(height: 0)
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        CmsContentModel item = _data[index];
                        return CardCmsContent2(
                          model: item,
                          onPressed: () => Get.to(() => CmsContentScreen(url: item.url)),
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
