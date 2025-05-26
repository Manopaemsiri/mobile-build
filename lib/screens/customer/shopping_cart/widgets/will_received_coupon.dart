import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/customer/shopping_cart/controller/will_received_coupons_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/partner_product_coupon_model.dart';

class WillReceivedCoupons extends StatelessWidget {
  const WillReceivedCoupons({
    Key? key,
    required this.data,
    required this.lController,
    this.onTap,
    this.couponTitle = "คูปองที่จะได้รับ",
  }) : super(key: key);
  final List<PartnerProductCouponModel> data;
  final Function(String)? onTap;
  final LanguageController lController;
  final String couponTitle;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<WillReceivedCouponsController>(
      init: WillReceivedCouponsController(data),
      builder: (controller) {

        return data.isNotEmpty 
        ? Column(
          children: [
            LayoutBuilder(
              builder: (buildContext, constraints) {
                double _cardHeight = (kHalfGap*2) + kQuarterGap + (bodyText2.fontSize!*2*1.4);
                double _cardWidth = constraints.maxWidth;
                double _aspectratio = _cardWidth/_cardHeight;

                return CarouselSlider.builder(
                  carouselController: controller.pageController,
                  itemBuilder: (BuildContext context, int index, int realIndex) =>
                    _body(controller.data[index], onTap),
                  itemCount: controller.data.length,
                  options: CarouselOptions(
                    autoPlay: false,
                    aspectRatio: _aspectratio,
                    viewportFraction: 1,
                    enableInfiniteScroll: controller.data.length > 1,
                    onPageChanged: (index, reason) => controller.onPageChanged(index),
                  ),
                );
              }
            ),
            if(controller.data.length > 1) ...[
              const Gap(gap: kHalfGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.data.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => controller.pageController.animateToPage(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 450),
                      width: controller.currentIndex == entry.key? 24: 10,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: kQuarterGap/2),
                      decoration: BoxDecoration(
                        color: controller.currentIndex == entry.key? kAppColor: const Color(0xFFF5CDCB),
                        borderRadius: BorderRadius.circular(kCardRadius)
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        )
        : const SizedBox.shrink();
      }
    );
  }

  Widget _body(PartnerProductCouponModel item, Function(String)? onTap) {
    final id = item.id ?? '';
    final imageUrl = item.image?.path ?? '';
    final name = item.name;
  
    return GestureDetector(
      onTap: onTap != null? () => onTap(id): null,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: kGap),
        decoration: BoxDecoration(
          color: kAppColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(kRadius)
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 66/44,
                child: ImageUrl(
                  imageUrl: imageUrl,
                  borderRadius:  BorderRadius.zero,
                ),
              ),
              const Gap(gap: kHalfGap),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: kHalfGap, horizontal: kHalfGap),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          lController.getLang(couponTitle),
                          maxLines: 1,
                          style: bodyText2.copyWith(
                            color: kAppColor,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      const Gap(gap: kQuarterGap),
                      Expanded(
                        child: Text(
                          '$name\n\n',
                          maxLines: 1,
                          style: bodyText2.copyWith(
                            color: kAppColor.withOpacity(0.7),
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}