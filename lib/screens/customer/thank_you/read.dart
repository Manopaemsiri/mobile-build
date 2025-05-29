import 'dart:math';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/bottom_nav/bottom_nav.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/partner_product_coupon_log_model.dart';
import '../../partner/subscription/controllers/subscription_checkout_controller.dart';
import '../../partner/subscription/controllers/subscription_controller.dart';
import '../../partner/subscription/controllers/subscription_create_controller.dart';
import '../../partner/subscription/controllers/subscriptions_controller.dart';
import '../../partner/subscription_conditions/controller/subscriptopn_conditions_controller.dart';
import '../my_product_coupon/my_product_coupon_screen.dart';
import 'widgets/received_coupon.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({
    super.key,
    required this.orderTemp,
    this.subscription = false,
  });

  final dynamic orderTemp;
  final bool subscription;

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  final InAppReview _inAppReview = InAppReview.instance;

  List<PartnerProductCouponLogModel> receivedCoupons = [];

  ConfettiController? _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(milliseconds: 500));
    _initState();
  }
  @override
  void dispose() {
    _controllerCenter?.dispose();
    super.dispose();
  }
  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  _initState() async {
    // set giveaway coupons
    _setGiveawayCoupon();

    final prefs = await SharedPreferences.getInstance();
    String? strReview = prefs.getString(prefCustomerReview);
    if(strReview == null || strReview != "1"){
      try{
        bool isAvailable = await _inAppReview.isAvailable();
        if(isAvailable) _inAppReview.requestReview();
      }catch(_){}
      await prefs.setString(prefCustomerReview, "`");
    }
    AppHelpers.updatePartnerShop(controllerCustomer);

    // Update coupons
    _updateCoupons();
  }

  _updateCoupons() async {
    final String cusId = controllerCustomer.customerModel?.id ?? '';
    if(widget.orderTemp?["cashCoupon"]?["_id"]?.isNotEmpty == true){
      final id = widget.orderTemp["cashCoupon"]?["_id"];
      String prefKey = "$cusId$prefCustomerCashCoupon";
      AppHelpers.reduceCoupon(prefKey, id);
    }
    
    if(widget.orderTemp?["coupon"]?["_id"]?.isNotEmpty == true){
      final id = widget.orderTemp["coupon"]?["_id"];
      String prefKey = "$cusId$prefCustomerDiscountProduct";
      AppHelpers.reduceCoupon(prefKey, id);
    }

    if(widget.orderTemp?["shippingCoupon"]?["_id"]?.isNotEmpty == true){
      final id = widget.orderTemp?["shippingCoupon"]?["_id"];
      String prefKey = "$cusId$prefCustomerShippingCoupon";
      AppHelpers.reduceCoupon(prefKey, id);
    }
  }

  _setGiveawayCoupon() async {
    if(controllerCustomer.isCustomer()) {
      try {
        if(widget.orderTemp?['receivedCoupons'] != null) {
          final List<dynamic> temp = widget.orderTemp?['receivedCoupons'];
          for (var i = 0; i < temp.length; i++) {
            receivedCoupons.add(PartnerProductCouponLogModel.fromJson(temp[i]));
          }
          
          if(mounted) {
            if(receivedCoupons.isNotEmpty) _controllerCenter?.play();
            setState(() {});
          }
        }
      } catch (e) {
        if(kDebugMode) print("$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic orderTemp = widget.orderTemp;

    final CustomerController controllerCustomer = Get.find<CustomerController>();
    String dataEmail = controllerCustomer.customerModel?.email ?? '';

    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: kWhiteColor,
            body: Center(
              child: ListView(
                padding: kPadding,
                shrinkWrap: true,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 110,
                      child: Image.asset(
                        "assets/images/logo-app-512.png",
                        width: 110,
                      ),
                    ),
                  ),
                  const Gap(gap: 30),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      lController.getLang("text_thank_you_1"),
                      style: title.copyWith(
                        fontWeight: FontWeight.w600
                      )
                    ),
                  ),
                  const Gap(),
                  Align(
                    alignment: Alignment.center,
                    child: Card(
                      elevation: 6,
                      shadowColor: kGrayLightColor,
                      child: Padding(
                        padding: kPadding,
                        child: Column(
                          children: [

                            if(dataEmail != '') ...[
                              Text(
                                lController.getLang("text_thank_you_2"),
                                style: subtitle1
                              ),
                              Text(
                                dataEmail,
                                style: title.copyWith(
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              const Gap(gap: kQuarterGap),
                            ],

                            const Gap(gap: kQuarterGap),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lController.getLang("Order ID"),
                                  style: subtitle1.copyWith(color: kDarkLightColor),
                                ),
                                Text(
                                  orderTemp['orderId'] ?? '',
                                  style: subtitle1.copyWith(
                                    color: kAppColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'CenturyGothic'
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lController.getLang("Order At"),
                                  style: subtitle1.copyWith(color: kDarkLightColor),
                                ),
                                Text(
                                  dateFormat(
                                    orderTemp['createdAt'] == null
                                      ? DateTime.now()
                                      : DateTime.parse(orderTemp['createdAt']),
                                    format: 'dd/MM/y kk:mm'
                                  ),
                                  style: subtitle1.copyWith(
                                    color: kDarkColor,
                                    fontWeight: FontWeight.w400
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lController.getLang("Grand Total"),
                                  style: subtitle1.copyWith(color: kDarkLightColor),
                                ),
                                Text(
                                  priceFormat(
                                    orderTemp['grandTotal'] == null
                                      ? 0: double.parse(orderTemp['grandTotal'].toString()),
                                    lController
                                  ),
                                  style: title.copyWith(
                                    color: kDarkColor,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                            if(orderTemp?['hasDownPayment'] == 1 && (orderTemp?['missingPayment'] ?? 0) > 0)...[
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    lController.getLang("Pay Later"),
                                    style: subtitle1.copyWith(color: kAppColor),
                                  ),
                                  Text(
                                    priceFormat(
                                      orderTemp['missingPayment'] == null
                                        ? 0: double.parse(orderTemp['missingPayment'].toString()),
                                      lController
                                    ),
                                    style: title.copyWith(
                                      color: kAppColor,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            if(receivedCoupons.isNotEmpty)...[
                              const Gap(gap: kHalfGap),
                              ReceivedCoupons(
                                data: receivedCoupons,
                                onTap: _onTapCoupon,
                                lController: lController,
                                isCOD: (orderTemp?['paymentStatus'] ?? 0) == 1,
                              )
                            ]
                          ],
                        ),
                      ),
                    ),
                  )
                
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: kPaddingSafeButton,
              child: ButtonFull(
                title: lController.getLang("Continue Shopping"),
                onPressed: _onTapNext
              ),
            ),
          ),
          
          Align(
            alignment: Alignment.topCenter,
            child: _controllerCenter != null
            ? ConfettiWidget(
              confettiController: _controllerCenter!,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: pi / 2,
              gravity: 0.02, 
              emissionFrequency: 0.1,
              maximumSize: const Size(15, 8),
              minimumSize: const Size(10, 4),
              numberOfParticles: 50,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
              // createParticlePath: drawStar
            )
            : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  _onTapNext() {
    if(widget.subscription){
      Get.delete<SubscriptionConditionsController>();
      Get.delete<SubscriptionCheckoutController>();
      Get.delete<SubscriptionController>();
      Get.delete<SubscriptionCreateController>();
      Get.delete<SubscriptionsController>();
    }
      
    Get.offAll(() => const BottomNav());
  }

  _onTapCoupon(String id) =>
    Get.to(() => MyProductCouponScreen(id: id));
}
