import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/frontend_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/shopping_cart/read.dart';
import 'package:coffee2u/screens/home/components/app_bar_home.dart';
import 'package:coffee2u/screens/home/components/banner_carousel.dart';
import 'package:coffee2u/screens/home/components/list_categories.dart';
import 'package:coffee2u/screens/home/components/list_cms_contents.dart';
import 'package:coffee2u/screens/home/components/list_discount_products.dart';
import 'package:coffee2u/screens/home/components/list_featured_products.dart';
import 'package:coffee2u/screens/home/components/list_new_products.dart';
import 'package:coffee2u/screens/home/components/list_partner_product_coupons.dart';
import 'package:coffee2u/screens/home/components/list_partner_shipping_coupons.dart';
import 'package:coffee2u/screens/home/components/popup_carousel.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../partner/subscription/list.dart';
import 'controllers/category_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.showPopup = true});
  final bool showPopup;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppController _appController = Get.find<AppController>();
  final FrontendController _frontendController = Get.find<FrontendController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  final LanguageController lController = Get.find<LanguageController>();
  late bool showPopup = widget.showPopup;

  @override
  void initState() {
    _initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _frontendController.productCategoriesStatus.addListener(() {
        if (_frontendController.productCategoriesStatus.value == true) {
          Get.put(CategoryController());
          Get.find<CategoryController>().refreshController();
        }
      });
    });
    super.initState();
  }
  @override
  dispose() {
    super.dispose();
  }
  _initState() async {
    await Future.wait([
      _frontendController.refreshHomepage(needUpdate: false),
      _popupContent(),
    ]);
  }
  Future<void> getRefresh() async {
    await Future.wait([
      _appController.refreshData(),
      _frontendController.refreshHomepage(needUpdate: false),
      _customerController.readCart(needLoading: false),
      _popupContent(),
    ]);
  }
  Future<void> _popupContent() async {
    var res = await ApiService.processList('cms-popups');
    if(res != null && res['result'] != null) {
      List<CmsPopupModel> temp = [];
      for(int i=0; i<res['result'].length; i++){
        CmsPopupModel d = CmsPopupModel.fromJson(res['result'][i]);
        temp.add(d);
      }
      if(mounted) if(temp.isNotEmpty && showPopup) _dialogPopup(context, temp);
    }
  }

  Future<void> _dialogPopup(BuildContext context, List<CmsPopupModel> popup) {
    double popupRatio = 13 / 10;
    double maxWidth = Get.width > 500? 500: (Get.width - 2.5*kGap)*popupRatio;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            vertical: kGap, horizontal: 1*kGap,
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(
                  kQuarterGap, kQuarterGap, kQuarterGap, 0,
                ),
                width: maxWidth,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: maxWidth,
                          child: PopupCarousel(
                            popupModels: popup,
                            aspectRatio: 1 / popupRatio,
                            margin: kQuarterGap,
                            radius: const BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        Positioned(
                          top: kHalfGap,
                          right: kHalfGap,
                          child: Container(
                            width: 1.75 * kGap,
                            height: 1.75 * kGap,
                            decoration: BoxDecoration(
                              color: kGrayColor,
                              borderRadius: BorderRadius.circular(0.875 * kGap),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              color: kWhiteColor,
                              iconSize: 1.75 * kGap,
                              icon: const Icon(Icons.cancel),
                              onPressed: () => Get.back(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> onRefresh() async {
    showPopup = true;
    getRefresh();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBarHome(lController: lController,),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Gap(),
              GetBuilder<FrontendController>(builder: (controller) {
                return FutureBuilder<Map<String, dynamic>?>(
                  future: controller.banners,
                  builder: (context, snapshot) {
                    List<CmsBannerModel> items = [];

                    if(snapshot.hasData){
                      var len = snapshot.data!['result'].length;
                      for(var i=0; i<len; i++){
                        CmsBannerModel model = CmsBannerModel
                          .fromJson(snapshot.data!['result'][i]);
                        items.add(model);
                      }

                      if(items.isEmpty){
                        return const SizedBox.shrink();
                      }else{
                        return BannerCarousel(
                          cmsBannerModel: items,
                          aspectRatio: 16 / 10,
                        );
                      }
                    } else {
                      return Column(
                        children: const [
                          AspectRatio(
                            aspectRatio: 16 / 8.5,
                            child: Center(
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 22.4),
                        ],
                      );
                    }
                  },
                );
              }),

              const ListCategories(),

              GetBuilder<AppController>(
                builder: (_appController1) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(_appController1.settings(key: 'APP_MODULE_PARTNER_SUBSCRIPTION') == '1')...[
                        const Gap(),
                        FutureBuilder<Map<String, dynamic>?>(
                          future: ApiService.processRead("cms-content", input: { 'url': 'partner-product-subscriptions' }),
                          builder: (buildContext, asyncSnapshot) {
                            if(asyncSnapshot.connectionState == ConnectionState.done) {
                              if(asyncSnapshot.hasData) {
                                final subscription = asyncSnapshot.data;
                                CmsContentModel? model;
                                try { model = CmsContentModel.fromJson(subscription?["result"]); } catch (_) { }

                                return model?.isValid() == true
                                ? Container(
                                  margin: const EdgeInsets.symmetric(horizontal: kGap),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(kRadius)
                                  ),
                                  child: InkWell(
                                    onTap: () => Get.to(() => PartnerProductSubscriptionsScreen(lController: lController)),
                                    child: AspectRatio(
                                      aspectRatio: 16/9,
                                      child: ImageUrl(
                                        imageUrl: model?.image?.path ?? '',
                                      )
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink();
                              }else {
                                return const SizedBox.shrink();
                              }
                            }
                            return const SizedBox.shrink();
                          }
                        ),
                      ],
                    ],
                  );
                }
              ),

              // New Product
              ListNewProducts(
                lController: lController,
                customerController: _customerController,
                aController: _appController,
                showStock: _customerController.isShowStock(),
              ),
              
              // Discount Product
              ListDiscountProducts(
                lController: lController,
                customerController: _customerController, 
                aController: _appController,
                showStock: _customerController.isShowStock(),
              ),

              // Featured Product
              ListFeaturedProducts(
                lController: lController,
                customerController: _customerController,
                aController: _appController,
                showStock: _customerController.isShowStock(),
              ),

              ListPartnerProductCoupons(),
              ListPartnerShippingCoupons(),
              const ListCmsContents(),
              // if(_appController.enabledMultiCustomerShops) ...[
              //   const SizedBox(height: kGap + kQuarterGap),
              //   SectionTitle(
              //     titleText: lController.getLang("Coffee Shop Near Me"),
              //     padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, 0),
              //   ),
              //   const Padding(
              //     padding: EdgeInsets.only(top: kGap-kHalfGap),
              //     child: ListRelatedServices(),
              //   )
              // ],
              const Gap(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: kGap),
              child: GetBuilder<CustomerController>(
                builder: (controller) {
                  int count = controller.countCartProducts();
                  return count > 0 
                    ? IgnorePointer(
                      ignoring: false,
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 450),
                        child: FloatingActionButton(
                          elevation: 1,
                          focusElevation: 1,
                          hoverElevation: 1,
                          highlightElevation: 1,
                          backgroundColor: kAppColor,
                          foregroundColor: kWhiteColor,
                          focusColor: kAppColor,
                          hoverColor: kAppColor,
                          splashColor: kAppColor,
                          onPressed: () async {
                            await controller.readCart();
                            Get.to(() => const ShoppingCartScreen());
                          },
                          child: Stack(
                            children: [
                              const Padding(
                                padding: kPadding,
                                child: Icon(Icons.shopping_cart_rounded),
                              ),
                              Positioned(
                                top: kQuarterGap,
                                right: kHalfGap,
                                child: BadgeCircle(
                                  title: count.toString(),
                                  size: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    : const SizedBox.shrink();
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: apiUrl != "https://api.aromacoffee2u.com/" && devProcess
            ? Container(
              margin: const EdgeInsets.only(left: kGap),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: kWhiteColor,
                  borderRadius: BorderRadius.circular(kRadius)
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: kHalfGap),
                decoration: BoxDecoration(
                  color: kAppColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(kRadius)
                ),
                child: Text(
                  'Dev',
                  style: title.copyWith(
                    color: kAppColor
                  ),
                ),
              ),
            )
            : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}