import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/partner/subscription/widgets/card_product.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coffee2u/apis/api_service.dart';

import '../../../controller/app_controller.dart';
import '../../../controller/customer_controller.dart';
import '../../../models/index.dart';
import '../../../widgets/index.dart';
import '../product/read.dart';
import 'controllers/subscription_create_controller.dart';

class PartnerProductSubscriptionCreateScreen extends StatelessWidget {
  const PartnerProductSubscriptionCreateScreen({
    Key? key,
    required this.data,
    required this.lController,
    this.subscription,
    this.type = 1
  }) : super(key: key);
  final PartnerProductSubscriptionModel data;
  final LanguageController lController;
  final CustomerSubscriptionModel? subscription;
  final int type;

  @override
  Widget build(BuildContext context) {
    
    return GetBuilder<SubscriptionCreateController>(
      init: SubscriptionCreateController(data: data, type: type, lController: lController, subscription: subscription),
      builder: (controller) {

        return Scaffold(
          appBar: AppBar(
            title: Text(
              lController.getLang(subscription != null
              ? 'Update Subscription'
              : 'Product Subscription'),
            ),
            actions: [
              if(controller.step.length > 1)...[
                Container(
                  margin: const EdgeInsets.only(right: kGap),
                  child: Center(
                    child: Text(
                      '${controller.currentPage+1}/${controller.step.length}',
                      style: title.copyWith(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
          body: PageView(
            key: const ValueKey<String>('PageView'),
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: controller.step.asMap().map((i, d) => MapEntry(ValueKey<String>('step_$i'), _page(i, d, controller))).values.toList()
          ),
          bottomNavigationBar: Padding(
            padding: kPaddingSafeButton,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if(controller.currentPage > 0)...[
                Expanded(
                  // flex: 4,
                  child: ButtonCustom(
                    title: lController.getLang("Back"),
                    isOutline: true,
                    onPressed: () => controller.previousPage(),
                    textStyle: headline6,
                  ),
                ),
                const Gap(),
                // ],
                Expanded(
                  child: ButtonFull(
                    title: lController.getLang(  
                      subscription != null ? "Update" : "Choose"),
                      onPressed: () {
                        if (controller.isCurrentStepFilled()) {
                          controller.nextPage();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                lController.getLang('Please Use All of Your Credit'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _page(int i, SelectionSteps value, SubscriptionCreateController controller) {
    final String name = value.name;
    final String key = value.id ?? name;
    final List<PartnerProductModel> products = value.products.map((e) => e.product).where((d) => d != null).cast<PartnerProductModel>().toList();
    final double credit = value.credit;

    final double sumCredit = value.products
      .where((d) => d.quantity > 0)
      .fold(0, (sum, item) => sum + (item.credit*item.quantity));

    final double remainingCredit = (value.credit - sumCredit);
    
    return ListView(
      key: ValueKey<String>('${key}_$i'),
      children: [
        Padding(
          padding: const EdgeInsets.all(kGap),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      textAlign: TextAlign.start,
                      key: ValueKey<String>('name_$i'),
                      style: title.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.25
                      ),
                    ),
                  ),
                  const Gap(gap: kHalfGap),
                  RichText(
                    key: ValueKey<String>('credit$i'),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    textScaleFactor: 1,
                    text: TextSpan(
                      style: subtitle2.copyWith(
                        fontFamily: 'Kanit',
                        color: kDarkColor,
                        fontWeight: FontWeight.w400,
                        height: 1.4
                      ),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.paid,
                            color: Colors.yellow[600],
                          )
                        ),
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Gap(gap: kQuarterGap)
                        ),
                        TextSpan(
                          text: numberFormat((credit - sumCredit).clamp(0, double.infinity), digits: 0),
                          style: title.copyWith(
                            fontWeight: FontWeight.w500
                          )
                        ),
                      ]
                    )
                  )
                ],
              ),
            ],
          ),
        ),
        if(products.isNotEmpty)...[
          SubscriptionProduct(
            key: ValueKey<String>("product_subscription_$i"),
            padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, kHalfGap),
            data: value,
            lController: lController,
            aController: Get.find<AppController>(),
            onTap: (d) => Get.to(() => ProductScreen(productId: d.id, subscription: true)),
            showStock: Get.find<CustomerController>().isShowStock(),
            sumCredit: sumCredit,
            increaseItem: (j) => controller.increaseItem(i, j),
            decreaseItem: (j) => controller.decreaseItem(i, j),
          ),
        ]
      ],
    );
  }
}


