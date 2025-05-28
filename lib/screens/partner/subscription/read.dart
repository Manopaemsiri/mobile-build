import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/partner/subscription/create.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/index.dart';
import '../../../controller/app_controller.dart';
import '../../../models/index.dart';
import '../../../utils/formater.dart';
import '../../../widgets/carousel/carousel_gallery.dart';
import '../../../widgets/index.dart';
import '../../auth/sign_in/sign_in_menu_screen.dart';
import '../../cms/content/components/html_content.dart';
import 'controllers/subscription_controller.dart';
import 'widgets/card_package_product.dart';

class PartnerProductSubscriptionScreen extends StatelessWidget {
  const PartnerProductSubscriptionScreen({
    super.key,
    required this.id,
    this.subscribeButton = true,
    required this.lController,
  });
  final String id;
  final bool subscribeButton;
  final LanguageController lController;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<SubscriptionController>(
      init: SubscriptionController(id: id),
      builder: (controller) {

        Widget body = Center(child: Loading());
        if(controller.stateStatus == 1){
          body = widgetBody(controller.data);
        }else if(controller.stateStatus == 2){
          body = NoData();
        }else if(controller.stateStatus == 3){
          body = PageError();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              lController.getLang('Subscription Package'),
            )
          ),
          body: body,
          bottomNavigationBar: controller.stateStatus == 1 && controller.data?.isValid() && subscribeButton
          ? Padding(
            padding: kPaddingSafeButton,
            child: ButtonFull(
              title: lController.getLang(!Get.find<CustomerController>().isCustomer()? 'sign up': 'Choose Package'),
              onPressed: () => _onPressed(controller)
            ),
          ): const SizedBox.shrink(),
        );
      }
    );
  }

  Widget widgetBody(PartnerProductSubscriptionModel? data) {
    if(!data?.isValid()) return const SizedBox.shrink();
    final String name = data?.name ?? '';
    final String description = data?.description ?? '';
    final String content = data?.content ?? '';
    List<FileModel> widgetGallery = [];
    if(data?.image?.isValid() == true) widgetGallery.insert(0, data!.image!);
    if(data?.gallery?.isNotEmpty == true) widgetGallery.addAll(data!.gallery!);

    final String priceInVAT = priceFormat(data!.priceInVAT, lController, trimDigits: true);
    final String discountPriceInVAT = priceFormat(data.discountPriceInVAT, lController, trimDigits: true);
    final bool isDiscounted = data.isDiscounted() == true;
    final String discountPrice = priceFormat(data.priceInVAT, lController, trimDigits: true);
    
    final String contract = lController.getLang('text_subscription_contract')
      .replaceFirst('_VALUE_', '${data.recurringCount}')
      .replaceFirst('_VALUE2_', data.displayRecurringTypeName(lController));

    List<PartnerProductModel> dataProducts = data.packageProducts;

    return ListView(
      children: [
        if(widgetGallery.isNotEmpty)...[
          const Gap(),
          CarouselGallery(
            data: widgetGallery,
            viewportFraction: 1,
          ),
          const Gap(gap: kHalfGap),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kGap),
          child: Text(
            name,
            textAlign: TextAlign.start,
            style: headline5.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.4
            ),
          ),
        ),

       Padding(
        padding: const EdgeInsets.symmetric(horizontal: kGap) + const EdgeInsets.only(bottom: kHalfGap),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: isDiscounted ? discountPriceInVAT : priceInVAT,
                          style: headline5.copyWith(
                            color: const Color(0xFFC90E29), 
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        TextSpan(
                          text: ' / ${data.displayRecurringTypeName(lController)}',
                          style: subtitle1.copyWith(
                            color: kDarkColor,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        if (isDiscounted) ...[
                          const WidgetSpan(child: Gap(gap: kHalfGap)),
                          TextSpan(
                            text: discountPrice,
                            style: subtitle2.copyWith(
                              color: kDarkColor.withValues(alpha: 0.4),
                              fontFamily: 'Kanit',
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    contract,
                    style: subtitle2.copyWith(
                      color: kDarkColor,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ],
              ),
            ),
          ],
          ),
        ),

        if(description.isNotEmpty)...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGap),
            child: Text(
              description,
              style: subtitle2.copyWith(
                fontWeight: FontWeight.w400
              ),
            ),
          ),
          const Gap(gap: kHalfGap),
        ],

        if(content.isNotEmpty)...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGap),
            child: HtmlContent(content: content),
          ),
          const Gap(gap: kHalfGap,)
        ],
        

        if(dataProducts.isNotEmpty) ...[
          const Gap(gap: kHalfGap),
          SectionTitle(
            titleText: lController.getLang('Related Products'),
          ),
          CardPackageProduct(
            key: const ValueKey<String>('package-products'),
            padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, 0),
            data: dataProducts,
            customerController: Get.find<CustomerController>(),
            lController: lController,
            aController: Get.find<AppController>(),
            onTap: (_){},
            showStock: false,
          ),
          const Gap(gap: kHalfGap),
        ],
      ],
    );
  }

  _onPressed(SubscriptionController controller) {
    if(!Get.find<CustomerController>().isCustomer()){
      Get.to(() => const SignInMenuScreen());
      return;
    }
    if(controller.data?.isValid() != true) return;
    Get.to(() => PartnerProductSubscriptionCreateScreen(data: controller.data!, lController: lController));
  }
}