import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/cms/content/components/html_content.dart';
import 'package:coffee2u/screens/cms/content/controller/cms_controller.dart';
import 'package:coffee2u/screens/customer/shopping_cart/read.dart';
import 'package:coffee2u/screens/partner/product/components/youtube_view.dart';
import 'package:coffee2u/screens/partner/product/read.dart';
import 'package:coffee2u/screens/partner/product_coupon/read.dart';
import 'package:coffee2u/screens/partner/search/read.dart';
// import 'package:coffee2u/screens/partner/shop/components/product_item.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double widgetFlex = 2.5;
final double screenwidth = DeviceUtils.getDeviceWidth();
final double cardWidth = screenwidth / widgetFlex;

class CmsContentScreen extends StatefulWidget {
  const CmsContentScreen({
    super.key,
    this.url,
    this.showCart = true,
    this.showTag = false,
    this.backTo,
  });
  final String? url;
  final bool showCart;
  final bool showTag;
  final String? backTo;

  @override
  State<CmsContentScreen> createState() => _CmsContentScreenState();
}

class _CmsContentScreenState extends State<CmsContentScreen> {
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CmsContentController>(
      init: CmsContentController(widget.url),
      builder: (cmsController) {
        if(cmsController.isReady && cmsController.data != null){
          
          return Scaffold(
            appBar: AppBar(
              title: Text(
                cmsController.data?.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            body: body1(cmsController.data!, cmsController.gallery, widget.showTag, cmsController),
            bottomNavigationBar: GetBuilder<CustomerController>(
              builder: (controller) {
                int count = controller.countCartProducts();
                return IgnorePointer(
                  ignoring: widget.showCart && count > 0? false: true,
                  child: Visibility(
                    visible: widget.showCart && count > 0? true: false,
                    child: Padding(
                      padding: kPaddingSafeButton,
                      child: ButtonOrder(
                        title: cmsController.lController.getLang("Basket"),
                        qty: count,
                        total: controller.cart.total,
                        onPressed: () async {
                          await controller.readCart();
                          if(widget.backTo != null){
                            Get.until((route) => Get.currentRoute == '/ShoppingCartScreen');
                          }else {
                            Get.to(() => const ShoppingCartScreen());
                          }
                        },
                        lController: cmsController.lController,
                        trimDigits: cmsController.trimDigits,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }else if(cmsController.isReady && cmsController.data == null){
          return Scaffold(
            appBar: AppBar(),
            body: NoData()
          );
        }
        return Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
  }

  Widget body1(CmsContentModel item, List<FileModel>? gallery, bool showTag, CmsContentController cmsController) {
    String dataDate = dateFormat(item.createdAt ?? DateTime.now(), format: 'dd/MM/y kk:mm');
    String widgetTitle = item.title;
    String widgetCategory = item.category?.title ?? '';
    String widgetYoutubeId = item.youtubeVideoId;
    String widgetContent = item.content;

    // List<PartnerShopModel> relatedPartnerShops = item.relatedPartnerShops;
    List<PartnerProductCategoryModel> relatedProductCategories = item.relatedPartnerProductCategories;
    List<PartnerProductModel> relatedProducts = item.relatedPartnerProducts;
    List<PartnerProductCouponModel> relatedProductCoupons = item.relatedPartnerProductCoupons;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gallery == null || gallery.isEmpty
            ? const SizedBox(height: 0)
            : Carousel(
              images: gallery,
              aspectRatio: 16 / 10,
              viewportFraction: 1,
              margin: 0,
              radius: const BorderRadius.all(Radius.circular(0)),
              isPopImage: true,
            ),
          Container(
            width: double.infinity,
            padding: kPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    widgetTitle,
                    style: headline5.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1
                    ),
                  ),
                ),
                if(showTag) ...[
                  const Gap(gap: kHalfGap),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonTextBackground(
                        title: widgetCategory,
                        size: 'small',
                        onTap: () {}
                      ),
                      Text(
                        dataDate,
                        style: subtitle2.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                if (widgetContent != '') ...[
                  const Gap(gap: kHalfGap),
                  HtmlContent(content: widgetContent)
                ],
                if(widgetYoutubeId != '') ...[
                  const Gap(gap: kGap + kHalfGap),
                  YoutubeView(
                    youtubeId: widgetYoutubeId,
                    backTo: Get.currentRoute,
                  ),
                  const Gap(gap: kHalfGap),
                ],
              ],
            )
          ),

          // if(cmsController.appController.enabledMultiPartnerShops && false) ...[
          //   if(relatedPartnerShops.isNotEmpty) ...[
          //     const Gap(gap: kHalfGap),
          //     SectionTitle(
          //       titleText: cmsController.lController.getLang("Related Shops"),
          //     ),
          //     SizedBox(
          //       height: 194.0,
          //       child: Container(
          //         alignment: Alignment.centerLeft,
          //         child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           shrinkWrap: true,
          //           itemCount: relatedPartnerShops.length,
          //           itemBuilder: (context, index) {
          //             final d = relatedPartnerShops[index];
                    
          //             if (d.status == 0) {
          //               return const SizedBox.shrink();
          //             } else {
          //               return Padding(
          //                 padding: EdgeInsets.only(
          //                   left: index == 0 ? kGap - 2 : 0,
          //                   right: index == relatedPartnerShops.length - 1? kGap - 2: 0
          //                 ),
          //                 child: CardShop(
          //                   width: cardWidth,
          //                   model: d,
          //                   showDistance: false,
          //                   onPressed: () => _onTapShop(d.id ?? ''),
          //                 ),
          //               );
          //             }
          //           },
          //         ),
          //       ),
          //     ),
          //     const Gap(gap: kGap),
          //   ],
          // ],

          if(relatedProductCategories.isNotEmpty) ...[
            const Gap(gap: kHalfGap),
            SectionTitle(
              titleText: cmsController.lController.getLang("Related Product Categories"),
            ),
            SizedBox(
              height: 148.0,
              child: Container(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: relatedProductCategories.length,
                  itemBuilder: (context, index) {
                    final d = relatedProductCategories[index];
                  
                    if (d.status == 0) {
                      return const SizedBox.shrink();
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? kGap - 2 : 0,
                            right: index == relatedProductCategories.length - 1
                                ? kGap - 2
                                : 0),
                        child: CardProductCategory(
                          width: cardWidth,
                          model: d,
                          onPressed: () => Get.to(() => SearchScreen(
                            initSearch: '#${d.name}', 
                            backTo: widget.backTo
                          )),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const Gap(gap: kGap),
          ],
          if(relatedProducts.isNotEmpty) ...[
            const Gap(gap: kHalfGap),
            SectionTitle(
              titleText: cmsController.lController.getLang("Related Products"),
            ),
            CardProductGrid(
              key: const ValueKey<String>("partner-products"),
              padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, 0),
              data: relatedProducts,
              customerController: cmsController.customerController,
              lController: cmsController.lController,
              aController: cmsController.appController,
              onTap: (d) => Get.to(() => ProductScreen(productId: d.id!, backTo: widget.backTo)),
              showStock: cmsController.customerController.isShowStock(),
              trimDigits: cmsController.trimDigits,
            ),
            const Gap(gap: kGap),
          ],
          
          if(relatedProductCoupons.isNotEmpty) ...[
            const Gap(gap: kHalfGap),
            SectionTitle(
              titleText: cmsController.lController.getLang("Related Product Coupons"),
              padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, 0),
            ),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kGap),
              child: Wrap(
                spacing: kHalfGap,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: relatedProductCoupons.map((item) {

                  return CardProductCoupon(
                    width: cardWidth,
                    model: item,
                    onPressed: () => Get.to(() => PartnerProductCouponScreen(id: item.id!)),
                  );
                }).toList(),
              )
            ),
            const Gap(gap: kGap),
          ],
        ],
      ),
    );
  }

  // _onTapShop(String shopId) {
  //   Get.to(
  //     () => PartnerShopScreen(shopId:shopId),
  //   );
  // }
}
