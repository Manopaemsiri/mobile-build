import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/seller/shop/components/dialog_review.dart';
import 'package:coffee2u/screens/seller/shop/components/seller_shop_info.dart';
import 'package:coffee2u/screens/seller/shop/components/seller_shop_reviews.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SellerShopScreen extends StatefulWidget {
  const SellerShopScreen({
    super.key,
    required this.shopId,
    this.lat,
    this.lng
  });

  final String shopId;
  final double? lat;
  final double? lng;

  @override
  State<SellerShopScreen> createState() => _SellerShopScreenState();
}

class _SellerShopScreenState extends State<SellerShopScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  bool isLoading = true;
  SellerShopModel? model;
  List<TabBarModel> tabList = [];

  _initState() async {
    var res = await ApiService.processRead(
      'seller-shop', input: {
        "_id": widget.shopId, "lat": widget.lat, "lng": widget.lng
      }
    );
    if(res!["result"] != null){
      SellerShopModel item = SellerShopModel.fromJson(res["result"]);
      setState(() {
        model = item;
        tabList = [
          TabBarModel(
            titleText: lController.getLang("Shop Info"),
            body: SellerShopInfo(model: item),
          ),
          TabBarModel(
            titleText: lController.getLang("seller shop reviews"),
            body: SellerShopReviews(model: item),
          ),
        ];
      });
    }
    setState(() {
      isLoading = false;
    });
  }
  
  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    
    List<FileModel> _gallery = [];
    if(model?.image != null && model?.image?.path != null){
      _gallery.add(model?.image as FileModel);
    }
    if(model?.logo != null && model?.logo?.path != null){
      _gallery.add(model?.logo as FileModel);
    }
    if(model?.gallery != null){
      model?.gallery?.forEach((f){
        if(f.path != null) _gallery.add(f);
      });
    }

    return isLoading || model == null || tabList.isEmpty
      ? Scaffold(
        appBar: AppBar(
          title: const Text(''),
          elevation: 0,
        ),
        body: isLoading
          ? Loading()
          : NoDataCoffeeMug(), 
      )
      : DefaultTabController(
        length: tabList.length,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: kWhiteColor,
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    expandedHeight: (Get.width - 2*kGap) * 9/16 + 4*kGap,
                    floating: false,
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    title: Text(
                      model!.name,
                      style: const TextStyle(
                        color: kDarkColor,
                        height: 1.2,
                      ),
                    ),
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        return FlexibleSpaceBar(
                          background: Column(
                            children: [
                              SizedBox(height: appBarHeight),
                              Padding(
                                padding: const EdgeInsets.only(left: kOtGap, right: kOtGap),
                                child: Carousel(
                                  images: _gallery,
                                  aspectRatio: 16 / 8,
                                  viewportFraction: 1,
                                  margin: kQuarterGap,
                                  isPopImage: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: SectionHeaderDelegate(
                    height: 52,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorWeight: 4,
                          indicatorColor: kAppColor,
                          labelColor: kAppColor,
                          unselectedLabelColor: kGrayColor,
                          tabs: TabBarModel.getTabBar(tabList),
                        ),
                        const Divider(height: 1, thickness: 2),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: TabBarModel.getTabBarView(tabList)
            ),
          ),
          bottomNavigationBar: Padding(
            padding: kPaddingSafeButton,
            child: ButtonFull(
              title: lController.getLang("Review"),
              icon: const Icon(Icons.reviews_rounded, size: 20),
              onPressed: _onTapReview,
            ),
          ),
        ),
    );
  }

  void _onTapReview() async {
    SellerShopRatingModel rating = SellerShopRatingModel(rating: 5);
    var res = await ApiService.processRead(
      'seller-shop-rating',
      input: { "sellerShopId": model!.id }
    );
    if(res!["result"] != null && res["result"]["_id"] != null){
      rating = SellerShopRatingModel.fromJson(res["result"]);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, kHalfGap),
          content: DialogReview(
            shopId: widget.shopId,
            model: rating
          ),
        );
      },
    );
  }
}