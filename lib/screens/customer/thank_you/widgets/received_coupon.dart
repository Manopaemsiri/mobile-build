import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/received_coupons_controller.dart';

class ReceivedCoupons extends StatelessWidget {
  const ReceivedCoupons({
    super.key,
    required this.data,
    required this.onTap,
    required this.lController,
    this.isCOD = false,
  });
  final List<PartnerProductCouponLogModel> data;
  final Function(String) onTap;
  final LanguageController lController;
  final bool isCOD;
  

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceivedCouponsController>(
      init: ReceivedCouponsController(data),
      builder: (controller) {

        return Column(
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
            if(isCOD)...[
              const Gap(gap: kHalfGap),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  lController.getLang("Coupon will be valid after payment"),
                  style: caption.copyWith(
                    color: kRedColor,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ]
          ],
        );
      }
    );
  }

  Widget _body(PartnerProductCouponLogModel item, Function(String)? onTapValue) {
    final coupon = item.coupon;
    if(coupon == null) return const SizedBox.shrink();

    final imageUrl = coupon.image?.path ?? '';
    final id = item.id ?? '';
    final name = coupon.name;
  
    return GestureDetector(
      onTap: onTapValue != null? () => onTapValue(id): null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        // margin: const EdgeInsets.symmetric(horizontal: kGap),
        decoration: BoxDecoration(
          color: kAppColor.withValues(alpha: 0.1),
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
                          lController.getLang('congratulations you received the coupon'),
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
                            color: kAppColor.withValues(alpha: 0.7),
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