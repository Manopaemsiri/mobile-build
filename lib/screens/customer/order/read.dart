import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/firebase_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/checkout/read.dart';
import 'package:coffee2u/screens/customer/message/read.dart';
import 'package:coffee2u/screens/customer/order/components/order_product.dart';
import 'package:coffee2u/screens/customer/order/components/order_shipping.dart';
import 'package:coffee2u/screens/customer/order/components/order_shipping_history.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../order_review/create.dart';
import '../product_review/create.dart';

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({
    super.key,
    required this.orderId
  });
  
  final String orderId;

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  late final String orderId = widget.orderId;
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  final FirebaseController _firebaseController = Get.find<FirebaseController>();

  bool isLoading = true;
  bool enabledReturn = false;
  CustomerOrderModel? model;

  _initState() async {
    try {
      final res = await ApiService.processRead(
        'order',
        input: { "_id": orderId }
      );
    
      if(mounted){
        setState(() {
          model = CustomerOrderModel.fromJson(res?['result']);
          isLoading = false;
        });
      }
    } catch (e) {
      if(kDebugMode) printError(info: '$e');
      if(mounted) {
        setState(() {
          isLoading = false;
          model = null;
        });
      }
    }
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text(
          lController.getLang("Order Detail")
        ),
        actions: [
          if(_firebaseController.isInit && model != null) ...[
            RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: _onTapContact,
              elevation: 0,
              focusElevation: 1,
              hoverElevation: 1,
              highlightElevation: 0,
              disabledElevation: 0,
              fillColor: _customerController.isCustomer() 
                && !model!.isReturned()
                  ? kAppColor: kGrayColor,
              constraints: const BoxConstraints(
                maxWidth: 30,
                maxHeight: 30
              ),
              child: SvgPicture.asset(
                'assets/icons/support.svg',
                width: kGap,
                height: kGap,
              ),
              padding: const EdgeInsets.all(kHalfGap),
              shape: const CircleBorder(),
            ),
            const Gap()
          ],
        ],
      ),
      body: isLoading && model == null
        ? const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
        : !isLoading && model == null
          ? NoData()
          : ListView(
          children: [
            const DividerThick(),
            Container(
              padding: kPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${lController.getLang("Order ID")} ${model?.orderId}',
                    style: title.copyWith(
                      color: kDarkColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    model?.displayDeliveryDetail(lController) ?? '',
                    style: subtitle1.copyWith(
                      color: kAppColor,
                    ),
                  ),
                  Text(
                    model?.displayPaymentStatus(lController) ?? '',
                    style: subtitle1.copyWith(
                      color: kDarkColor,
                    ),
                  ),
                  if(model?.subscription != null)...[
                    const Gap(gap: kQuarterGap),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: kQuarterGap/2, horizontal: kQuarterGap),
                      decoration: BoxDecoration(
                        color: kYellowColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(kRadius)
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                FontAwesomeIcons.crown,
                                color: kYellowColor,
                                size: subtitle2.fontSize! * 0.8,
                              ),
                            ),
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: SizedBox(width: kHalfGap)
                            ),
                            TextSpan(
                              text: 'Subscription',
                              style: subtitle2.copyWith(
                                color: kYellowColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Kanit'
                              ),
                            ),
                          ]
                        ),
                      )
                    )
                  ]
                ],
              ),
            ),
            const DividerThick(),
            
            OrderShipping(model: model!, lController: lController),
            const Divider(
              height: 1,
              thickness: kHalfGap,
              color: kWhiteSmokeColor,
            ),
            OrderProduct(
              model: model!,
              lController: lController,
              fromSubscription: model?.subscription != null,
            ),
            const DividerThick(),

            Padding(
              padding: kPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.solidMoneyBill1,
                        color: kAppColor,
                        size: 18,
                      ),
                      const SizedBox(width: kGap),
                      Text(
                        model?.displayPaymentStatus(lController) ?? '',
                        style: subtitle1.copyWith(
                          color: kAppColor,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  (model?.paymentStatus ?? 0) > 1
                    ? Padding(
                      padding: const EdgeInsets.only(top: kQuarterGap, left: 34),
                      child: Text(
                        '${lController.getLang("Payment at")} ${dateFormat(model?.paymentDate ?? DateTime.now(), format: 'dd/MM/y kk:mm')}',
                        style: subtitle1.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ): const SizedBox.shrink(),
                ],
              ),
            ),
            const DividerThick(),

            if(model?.note.isNotEmpty == true) ...[
              Padding(
                padding: kPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.solidCommentDots,
                          color: kAppColor,
                          size: 18,
                        ),
                        const SizedBox(width: kGap),
                        Text(
                          lController.getLang("More Details"),
                          style: subtitle1.copyWith(
                            color: kAppColor,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: kQuarterGap, left: 34),
                      child: Text(
                        model?.note ?? '',
                        style: subtitle2.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const DividerThick(),
            ],

            if((model?.hasRatedOrder == true || model?.hasRatedProduct == true) && model?.subscription == null)...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: kGap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kGap),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.reviews_rounded,
                            color: kAppColor,
                            size: 18,
                          ),
                          const SizedBox(width: kGap),
                          Text(
                            lController.getLang('Your Review'),
                            style: subtitle1.copyWith(
                              color: kAppColor,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(gap: kQuarterGap),
                    Row(
                      children: [
                        if(model?.hasRatedProduct == true)...[
                          const Gap(),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(kHalfGap),
                              decoration: BoxDecoration(
                                color: kDarkLightGrayColor.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(kRadius)
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    lController.getLang('Product Rating'),
                                    style: subtitle2.copyWith(
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: kYellowColor,
                                        size: subtitle2.fontSize!*1.2,
                                      ),
                                      const Gap(gap: kQuarterGap),
                                      Text(
                                        '${model?.productRating?.rating}',
                                        style: subtitle2.copyWith(
                                          fontWeight: FontWeight.w300
                                        ),
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: onTapHasRatedProduct,
                                    child: Text(
                                      lController.getLang('see review'),
                                      style: subtitle2.copyWith(
                                        decoration: TextDecoration.underline
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ),
                        ],
                        if(model?.hasRatedOrder == true)...[
                          const Gap(),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(kHalfGap),
                              decoration: BoxDecoration(
                                color: kDarkLightGrayColor.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(kRadius)
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    lController.getLang('Order Score'),
                                    style: subtitle2.copyWith(
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          color: kYellowColor,
                                          size: subtitle2.fontSize!*1.2,
                                        ),
                                        const Gap(gap: kQuarterGap),
                                        Text(
                                          '${model?.orderRating?.rating}',
                                          style: subtitle2.copyWith(
                                            fontWeight: FontWeight.w400
                                          ),
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: onTapHasRatedOrder,
                                      child: Text(
                                        lController.getLang('see review'),
                                        style: subtitle2.copyWith(
                                          decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            )
                          ),
                        ],
                        if(!(model?.hasRatedOrder == true && model?.hasRatedProduct == true)) const Spacer(),
                        const Gap(),
                      ],
                    ),
                  ],
                ),
              )
            ],

            OrderShippingHistory(model: model, lController: lController),
            const DividerThick(),
          ],
        ),
      bottomNavigationBar: isLoading || model == null || model?.subscription != null
        ? const SizedBox.shrink() 
        : Padding(
          padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(model?.canRateProduct()) ...[
                    Expanded(
                      child: ButtonSmall(
                        title: lController.getLang("Product Review"),
                        titleStyle: subtitle1.copyWith(
                          fontWeight: FontWeight.w500
                        ),
                        width: double.infinity,
                        color: model!.isReceived()
                          ? kAppColor: kGrayColor,
                        onPressed: _onTapProductReview,
                      ),
                    ),
                    const Gap(gap: kHalfGap),
                  ],
                  if(model?.canRateOrder()) ...[
                    Expanded(
                      child: ButtonSmall(
                        title: lController.getLang("Order Review"),
                        titleStyle: subtitle1.copyWith(
                          fontWeight: FontWeight.w500
                        ),
                        width: double.infinity,
                        color: model!.isReceived()
                          ? kAppColor: kGrayColor,
                        onPressed: _onTapOrderReview,
                      ),
                    ),
                    const Gap(gap: kHalfGap),
                  ],
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(enabledReturn) ...[
                    Expanded(
                      child: ButtonSmall(
                        title: lController.getLang("Cancel"),
                        titleStyle: subtitle1.copyWith(
                          fontWeight: FontWeight.w500
                        ),
                        width: double.infinity,
                        color: model!.isReceived()
                          ? kAppColor: kGrayColor,
                        onPressed: _onTapCancel,
                      ),
                    ),
                    const Gap(gap: kHalfGap),
                  ],
                  Expanded(
                    child: ButtonSmall(
                      title: lController.getLang("Buy Again"),
                      titleStyle: subtitle1.copyWith(
                        fontWeight: FontWeight.w500
                      ),
                      width: double.infinity,
                      onPressed: _onTapBuyAgain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

  void _onTapCancel() {}

  void _onTapContact() async {
    if(_customerController.isCustomer() && !model!.isReturned()){
      CustomerChatroomModel chatroom = await ApiService.chatroomCreate(model?.id ?? '');
      if(chatroom.isValid()){
        bool res = await _firebaseController.sendMessage(
          chatroom, checkRoom: true,
          text: '${lController.getLang("Contact about order")} ${model?.orderId}'
        );
        if(res){
          Get.to(() => MessageScreen(model: chatroom));
        }
      }
    }
  }

  void _onTapBuyAgain() async {
    if(model!.isValid() && model?.products.isNotEmpty == true){
      ShowDialog.showForceDialog(
        lController.getLang("Buy Again"),
        lController.getLang("text_order_again_1"),
        () async {
          await _customerController.updateCartBuyAgain(
            model?.shop?.id ?? '',
            model?.products ?? [],
          );
          Get.back();
          Get.to(() => const CheckOutScreen());
        },
        onCancel: () => Get.back(),
        confirmText: lController.getLang("Yes"),
        cancelText: lController.getLang("No"),
      );
    }
  }

  _onTapProductReview() async {
    if(model != null){
      Get.to(() => ProductReviewScreen(customerOrder: model!))?.then((_) => _readOrder());
    } 
  }
  _onTapOrderReview() {
    if(model != null){
      Get.to(() => OrderReviewScreen(customerOrder: model!))?.then((_) => _readOrder());
    } 
  }
  _readOrder() async {
    try {
      final res = await ApiService.processRead(
        'order',
        input: { "_id": orderId }
      );
      if(mounted) setState(() => model = CustomerOrderModel.fromJson(res?['result']));
    } catch (_) {}
  }

  onTapHasRatedProduct() {
    if(model != null){
      Get.to(() => ProductReviewScreen(customerOrder: model!))?.then((_) => _readOrder());
    } 
  }
    // Get.to(() => ProductReviewReadScreen(id: model?.productRating?.id ?? '', mainProduct: model?.products));
  onTapHasRatedOrder() {
    if(model != null){
      Get.to(() => OrderReviewScreen(customerOrder: model!))?.then((_) => _readOrder());
    } 
  }
    // Get.to(() => OrderReviewReadScreen(orderId: model?.id ?? ''));
}