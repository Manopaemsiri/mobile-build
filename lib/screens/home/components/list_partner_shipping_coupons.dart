import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/frontend_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/shipping_coupon/list.dart';
import 'package:coffee2u/screens/partner/shipping_coupon/read.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double widgetFlex = 2.5;
final double screenwidth = DeviceUtils.getDeviceWidth();
final double cardWidth = screenwidth / widgetFlex;

class ListPartnerShippingCoupons extends StatelessWidget {
  ListPartnerShippingCoupons({
    super.key
  });

  final LanguageController lController = Get.find<LanguageController>();
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FrontendController>(builder: (controller) {
      return FutureBuilder<Map<String, dynamic>?>(
        future: controller.partnerShippingCoupons,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<PartnerShippingCouponModel> items = [];
              var len = snapshot.data!['result'].length;
              for (var i = 0; i < len; i++) {
                PartnerShippingCouponModel model =
                  PartnerShippingCouponModel.fromJson(snapshot.data!['result'][i]);
                items.add(model);
              }

              if (items.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: kGap + kQuarterGap),
                    SectionTitle(
                      titleText: lController.getLang("Promotional Shipping Coupons"),
                      isReadMore: true,
                      onTap: () => Get.to(() => const PartnerShippingCouponsScreen()),
                      padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, 0),
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kGap),
                      child: Wrap(
                        spacing: kHalfGap,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: items.map((item) {

                          return CardShippingCoupon(
                            width: cardWidth,
                            model: item,
                            onPressed: () => onTap(item.id ?? '')
                          );
                        }).toList(),
                      )
                    ),
                  ],
                );
              }
            } else {
              return const SizedBox.shrink();
            }
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return const ShimmerHorizontalProducts(isCmsCard: true);
          }
          return const SizedBox.shrink();
        }
      );
    });
  }

  onTap(String id) =>
    Get.to(() => PartnerShippingCouponScreen(id: id));
}