import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/screens/customer/checkout/read.dart';
import 'package:coffee2u/screens/customer/shopping_cart/widgets/will_received_coupon.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({
    super.key
  });

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final LanguageController _lController = Get.find<LanguageController>();
  final AppController controllerApp = Get.find<AppController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  bool isValidCart = false;
  
  List<PartnerEventModel> events = [];
  bool expiredEventCart = false;

  Map<String, dynamic>? _settings;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  _initState() async {
    try {
      if(controllerCustomer.cart.products.isNotEmpty){
        events = [];
        final res1 = await ApiService.processList('partner-events');
        final length1 = res1?["result"].length ?? 0;
        for(var i = 0; i < length1; i++) {
          PartnerEventModel model = PartnerEventModel.fromJson(res1?["result"][i]);
          events.add(model);
        }

        final res2 = await ApiService.processRead('settings');
        if(mounted) {
          setState(() {
            _settings = res2?['result'] ?? {};
            isValidCart = true;
          });
        }
      }else{
        Get.back();
      }
    } catch (e) {
      if(kDebugMode) printError(info: '$e');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    const double imageWidth = 88;
    const double badgeWidth = imageWidth/2.5;

    return GetBuilder<CustomerController>(
      builder: (controller) {
        List<PartnerProductModel> products = controller.cart.products.where((d) => d.status != -2).toList();
        List<PartnerProductModel> freeProducts = controller.cart.products.where((d) => d.status == -2).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              _lController.getLang("Shopping Cart"),
              style: headline6.copyWith(fontWeight: FontWeight.w500),
            ),
            titleSpacing: 0,
            actions: const [
              // if(controllerApp.enabledMultiPartnerShops) ...[
              //   IconButton(
              //     icon: Image.asset(
              //       "assets/images/shop-01.png",
              //       height: 20,
              //       width: 20,
              //     ),
              //     onPressed: () {
              //       Get.to(
              //         () => PartnerShopsScreen(
              //           type: 'select',
              //           onPressed: (item) => _onChangeShop(item, controller),
              //         ),
              //       );
              //     }
              //   ),
              // ],
            ],
          ),
          body: !isValidCart 
          ? Center(
            child: Loading(),
          )
          : Container(
            color: kWhiteColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const DividerThick(),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    PartnerProductModel item = products[index];
                    
                    String widgetImage = item.image?.path ?? '';
                    String widgetPrice = '';
                    String widgetUnit = '';
                    if(item.selectedUnit != null) {
                      widgetUnit = '/ ${item.selectedUnit!.unit}';
                      if(controller.isCustomer()){
                        widgetPrice = item.selectedUnit!.isDiscounted() 
                          ? item.selectedUnit!.displayDiscountPrice(_lController) 
                          : item.selectedUnit!.displayMemberPrice(_lController);
                      }else{
                        widgetPrice = item.selectedUnit!.displayPrice(_lController);
                      }
                    }else{
                      widgetUnit = '/ ${item.unit}';
                      if(controller.isCustomer()){
                        widgetPrice = item.isDiscounted() 
                          ? item.displayDiscountPrice(_lController) 
                          : item.displayMemberPrice(_lController);
                      }else{
                        widgetPrice = item.displayPrice(_lController);
                      }
                    }

                    PartnerProductStatusModel? widgetStatus;
                    if(controllerApp.productStatuses.isNotEmpty && item.stock > 0){
                      final int index = controllerApp.productStatuses.indexWhere((d) => d.productStatus == item.status && d.type != 1);
                      if(index > -1) widgetStatus = controllerApp.productStatuses[index];
                    }
                    widgetStatus ??= item.productBadge(_lController, showSelectedUnit: item.selectedUnit?.isDiscounted() == true, isCart: true, showDiscounted: controller.isCustomer());

                    return Container(
                      key: ValueKey<String>('cart_item_${item.id}_${item.selectedUnit != null? item.selectedUnit?.id: ""}'),
                      color: kWhiteColor,
                      child: Stack(
                        children: [
                          Padding(
                            padding: kPadding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: kQuarterGap),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Stack(
                                        children: [
                                          ImageProduct(
                                            imageUrl: widgetImage,
                                            width: imageWidth,
                                            height: imageWidth,
                                          ),
                                          if(widgetStatus != null)...[
                                            if(widgetStatus.productStatus == 1)...[
                                              Positioned(
                                                top: 0, bottom: 0, left: 0, right: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.all(kQuarterGap),
                                                  color: kWhiteColor.withValues(alpha: 0.45),
                                                  child: Center(
                                                    child: Text(
                                                      'Coming\nSoon',
                                                      textAlign: TextAlign.center,
                                                      style: subtitle2.copyWith(
                                                        color: kDarkColor,
                                                        fontWeight: FontWeight.w800,
                                                        letterSpacing: 0.5,
                                                        height: 1.05,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]else...[
                                              if(widgetStatus.type == 1)...[
                                                Positioned(
                                                  top: 0, left: 0,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(4),
                                                      color: widgetStatus.textBgColor2,
                                                    ),
                                                    child: Text(
                                                      // widgetStatus.needTranslate? lController.getLang(widgetStatus.name): widgetStatus.name,
                                                      widgetStatus.text,
                                                      style: caption.copyWith(
                                                        color: widgetStatus.textColor2,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]else if(widgetStatus.type == 2)...[
                                                Positioned(
                                                  top: 0, left: 0,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(4),
                                                      color: widgetStatus.textBgColor2,
                                                    ),
                                                    child: Text(
                                                      item.isDiscounted()
                                                        ? widgetStatus.text.replaceAll('_DISCOUNT_PERCENT_', "${item.selectedUnit == null? item.discountPercent(): item.selectedUnit?.discountPercent()}")
                                                        : widgetStatus.text,
                                                      style: caption.copyWith(
                                                        color: widgetStatus.textColor2,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]else if(widgetStatus.type == 3)...[
                                                Positioned(
                                                  top: kHalfGap, left: kHalfGap,
                                                  child: ImageProduct(
                                                    imageUrl: widgetStatus.icon?.path ?? '',
                                                    width: badgeWidth, 
                                                    height: badgeWidth,
                                                    decoration: const BoxDecoration(),
                                                    fit: BoxFit.contain,
                                                    alignment: Alignment.topLeft,
                                                  ),
                                                ),
                                              ]
                                            ]
                                          ],
                                        ],
                                      ),
                                    ),
                                    if(item.isValidDownPayment()) ...[
                                      IconButton(
                                        icon: const FaIcon(
                                          FontAwesomeIcons.circleInfo,
                                          color: kAppColor,
                                          size: 22,
                                        ),
                                        padding: kOtPadding,
                                        onPressed: () => _onTapDownPaymentInfo(item),
                                      ),
                                    ],
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(kGap, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 2),
                                            SizedBox(
                                              height: 48,
                                              child: Text(
                                                item.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: subtitle1.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.45,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            if(item.eventId.isNotEmpty)...[
                                              Container(
                                                padding: const EdgeInsets.fromLTRB(kQuarterGap, kQuarterGap/2, kQuarterGap, kQuarterGap/2),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(kRadius/2),
                                                  color: kWhiteColor,
                                                  border: Border.all(
                                                    color: kAppColor
                                                  )
                                                ),
                                                child: Text(
                                                  _lController.getLang('text_added_from_event').replaceAll('_VALUE_', item.eventName),
                                                  style: caption.copyWith(
                                                    fontFamily: 'Kanit',
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.45,
                                                    color: kAppColor
                                                  ),
                                                ),
                                              ),
                                            ],
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: Get.width - 3*kGap - 88 - 48,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      RichText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        text: TextSpan(
                                                          text: widgetPrice,
                                                          style: headline6.copyWith(
                                                            fontFamily: 'Kanit',
                                                            color: kAppColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: " $widgetUnit ",
                                                              style: caption.copyWith(
                                                                fontFamily: 'Kanit',
                                                                color: kDarkColor,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                            if(controller.isCustomer()) ...[
                                                              if(item.selectedUnit == null && (item.isDiscounted() || item.isSetSaved())) ...[
                                                                TextSpan(
                                                                  text: item.isSetSaved()
                                                                  ? item.displaySetFullSavedPrice(_lController, showSymbol: false)
                                                                  : item.displayMemberPrice(_lController, showSymbol: false),
                                                                  style: subtitle1.copyWith(
                                                                    fontFamily: 'Kanit',
                                                                    color: kAppColor,
                                                                    fontWeight: FontWeight.w500,
                                                                    decoration: TextDecoration.lineThrough,
                                                                  ),
                                                                ),
                                                              ]
                                                              else if(item.selectedUnit != null && item.selectedUnit!.isDiscounted()) ...[
                                                                TextSpan(
                                                                  text: item.selectedUnit!.displayMemberPrice(_lController, showSymbol: false),
                                                                  style: subtitle1.copyWith(
                                                                    fontFamily: 'Kanit',
                                                                    color: kAppColor,
                                                                      fontWeight: FontWeight.w500,
                                                                      decoration: TextDecoration.lineThrough,
                                                                  ),
                                                                ),
                                                              ],
                                                            ]else ...[
                                                              if(item.selectedUnit == null && item.isSetSaved()) ...[
                                                                TextSpan(
                                                                  text: item.displaySetFullSavedPrice(_lController, showSymbol: false),
                                                                  style: subtitle1.copyWith(
                                                                    fontFamily: 'Kanit',
                                                                    color: kAppColor,
                                                                    fontWeight: FontWeight.w500,
                                                                    decoration: TextDecoration.lineThrough,
                                                                  ),
                                                                ),
                                                              ]
                                                            ],
                                                          ],
                                                        ),
                                                      ),
                                                      if(item.isValidDownPayment()) ...[
                                                        RichText(
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          text: TextSpan(
                                                            text: "${_lController.getLang("Deposit")} ",
                                                            style: subtitle2.copyWith(
                                                              fontFamily: 'Kanit',
                                                              color: kDarkColor,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: item.selectedUnit == null 
                                                                  ? item.displayDownPayment(_lController) 
                                                                  : item.selectedUnit!.displayDownPayment(_lController),
                                                                style: title.copyWith(
                                                                  fontFamily: 'Kanit',
                                                                  color: kAppColor,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(height: kOtGap),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  alignment: Alignment.centerRight,
                                                  onPressed: () => _onTapDelete(index, controller),
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: kAppColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: kGap),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${_lController.getLang("quantity")} : ",
                                              style: subtitle1.copyWith(
                                                color: kDarkColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            QuantityBig(
                                              qty: item.inCart,
                                              available: item.getMaxStock() > 0,
                                              onChange: (int q, bool widgetLimit) {
                                                _onChangeQuantity(index, q, controller, widgetLimit);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // if(expiredEvent)...[
                          //   Positioned.fill(
                          //     child: Container(
                          //       color: kDarkLightGrayColor.withValues(alpha: 0.3),
                          //     )
                          //   )
                          // ]
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                ),
                const Divider(height: 1),
                
                if(_settings?['APP_ENABLE_FEATURE_PARTNER_PRODUCT_REWARD'] == '1' 
                && freeProducts.isNotEmpty)...[
                  Container(
                    decoration: BoxDecoration(
                      color: kYellowColor.withValues(alpha: 0.05)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(controller.cart.productGiveawayRule != null)...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kHalfGap),
                            child: Align(
                              alignment: Alignment.center,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: kQuarterGap, horizontal: kQuarterGap),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(kRadius),
                                          color: kAppColor.withValues(alpha: 0.1)
                                        ),
                                        child: Icon(
                                          Icons.redeem_rounded,
                                          color: kAppColor.withValues(alpha: 0.8)
                                        ),
                                      )
                                    ),
                                    const WidgetSpan(child: Gap(gap: kHalfGap)),
                                    TextSpan(
                                      text: controller.cart.productGiveawayRule?.name ?? '',
                                      style: subtitle2.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: kDarkColor,
                                        fontFamily: 'Kanit'
                                      )
                                    )
                                  ]
                                )
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            endIndent: kGap,
                            indent: kGap,
                          )
                        ],
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: freeProducts.length,
                          itemBuilder: (_, index) {
                            PartnerProductModel item = freeProducts[index];

                            String widgetImage = item.image?.path ?? '';
                            String name = item.name;
                            String inCart = "x ${item.inCart} ${item.selectedUnit != null? item.selectedUnit?.unit: item.unit}";

                            return Container(
                              padding: kPadding,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ImageProduct(
                                    imageUrl: widgetImage,
                                    width: imageWidth/2,
                                    height: imageWidth/2,
                                  ),
                                  const Gap(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: subtitle2.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.45,
                                                  color: kDarkColor
                                                ),
                                              ),
                                            ),
                                            const Gap(),
                                            Text(
                                              inCart,
                                              style: subtitle2.copyWith(
                                                fontWeight: FontWeight.w400,
                                                height: 1.45,
                                                color: kDarkGrayColor
                                              ),
                                            )
                                          ],
                                        ),
                                        const Gap(gap: kQuarterGap),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(kQuarterGap, 0, kQuarterGap, 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(kRadius/2),
                                            color: Colors.transparent,
                                            border: Border.all(
                                              color: kAppColor
                                            )
                                          ),
                                          child: Text(
                                            _lController.getLang('Free Product'),
                                            style: caption.copyWith(
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                              height: 1.45,
                                              color: kAppColor,
                                              fontSize: 10
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                            
                          },
                          separatorBuilder: (_, __) => const Divider(height: 1),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
                Padding(
                  padding: kPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _lController.getLang("Reward Point(s)"),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: title.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.45
                        ),
                      ),
                      InkWell(
                        onTap: controller.isCustomer()
                          ? null
                          : () => Get.to(() => const SignInMenuScreen()),
                        child: BadgeDefault(
                          title: controller.isCustomer()
                            ? numberFormat(controller.pointEarn().toDouble(), digits: 0)
                            : _lController.getLang("Customer Only"),
                          icon: FontAwesomeIcons.crown,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if(_settings?['APP_ENABLE_FEATURE_PARTNER_PRODUCT_COUPON'] == '1' 
                && _settings?['APP_ENABLE_FEATURE_PARTNER_COUPON_REWARD'] == '1' 
                && controllerCustomer.isCustomer())...[
                  if(controller.cart.receivedCoupons.isNotEmpty)...[
                    const Gap(),
                    WillReceivedCoupons(
                      data: controller.cart.receivedCoupons,
                      onTap: _onTapCoupon,
                      lController: _lController,
                    ),
                    const Gap(),
                    const Divider(height: 1),
                  ]
                ],
              ],
            ),
          ),
          bottomNavigationBar: !isValidCart 
            ? const SizedBox.shrink()
            : Padding(
              padding: kPaddingSafeButton,
              child: ButtonOrder(
                title: _lController.getLang("Order Now"),
                qty: controller.countCartProducts(),
                total: controller.cart.total,
                onPressed: onTapCheckOut,
                lController: _lController
              ),
            ),
        );
      },
    );
  }

  void onTapCheckOut() async {
    Get.to(() => const CheckOutScreen())?.then((value) {
      if(controllerCustomer.cart.products.isEmpty) Get.back();
    });
  }

  // void _onChangeShop(PartnerShopModel shop, CustomerController controller) async {
  //   await controller.updateCartShop(shop.id ?? '');
  //   Get.back();
  //   if(controller.cart.products.isEmpty){
  //     Get.back();
  //   }
  // }

  void _onTapDelete(int index, CustomerController controller) {
    ShowDialog.showOptionDialog(
      _lController.getLang("Delete Item"),
      "${_lController.getLang("text_delete_item_1")} ?",
      () async {
        await controller.removeCartProduct(index);
        Get.back();
        if(controller.cart.products.isEmpty){
          Get.back();
        }
        final clearance = AppHelpers.checkProductClearance(controllerCustomer.cart);
        if(!clearance && controllerCustomer.cart.shop?.id != controllerCustomer.partnerShop?.id
          && controllerCustomer.partnerShop != null
        ){
          await controller.updateCartShop(controllerCustomer.partnerShop?.id ?? '');
        }
      },
    );
  }

  void _onChangeQuantity(int index, int qty, CustomerController controller, bool widgetLimit) {
    if(widgetLimit) {
      ShowDialog.showForceDialog(
        _lController.getLang("Warning"),
        _lController.getLang("Not enough products in the store"),
        () => Get.back()
      );
      return;
    }
    controller.updateCartProduct(index, qty);
  }

  void _onTapDownPaymentInfo(PartnerProductModel product) {
    if(product.isValidDownPayment()){
      ShowDialog.showForceDialog(
        _lController.getLang("Deposit Product"),
        _lController.getLang("text_deposit_product1").replaceFirst("value", "30"),
        () => Get.back(),
      );
    }
  }

  void _onTapCoupon (String id) {}
}