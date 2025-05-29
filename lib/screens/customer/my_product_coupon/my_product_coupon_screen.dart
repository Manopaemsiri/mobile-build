import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/customer/my_product_coupon/controller/controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/styles.dart';
import '../../../config/themes/colors.dart';
import '../../../config/themes/typography.dart';
import '../../../models/customer_tier_model.dart';
import '../../../models/file_model.dart';
import '../../../models/partner_product_coupon_model.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/device_utils.dart';
import '../../../utils/formater.dart';

class MyProductCouponScreen extends StatelessWidget {
  MyProductCouponScreen({
    super.key,
    required this.id
  });
  final String id;
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<MyProductCouponController>(
      init: MyProductCouponController(id),
      builder: (controller) {
        
        return Scaffold(
          appBar: _buildAppBar(controller),
          body: widgetBody(controller),
        );
      },
    );
  }

  AppBar _buildAppBar(MyProductCouponController controller) {

    return AppBar(
      title: Text(
        controller.data?.name ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
  
  widgetBody(MyProductCouponController controller) {
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
  _buildBody(MyProductCouponController controller) {
    final PartnerProductCouponModel data = controller.data!;
    final List<CustomerTierModel> customerTiers = controller.customerTiers;

    String dataDate = lController.getLang("text_valid_until").replaceFirst("_VALUE_", dateFormat(data.endAt ?? DateTime.now()));
    String widgetContent = data.description == ''
      ? data.shortDescription: data.description;

    List<CustomerTierModel> forCustomerTiers = data.forCustomerTiers;

    const double widgetFlex = 2.5;
    final double screenwidth = DeviceUtils.getDeviceWidth();
    final double cardWidth = screenwidth / widgetFlex;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data.image != null
          ? Carousel(
            images: <FileModel>[ data.image! ],
            aspectRatio: 16 / 10,
            viewportFraction: 1,
            margin: 0,
            radius: const BorderRadius.all(Radius.circular(0)),
            isPopImage: true,
          ) 
          : const SizedBox.shrink(),
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
                if(data.isPersonal == 1 && data.status == 1)...[
                  Text(
                    dataDate,
                    style: subtitle1.copyWith(
                      color: kDarkColor,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
                Text(
                  data.displayType(lController)
                    + (data.displayDiscount(lController, trimDigits: true).isNotEmpty 
                      ? ' '+data.displayDiscount(lController, trimDigits: true): ''),
                  style: title.copyWith(
                    color: kAppColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
                
                if(widgetContent != '') ...[
                  const Gap(gap: kOtGap),
                  Text(
                    widgetContent,
                    style: subtitle1.copyWith(
                      color: kDarkColor
                    ),
                  ),
                ],
              
                const SizedBox(height: kHalfGap),
              ],
            )
          ),

          if(data.forAllCustomerTiers == 0 && forCustomerTiers.isNotEmpty) ...[
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
                children: forCustomerTiers.map((d) {

                  if (d.status == 0) {
                    return const SizedBox.shrink();
                  } else {
                    return CardGeneral(
                      width: cardWidth,
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
                      width: cardWidth,
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