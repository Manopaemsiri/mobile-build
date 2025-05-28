import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/data/local_storage/local_storage.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/screens/customer/address/list.dart';
import 'package:coffee2u/screens/customer/address/components/card_address.dart';
import 'package:coffee2u/screens/customer/billing_address/list.dart';
import 'package:coffee2u/screens/customer/checkout/components/card_cms_contents.dart';
import 'package:coffee2u/screens/customer/checkout/components/card_cms_products.dart';
import 'package:coffee2u/screens/customer/checkout/components/order_item.dart';
import 'package:coffee2u/screens/customer/checkout/components/list_option.dart';
import 'package:coffee2u/screens/customer/down_payments/list.dart';
import 'package:coffee2u/screens/customer/payment/list.dart';
import 'package:coffee2u/screens/customer/shipping/list.dart';
import 'package:coffee2u/screens/customer/shopping_cart/widgets/will_received_coupon.dart';
import 'package:coffee2u/screens/home/components/popup_carousel.dart';
import 'package:coffee2u/screens/partner/product_coupon/checkout.dart';
import 'package:coffee2u/screens/partner/shipping_coupon/checkout.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  Map<String, dynamic> _settings = {};
  
  final AppController _appController = Get.find<AppController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  int _points = 0;
  bool isReady = false;

  CmsCheckoutContentModel? checkoutCmsContent;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  Future<void> _readSettings() async {
    try {
      Map<String, dynamic>? res = await ApiService.processRead('settings');
      _settings = res!['result'];
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }
  Future<void> _readTotalPoints() async {
    try {
      Map<String, dynamic>? res = await ApiService.processRead('total-points');
      if(res!['result'] != null) _points = res['result']['data'] ?? 0;
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }
  Future<void> _autoCoupon() async {
    try {
      Map<String, dynamic>? res = await ApiService.processList('checkout-partner-product-coupons');
      PartnerProductCouponModel? _temp;
      if(res != null && res["result"] != null){
        for(int i=0; i<res["result"].length; i++){
          PartnerProductCouponModel _t = PartnerProductCouponModel.fromJson(res["result"][i]);
          if(_t.availability == 99){
            if(_temp == null){
              _temp = _t;
            }else if(_t.actualDiscount > _temp.actualDiscount){
              _temp = _t;
            }
          }
        }
      }
    if(_temp != null) _customerController.setDiscountProduct(_temp, needUpdate: true);
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }

  _initState() async {
    await Future.wait([
      _customerController.readCart(needLoading: false),
      AppHelpers.updatePartnerShop(_customerController),
      _customerController.updateTier(),
      _customerController.updateBillingAddress(null),
      _customerController.setShippingMethod(null),
      _customerController.setDiscountShipping(null),
      _customerController.setDiscountProduct(null),
      _customerController.setDiscountCash(null),
      _customerController.setDiscountPoint(null),
      _readSettings(),
      _readTotalPoints(),
      _autoCoupon(),
      _appController.getSetting(),
      _getCmsContent(),
    ]);
    if(_settings['APP_MODULE_CUSTOMER_GROUP'] == '1') await _readCustomerGroup();

    if(mounted){
      setState(() {
        _settings;
        _points;
        isReady = true;
      });
      final String? _prefCheckoutPopup = await LocalStorage.get('${_customerController.customerModel?.id}$prefCheckoutPopup');
      bool isSameDay = false;
      if(_prefCheckoutPopup != null) isSameDay = DateTime.now().isSameDay(DateTime.parse(_prefCheckoutPopup));
      if(checkoutCmsContent?.showPopup == true && (_prefCheckoutPopup == null || !isSameDay)){
        LocalStorage.save('${_customerController.customerModel?.id}$prefCheckoutPopup', DateTime.now().toIso8601String());
        _dialogPopup(context, [ checkoutCmsContent!.relatedPopup! ]);
      }
    }
  }

  Future<void> _dialogPopup(BuildContext context, List<CmsPopupModel> popup) {
    double popupRatio = 13 / 10;
    double maxWidth = Get.width > 500? 500: (Get.width - 2.5*kGap)*popupRatio;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            vertical: kGap, horizontal: 1*kGap,
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(
                  kQuarterGap, kQuarterGap, kQuarterGap, kQuarterGap,
                ),
                width: maxWidth,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: maxWidth,
                          child: PopupCarousel(
                            popupModels: popup,
                            aspectRatio: 1 / popupRatio,
                            margin: kQuarterGap,
                            radius: const BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        Positioned(
                          top: kHalfGap,
                          right: kHalfGap,
                          child: Container(
                            width: 1.75 * kGap,
                            height: 1.75 * kGap,
                            decoration: BoxDecoration(
                              color: kGrayColor,
                              borderRadius: BorderRadius.circular(0.875 * kGap),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              color: kWhiteColor,
                              iconSize: 1.75 * kGap,
                              icon: const Icon(Icons.cancel),
                              onPressed: () => Get.back(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _readCustomerGroup() async {
    if(_customerController.customerModel?.group != null){
      try {
        CustomerGroupModel? _customerGroup;
        final res = await ApiService.processRead("group");
        if(res?["result"].isNotEmpty) _customerGroup = CustomerGroupModel.fromJson(res?["result"]);
        _customerGroup = _customerGroup ?? _customerController.customerModel?.group;

        if(_customerGroup?.enableAutoAddress() == true && _customerController.shippingAddress == null) {
          final Map<String, dynamic>? res2 = await ApiService.processRead('shipping-address-get-selected', input: { 'autoBilling': 1 });
          if(res2?['result'].isNotEmpty == true){
            final shipping = CustomerShippingAddressModel.fromJson(res2?['result']);
            await _customerController.updateShippingAddress(shipping);
          }
        }

        if(_customerGroup?.enableAutoBillingAddress() == true) {
          final Map<String, dynamic>? res2 = await ApiService.processRead('billing-address-get-selected', input: { 'autoBilling': 1 });
          if(res2?['result'].isNotEmpty == true){
            final billing = CustomerBillingAddressModel.fromJson(res2?['result']);
            await _customerController.updateBillingAddress(billing);
          }
        }
      } catch (e) {
        if(kDebugMode) printError(info: e.toString());
      }
    }
  }

  Future<void> _getCmsContent() async {
    try {
      Map<String, dynamic>? res = await ApiService.processRead(
        'cms-checkout-content', 
        input: { 
          'customerId': _customerController.customerModel?.id,
          "partnerShopId": _customerController.partnerShop?.id,
        }
      );
      if(res?['result'].isNotEmpty == true){
        checkoutCmsContent = CmsCheckoutContentModel.fromJson(res?['result']);
      }
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kWhiteColor,
          appBar: AppBar(
            title: Text(
              // _appController.enabledMultiPartnerShops 
              //   ? _customerController.cart.shop!.name ?? '' 
              //   : lController.getLang("Checkout"),
              lController.getLang("Checkout"),
            ),
          ),
          body: GetBuilder<CustomerController>(builder: (controller) {
            return ListView(
              children: [
                const DividerThick(),
                CardAddress(
                  model: controller.shippingAddress,
                  onTap: () => Get.to(() => const AddressScreen()), 
                  lController: lController,
                ),
                CheckoutOrderItem(
                  model: controller.cart, 
                  lController: lController,
                  settings: _settings,
                ),
                if(checkoutCmsContent != null)...[
                  if(checkoutCmsContent?.relatedContents?.isNotEmpty == true
                  || checkoutCmsContent?.relatedProducts?.isNotEmpty == true)...[
                    const DividerThick(),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(horizontal: kGap, vertical: kGap),
                      decoration: BoxDecoration(
                        color: kAppColor,
                        // color: kAppColor2.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(kRadius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Gap(),
                          if(checkoutCmsContent?.relatedProducts?.isNotEmpty == true)...[
                            CardCmsProducts(
                              lController: lController,
                              aController: _appController,
                              customerController: _customerController,
                              products: checkoutCmsContent?.relatedProducts ?? []
                            ),
                            const Gap(),
                          ],
                          if(checkoutCmsContent?.relatedContents?.isNotEmpty == true)...[
                            CardCmsContents(
                              lController: lController,
                              contents: checkoutCmsContent?.relatedContents ?? [],
                            ),
                            const Gap(),
                          ],
                        ],
                      ),
                    ),
                  ]
                ],
                const DividerThick(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Product Coupon
                    if(_settings?['APP_ENABLE_FEATURE_PARTNER_PRODUCT_COUPON'] == '1') ...[
                      ListOption(
                        icon: FontAwesomeIcons.gift,
                        title: lController.getLang("Product Coupon"),
                        description: controller.discountProduct == null
                          ? '': controller.discountProduct!.name,
                        onTap: _customerController.isCustomer()
                        ? () {
                          controller.setDiscountProduct(null, needUpdate: true);
                          Get.to(() => const CheckoutPartnerProductCouponsScreen(
                            isCashCoupon: 0,
                          ));
                        }: null,
                        trailings: controller.isCustomer()
                          ? [
                            if(controller.discountProduct == null) ...[ 
                              const Icon(Icons.chevron_right),
                            ] else ...[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if(controller.discountProduct!.actualDiscount > 0) ...[
                                    Text(
                                      '- ${priceFormat(controller.discountProduct?.actualDiscount ?? 0, lController)}',
                                      style: subtitle3.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: kAppColor,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                  if(controller.discountProduct!.missingPaymentDiscount > 0) ...[
                                    Text(
                                      '- ${priceFormat(controller.discountProduct?.missingPaymentDiscount ?? 0, lController)}',
                                      style: subtitle3.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: kBlueColor,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ]
                          : [
                            InkWell(
                              onTap: () => Get.to(() => const SignInMenuScreen()),
                              child: SizedBox(
                                height: 28,
                                child: BadgeDefault(
                                  title: lController.getLang("Customer Only"),
                                  icon: FontAwesomeIcons.crown,
                                  size: 14,
                                ),
                              ),
                            ),
                          ], 
                          lController: lController,
                      ),
                    ],

                    // Shipping Method
                    controller.shippingMethod == null || !controller.shippingMethod!.isValid()
                    ? ListOption(
                      icon: FontAwesomeIcons.truck,
                      title: lController.getLang("Choose Shipping Method"),
                      onTap: () => _onTapShippingMethod(controller),
                      trailings: const [ Icon(Icons.chevron_right) ], 
                      lController: lController,
                    )
                    : ListOption(
                      icon: FontAwesomeIcons.truck,
                      title: controller.shippingMethod!.displayName,
                      description: controller.shippingMethod!.displaySummary(lController) +
                       (controller.shippingMethod?.type == 2 && controller.shippingMethod != null? '\n${lController.getLang('pick up at').replaceAll(RegExp(r'_VALUE_'), controller.shippingMethod?.shop?.name ?? '')}': ''),
                      descriptionColor: kAppColor,
                      onTap: () => _onTapShippingMethod(controller),
                      trailings: [
                        controller.shippingMethod!.price <= 0
                          ? Text(
                            'FREE',
                            style: subtitle3.copyWith(
                              fontWeight: FontWeight.w600,
                              color: kAppColor
                            ),
                          )
                          : Text(
                            controller.shippingMethod!.displayPrice(lController),
                            style: subtitle3.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ], 
                      lController: lController,
                    ),

                    // Shipping Coupon
                    if(controller.shippingMethod != null && controller.shippingMethod!.isValid() 
                    && _settings['APP_ENABLE_FEATURE_PARTNER_SHIPPING_COUPON'] == '1' 
                    && controller.shippingMethod?.type != 2 
                    && controller.shippingMethod!.price > 0) ...[
                    // && _settings['APP_ENABLE_FEATURE_PARTNER_SHIPPING_COUPON'] == '1') ...[
                      ListOption(
                        icon: FontAwesomeIcons.tag,
                        title: lController.getLang("Shipping Coupon"),
                        description: controller.discountShipping == null
                          ? '': controller.discountShipping!.name,
                        onTap: _customerController.isCustomer()? () {
                          controller.setDiscountShipping(null, needUpdate: true);
                          Get.to(() => const CheckoutPartnerShippingCouponsScreen());
                        }: null,
                        trailings: controller.isCustomer()
                          ? [
                            controller.discountShipping == null 
                              ? const Icon(Icons.chevron_right)
                              : Text(
                                '- ${priceFormat(controller.discountShipping?.actualDiscount ?? 0, lController)}',
                                style: subtitle3.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kAppColor,
                                ),
                              ),
                          ]
                          : [
                            InkWell(
                              onTap: () => Get.to(() => const SignInMenuScreen()),
                              child: SizedBox(
                                height: 28,
                                child: BadgeDefault(
                                  title: lController.getLang("Customer Only"),
                                  icon: FontAwesomeIcons.crown,
                                  size: 14,
                                ),
                              ),
                            ),
                          ], 
                          lController: lController,
                      ),
                    ],

                    // Cash Coupon
                    if(_settings['APP_ENABLE_FEATURE_PARTNER_CASH_COUPON'] == '1') ...[
                      ListOption(
                        icon: FontAwesomeIcons.sackDollar,
                        title: lController.getLang("Cash Coupon"),
                        description: controller.discountCash == null
                          ? '': controller.discountCash!.name,
                        onTap: _customerController.isCustomer()? () {
                          controller.setDiscountCash(null, needUpdate: true);
                          Get.to(() => const CheckoutPartnerProductCouponsScreen(
                            isCashCoupon: 1,
                          ));
                        }: null,
                        trailings: controller.isCustomer()
                          ? [
                            if(controller.discountCash == null) ...[
                              const Icon(Icons.chevron_right),
                            ] else ...[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if(controller.discountCash!.actualDiscount > 0) ...[
                                    Text(
                                      '- ${priceFormat(controller.discountCash?.actualDiscount ?? 0, lController)}',
                                      style: subtitle3.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: kAppColor,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                  if(controller.discountCash!.missingPaymentDiscount > 0) ...[
                                    Text(
                                      '- ${priceFormat(controller.discountCash?.missingPaymentDiscount ?? 0, lController)}',
                                      style: subtitle3.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: kBlueColor,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ]
                          : [
                            InkWell(
                              onTap: () => Get.to(() => const SignInMenuScreen()),
                              child: SizedBox(
                                height: 28,
                                child: BadgeDefault(
                                  title: lController.getLang("Customer Only"),
                                  icon: FontAwesomeIcons.crown,
                                  size: 14,
                                ),
                              ),
                            ),
                          ], 
                          lController: lController,
                      ),
                    ],

                    // Point Reward
                    if(_settings['APP_ENABLE_FEATURE_POINT_REWARD'] == '1') ...[
                      ListOption(
                        icon: FontAwesomeIcons.crown,
                        title: lController.getLang("Point Discount"),
                        description: controller.discountPoint == null
                          ? '': '${lController.getLang("Use Point")} ${numberFormat(controller.discountPoint?.points ?? 0, digits: 0)} ${lController.getLang("point(s)")}',
                        onTap: _customerController.isCustomer()? () => _onTapPointsRewards(controller): null,
                        trailings: controller.isCustomer()
                          ? [
                            controller.discountPoint == null 
                              ? const Icon(Icons.chevron_right)
                              : Text(
                                '- ${priceFormat(controller.discountPoint?.discount ?? 0, lController)}',
                                style: subtitle3.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kAppColor,
                                ),
                              ),
                          ]
                          : [
                            InkWell(
                              onTap: () => Get.to(() => const SignInMenuScreen()),
                              child: SizedBox(
                                height: 28,
                                child: BadgeDefault(
                                  title: lController.getLang("Customer Only"),
                                  icon: FontAwesomeIcons.crown,
                                  size: 14,
                                ),
                              ),
                            ),
                          ], 
                          lController: lController,
                      ),
                    ],

                    // const DividerThick(),
                    if(_settings?['APP_ENABLE_FEATURE_PARTNER_PRODUCT_COUPON'] == '1' 
                    && _settings?['APP_ENABLE_FEATURE_PARTNER_COUPON_REWARD'] == '1' 
                    && _customerController.isCustomer())...[
                      if(controller.cart.receivedCoupons.isNotEmpty)...[
                        const Gap(),
                        WillReceivedCoupons(
                          data: controller.cart.receivedCoupons,
                          lController: lController,
                        ),
                        const Gap(),
                        const DividerThick(),
                      ]else...[
                        const DividerThick(),
                      ],
                    ]else...[
                      const DividerThick(),
                    ],

                    // Tax Invoice
                    InkWell(
                      onTap: () => Get.to(() => const BillingAddressesScreen()),
                      child: Padding(
                        padding: kPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lController.getLang("Tax Invoice"),
                                  style: subtitle1.copyWith(
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: kQuarterGap),
                              child: controller.billingAddress != null && controller.billingAddress!.isValid()
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.billingAddress!.billingName,
                                      style: subtitle1.copyWith(
                                        color: kGrayColor
                                      ),
                                    ),
                                    Text(
                                      controller.billingAddress!.displayAddress(lController),
                                      style: subtitle1.copyWith(
                                        color: kGrayColor
                                      ),
                                    ),
                                  ],
                                )
                                : Text(
                                  lController.getLang("No billing address"),
                                  style: subtitle1,
                                ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const DividerThick(),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lController.getLang("Reward Point(s)"),
                        style: subtitle1.copyWith(
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      BadgeDefault(
                        title: controller.isCustomer() 
                          ? numberFormat(controller.pointEarn().toDouble(), digits: 0) 
                          : lController.getLang("Customer Only"),
                        icon: FontAwesomeIcons.crown,
                        size: 13,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
              ],
            );
          }),
          bottomNavigationBar: GetBuilder<CustomerController>(
            builder: (controller) {
              int count = controller.countCartProducts();
              return Padding(
                padding: kPaddingSafeButton,
                child: ButtonOrder(
                  title: lController.getLang("Checkout"),
                  qty: count,
                  total: controller.checkoutTotal(),
                  onPressed: () => _onTapOrder(controller),
                  lController: lController
                ),
              );
            },
          ),
        ),
        if(!isReady)...[
          IgnorePointer(
            ignoring: true,
            child: Material(
              type: MaterialType.card,
              color: kWhiteColor.withValues(alpha: 0.5),
              child: Loading(),
            ),
          )
        ],
      ],
    );
  }

  void _onTapPointsRewards(CustomerController _controller) {
    final symbol = lController.usedCurrency?.unit ?? lController.defaultCurrency?.unit ?? 'THB';

    if(_controller.isCustomer()){
      List<CustomerPointFrontendModel> _choices = [];
      if(_controller.tier != null){
        double _burnRate = _controller.tier?.pointBurnRate ?? 0;
        if(_burnRate > 0){
          int _steps = (_points / _controller.tier!.pointBurnStep).floor()+1;
          for(int i=1; i<_steps; i++){
            double _used = i * _controller.tier!.pointBurnStep;
            if(_used <= _points){
              _choices.add(CustomerPointFrontendModel(
                points: _used,
                discount: _used * _burnRate,
              ));
            }
          }
        }
      }

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(4.0),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.5,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: kPadding,
                      child: Row(
                        children: [
                          Text(
                            lController.getLang("Available Points"),
                            style: title.copyWith(
                              fontWeight: FontWeight.w500,
                            )
                          ),
                          const SizedBox(width: kQuarterGap),
                          Text(
                            numberFormat(_points.toDouble(), digits: 0),
                            style: title.copyWith(
                              fontWeight: FontWeight.w500,
                              color: kAppColor,
                            )
                          ),
                          const SizedBox(width: kQuarterGap),
                          Text(
                            lController.getLang("Points"),
                            style: title.copyWith(
                              fontWeight: FontWeight.w500,
                            )
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0.7, thickness: 0.7),
                    _choices.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.only(top: 3*kGap),
                        child: NoDataCoffeeMug(
                          titleText: 'text_least_1000_points'
                        ),
                      )
                      : Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(0, kHalfGap, 0, kHalfGap),
                          children: [
                            Wrap(
                              children: [
                                InkWell(
                                  onTap: (){
                                    _controller.setDiscountPoint(null, needUpdate: true);
                                    Get.back();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          lController.getLang('Do not use points'),
                                          style: subtitle1.copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ..._choices.map((CustomerPointFrontendModel _d) {

                                  return InkWell(
                                    onTap: (){
                                      _controller.setDiscountPoint(_d, needUpdate: true);
                                      Get.back();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${lController.getLang("Use")} ${numberFormat(_d.points, digits: 0)} ${lController.getLang("Point(s)")}',
                                            style: subtitle1.copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            '${lController.getLang("Discount")} ${priceFormat(_d.discount, lController, showSymbol: false)} $symbol',
                                            style: subtitle1.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: kAppColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ]
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
        isScrollControlled: true,
      );
    }
  }

  void _onTapShippingMethod(CustomerController _controller) {
    if (_controller.shippingAddress == null || !_controller.shippingAddress!.isValid()) {
      ShowDialog.showForceDialog(
        lController.getLang("Missing shipping address"),
        lController.getLang("Please choose a shipping address"), 
        (){
          Get.back();
          Get.to(() => const AddressScreen());
        }
      );
    }else {
      Get.to(() => const ShippingMethodsScreen());
    }
  }
  
  void _onTapOrder(CustomerController _controller) {
    if(_controller.cart.products.isEmpty){
      Get.back();
      return;
    }
    if (_controller.shippingAddress == null || !_controller.shippingAddress!.isValid()) {
      ShowDialog.showForceDialog(
        lController.getLang("Missing shipping address"),
        lController.getLang("Please choose a shipping address"), 
        () {
          Get.back();
          Get.to(() => const AddressScreen());
        }
      );
      return;
    }
    if (_controller.shippingMethod == null || !_controller.shippingMethod!.isValid()) {
      ShowDialog.showForceDialog(
        lController.getLang("Missing Shipping Method"),
        lController.getLang("Please choose a shipping method"),
        (){
          Get.back();
          Get.to(() => const ShippingMethodsScreen());
        }
      );
      return;
    }

    if (_controller.billingAddress == null || !_controller.billingAddress!.isValid()) {
      ShowDialog.showForceDialog(
        lController.getLang("Missing Billing Address"),
        lController.getLang("Continue without billing address"),
        (){
          Get.back();
          // if (_controller.discountProduct?.isValid() == true && _controller.discountProduct?.validAllowCustomDownPayment() == true) {
          if (_controller.cart.hasDownPayment == 1 && _controller.discountProduct?.isValid() == true && _controller.discountProduct?.validAllowCustomDownPayment() == true) {
            Get.to(() => const DownPaymentsScreen());
          } else {
            Get.to(() => const PaymentMethodsScreen());
          }
        },
        onCancel: () {
          Get.back();
          Get.to(() => const BillingAddressesScreen());
        },
        confirmText: lController.getLang("Yes"),
        cancelText: lController.getLang("No"),
      );
      return;
    }

    if (_controller.cart.hasDownPayment == 1 && _controller.discountProduct?.isValid() == true && _controller.discountProduct?.validAllowCustomDownPayment() == true) {
      Get.to(() => const DownPaymentsScreen());
    } else {
      Get.to(() => const PaymentMethodsScreen());
    }
  }

}