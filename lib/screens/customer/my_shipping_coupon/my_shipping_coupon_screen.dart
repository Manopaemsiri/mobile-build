import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/my_shipping_coupon/controller/controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/styles.dart';
import '../../../config/themes/colors.dart';
import '../../../config/themes/typography.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/device_utils.dart';
import '../../../utils/formater.dart';

class MyShippingCouponScreen extends StatelessWidget {
  MyShippingCouponScreen({
    super.key,
    required this.id
  });
  final String id;
  LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<MyShippingCouponController>(
      init: MyShippingCouponController(id),
      builder: (controller) {
        
        return Scaffold(
          appBar: _buildAppBar(controller),
          body: _body(controller),
        );
      },
    );
  }

  AppBar _buildAppBar(MyShippingCouponController controller) {

    return AppBar(
      title: Text(
        controller.data?.name ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
  
  _body(MyShippingCouponController controller) {
    if(controller.status == StateStatus.Success) {
      if(controller.data == null){
        return NoDataCoffeeMug();
      }else {
        return _buildBody(controller);
      }
    }else if(controller.status == StateStatus.Error) {
      return NoDataCoffeeMug(titleText: controller.errorMsg);
    }
    return Loading();
  }
  _buildBody(MyShippingCouponController controller) {
    final PartnerShippingCouponModel data = controller.data!;
    final List<CustomerTierModel> customerTiers = controller.customerTiers;

    String _date = lController.getLang("text_valid_until").replaceFirst("_VALUE_", dateFormat(data.endAt ?? DateTime.now()));
    String _content = data.description == ''
      ? data.shortDescription: data.description;

    List<CustomerTierModel> _forCustomerTiers = data.forCustomerTiers;

    const double _flex = 2.5;
    final double _screenwidth = DeviceUtils.getDeviceWidth();
    final double _cardWidth = _screenwidth / _flex;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data.image != null
          ? const SizedBox.shrink()
          : Carousel(
            images: <FileModel>[ data.image! ],
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
                    data.name,
                    style: headline5.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.4
                    ),
                  ),
                ),
                
                const Gap(gap: kOtGap),
                Text(
                  _date,
                  style: subtitle1.copyWith(
                    color: kDarkColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  '${lController.getLang("Shipping discount")} ${data.displayDiscount(lController, trimDigits : true)}',
                  style: title.copyWith(
                    color: kAppColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
                
                if(_content != '') ...[
                  const Gap(gap: kOtGap),
                  Text(
                    _content,
                    style: subtitle1.copyWith(
                      color: kDarkColor
                    ),
                  ),
                ],
              
                const SizedBox(height: kHalfGap),
              ],
            )
          ),
          if(data.shippings.isNotEmpty) ...[
            const Gap(gap: kHalfGap),
            SectionTitle(
              titleText: lController.getLang("Related Shipping Methods"),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: kGap-2),
              child: Wrap(
                spacing: 0,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: data.shippings.map((d) {

                  if (d.status == 0) {
                    return const SizedBox.shrink();
                  } else {
                    return CardGeneral(
                      width: _cardWidth,
                      titleText: d.displayName,
                      image: d.icon?.path ?? "",
                      boxFit: BoxFit.contain,
                      maxLines: 2,
                    );
                  }
                }).toList(),
              )
            ),
            const Gap(gap: kGap),
          ],
          if(data.forAllCustomerTiers == 0 && _forCustomerTiers.isNotEmpty) ...[
            const Gap(gap: kHalfGap),
            SectionTitle(
              titleText: lController.getLang("Promotional Customer Tiers"),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: kGap-2),
              child: Wrap(
                spacing: 0,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: _forCustomerTiers.map((d) {

                  if (d.status == 0) {
                    return const SizedBox.shrink();
                  } else {
                    return CardGeneral(
                      width: _cardWidth,
                      titleText: d.name,
                      image: d.icon?.path ?? "",
                    );
                  }
                }).toList(),
              )
            ),
            const Gap(gap: kGap),
          ],
          if(data.forAllCustomerTiers == 1 && customerTiers.isNotEmpty) ...[
            const Gap(gap: kHalfGap),
            SectionTitle(
              titleText: lController.getLang("Promotional Customer Tiers"),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: kGap-2),
              child: Wrap(
                spacing: 0,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: customerTiers.map((d) {

                  if (d.status == 0) {
                    return const SizedBox.shrink();
                  } else {
                    return CardGeneral(
                      width: _cardWidth,
                      titleText: d.name,
                      image: d.icon?.path ?? "",
                    );
                  }
                }).toList(),
              )
            ),
            const Gap(gap: kGap),
          ],
    
        ],
      ),
    );
  }
}