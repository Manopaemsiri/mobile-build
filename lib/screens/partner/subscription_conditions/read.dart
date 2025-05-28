import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

import '../../../controller/language_controller.dart';
import '../../../models/customer_subscription_cart_model.dart';
import '../../../models/partner_shipping_frontend_model.dart';
import '../../cms/content/components/html_content.dart';
import 'controller/subscriptopn_conditions_controller.dart';

class SubscriptionConditionsScreen extends StatelessWidget {
  SubscriptionConditionsScreen({
    super.key,
    required this.data,
    required this.shipping,
  });
  final CustomerSubscriptionCartModel data;
  final PartnerShippingFrontendModel shipping;
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {

    double _width = Get.width-(kGap*2)-1-(kQuarterGap*2);

    return GetBuilder<SubscriptionConditionsController>(
      init: SubscriptionConditionsController(data: data, shipping: shipping),
      builder: (controller) {
        Widget body = Center(child: Loading());
        if(controller.stateStatus == 1){
          body = widgetBody(controller, _width);
        }else if(controller.stateStatus == 2){
          body = NoData();
        }else if(controller.stateStatus == 3){
          body = PageError();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              lController.getLang('Agreement')
            ),
          ),
          body: body,
          floatingActionButton: AnimatedOpacity(
            opacity: controller.scrollController.hasClients && controller.scrollController.position.pixels >= controller.scrollController.position.maxScrollExtent - 200
            ? 0: 1,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: controller.scrollController.hasClients && controller.scrollController.position.pixels >= controller.scrollController.position.maxScrollExtent - 200
              ? true: false,
              child: FloatingActionButton.small(
                heroTag: 'scroll-down',
                onPressed: controller.scrollToEndOfList,
                child: const Icon(
                  Icons.arrow_downward_rounded
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: kPaddingSafeButton,
            child: ButtonFull(
              title: lController.getLang("Next"),
              onPressed: controller.onSubmit,
              color: controller.ended? null: kGrayColor,
            ),
          ),
        );
      }
    );
  }

  Widget widgetBody(SubscriptionConditionsController controller, double width) {

    return SingleChildScrollView(
      key: const ValueKey<String>('list-view'),
      controller: controller.scrollController,
      padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, kGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(),
          if(controller.htmlContent.isNotEmpty == true)...[
            HtmlContent(content: controller.htmlContent),
            const Gap(),
          ],
          RichText(
            text: TextSpan(
              text: lController.getLang('signature'),
              style: title.copyWith(
                fontWeight: FontWeight.w500,
                color: kDarkColor,
                fontFamily: 'Kanit'
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: title.copyWith(
                    fontWeight: FontWeight.w500,
                    color: kRedColor,
                    fontFamily: 'Kanit'
                  ),
                )
              ]
            )
          ),
          const Gap(gap: kHalfGap),
          Container(
            padding: const EdgeInsets.all(kQuarterGap),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRadius),
              color: kWhiteColor,
              border: Border.all(
                width: 0.5,
                color: kDarkColor.withValues(alpha: 0.2)
              )
            ),
            child: AspectRatio(
              aspectRatio: 400/160,
              child: Signature(
                key: const Key('signature'),
                controller: controller.controller,
                backgroundColor: kWhiteColor,
                width: width,
                height: width/(400/160),
              ),
            ),
          ),
          const Gap(gap: kHalfGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _button(
                SvgPicture.asset(
                  'assets/icons/undo.svg',
                  width: 24,
                  height: 24,
                  color: kDarkColor.withValues(alpha: 0.5),
                ),
                controller.undo
              ),
              const Gap(gap: kHalfGap),
              _button(
                SvgPicture.asset(
                  'assets/icons/redo.svg',
                  width: 24,
                  height: 24,
                  color: kDarkColor.withValues(alpha: 0.5),
                ),
                controller.redo
              ),
              const Gap(gap: kHalfGap),
              _button(
                Icon(
                  Icons.delete_rounded,
                  color: kDarkColor.withValues(alpha: 0.5),
                ),
                controller.clear
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _button(Widget value, Function() onTap) {
    
    return InkWell(
      borderRadius: BorderRadius.circular(kRadius),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kWhiteColor,
          border: Border.all(
            width: 0.5,
            color: kGrayColor.withValues(alpha: 0.2)
          ),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: value
      ),
    );
  }
}