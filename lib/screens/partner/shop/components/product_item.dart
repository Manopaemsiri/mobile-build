// import 'package:coffee2u/config/index.dart';
// import 'package:coffee2u/controller/app_controller.dart';
// import 'package:coffee2u/controller/customer_controller.dart';
// import 'package:coffee2u/controller/language_controller.dart';
// import 'package:coffee2u/models/index.dart';
// import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
// import 'package:coffee2u/widgets/index.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProductItem extends StatelessWidget {
//   const ProductItem({
//     super.key,
//     required this.data,
//     required this.onTap,
//     required this.onTapAdd,
//     required this.lController,
//     required this.aController,
//     this.trimDigits= false,
//     required this.showStock,
//   });

//   final PartnerProductModel data;
//   final VoidCallback onTap;
//   final VoidCallback onTapAdd;
//   final LanguageController lController;
//   final AppController aController;
//   final bool trimDigits;
//   final bool showStock;
  

//   @override
//   Widget build(BuildContext context) {
//     const double imageWidth = 88;
//     const double badgeWidth = imageWidth/2.5;

//     String _image = data.image?.path ?? '';
//     String _name = data.name;
//     String _price = data.isSetSaved()
//       ? data.displaySetSavedPrice(lController, trimDigits: trimDigits)
//       : data.displayPrice(lController, trimDigits: trimDigits);
//     String _memberPrice = data.isSetSaved()
//       ? data.displaySetSavedPrice(lController, trimDigits: trimDigits)
//       : data.isDiscounted() 
//         ? data.displayDiscountPrice(lController, trimDigits: trimDigits)
//         : data.displayMemberPrice(lController, trimDigits: trimDigits);
//     String _unit = "/ ${data.unit}";

//     PartnerProductStatusModel? _status;
//     if(aController.productStatuses.isNotEmpty && data.stock > 0){
//       final int index = aController.productStatuses.indexWhere((d) => d.productStatus == data.status && d.type != 1);
//       if(index > -1) _status = aController.productStatuses[index];
//     }
//     _status ??= data.productBadge(lController);

//     bool stockCenter = data.stockCenter > 0 && data.status != 1;
//     bool stockShop = data.stock > 0 && data.status != 1;

//     return GetBuilder<CustomerController>(builder: (controller) {
//       return InkWell(
//         onTap: onTap,
//         child: Container(
//           color: kWhiteColor,
//           child: Column(
//             children: [
//               Padding(
//                 padding: kPadding,
//                 child: Row(
//                   children: [
//                     Stack(
//                       children: [
//                         ImageProduct(
//                           imageUrl: _image,
//                           width: imageWidth,
//                           height: imageWidth,
//                         ),
//                         // if(_tag != null) ...[
//                         //   Positioned(top: 0, left: 0, child: _tag),
//                         // ],
//                         if(_status != null)...[
//                           if(_status.productStatus == 1)...[
//                             Positioned(
//                               top: 0, bottom: 0, left: 0, right: 0,
//                               child: Container(
//                                 width: imageWidth, height: imageWidth,
//                                 padding: const EdgeInsets.all(kQuarterGap),
//                                 color: kWhiteColor.withValues(alpha: 0.45),
//                                 child: Center(
//                                   child: Text(
//                                     'Coming\nSoon',
//                                     textAlign: TextAlign.center,
//                                     style: subtitle2.copyWith(
//                                       color: kDarkColor,
//                                       fontWeight: FontWeight.w800,
//                                       letterSpacing: 0.5,
//                                       height: 1.05,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ]else...[
//                             if(_status.type == 1)...[
//                               Positioned(
//                                 top: 0, left: 0,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(4),
//                                     color: _status.textBgColor2,
//                                   ),
//                                   child: Text(
//                                     _status.text,
//                                     style: caption.copyWith(
//                                       color: _status.textColor2,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ]else if(_status.type == 2)...[
//                               Positioned(
//                                 top: 0, left: 0,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(4),
//                                     color: _status.textBgColor2,
//                                   ),
//                                   child: Text(
//                                     data.isDiscounted()
//                                       ? _status.text.replaceAll('_DISCOUNT_PERCENT_', "${data.discountPercent()}")
//                                       : _status.text,
//                                     style: caption.copyWith(
//                                       color: _status.textColor2,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ]else if(_status.type == 3)...[
//                               Positioned(
//                                 top: 0, left: 0,
//                                 child: ImageProduct(
//                                   imageUrl: _status.icon?.path ?? '',
//                                   width: badgeWidth, 
//                                   height: badgeWidth,
//                                   decoration: const BoxDecoration(),
//                                   fit: BoxFit.contain,
//                                   alignment: Alignment.topLeft,
//                                 ),
//                               ),
//                             ]
//                           ]
//                         ]
//                       ],
//                     ),
//                     const SizedBox(width: kGap),
//                     SizedBox(
//                       width: Get.width - 88 - kGap*3,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 2),
//                           SizedBox(
//                             height: 48,
//                             child: Text(
//                               _name,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: subtitle1.copyWith(
//                                 fontWeight: FontWeight.w500,
//                                 height: 1.45
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           if(controller.isCustomer()) ...[
//                             RichText(
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               text: TextSpan(
//                                 text: _memberPrice,
//                                 style: headline6.copyWith(
//                                   fontFamily: 'Kanit',
//                                   color: kAppColor,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: " $_unit  ",
//                                     style: caption.copyWith(
//                                       fontFamily: 'Kanit',
//                                       color: kDarkColor,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                   if(data.isDiscounted() || data.isSetSaved()) ...[
//                                     TextSpan(
//                                       text: data.isSetSaved()
//                                       ? data.displaySetFullSavedPrice(lController, showSymbol: false, trimDigits: trimDigits)
//                                       : data.displayMemberPrice(lController, showSymbol: false, trimDigits: trimDigits),
//                                       style: subtitle1.copyWith(
//                                         fontFamily: 'Kanit',
//                                         color: kAppColor,
//                                         fontWeight: FontWeight.w500,
//                                         decoration: TextDecoration.lineThrough,
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ),
//                           ]
//                           else ...[
//                             RichText(
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               text: TextSpan(
//                                 text: _price,
//                                 style: headline6.copyWith(
//                                   fontFamily: 'Kanit',
//                                   color: kAppColor,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: " $_unit",
//                                     style: caption.copyWith(
//                                       fontFamily: 'Kanit',
//                                       color: kDarkColor,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                   if(data.isSetSaved())...[
//                                     TextSpan(
//                                       text: " ",
//                                       style: subtitle1.copyWith(
//                                         fontFamily: 'Kanit',
//                                         color: kAppColor,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: data.displaySetFullSavedPrice(lController, showSymbol: false, trimDigits: trimDigits),
//                                       style: subtitle1.copyWith(
//                                         fontFamily: 'Kanit',
//                                         color: kAppColor,
//                                         fontWeight: FontWeight.w500,
//                                         decoration: TextDecoration.lineThrough,
//                                       ),
//                                     ),
//                                   ]
//                                 ],
//                               ),
//                             ),
//                             if(data.signinPrice() < data.priceInVAT && !data.isSetSaved()) ...[
//                               const SizedBox(height: 2),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   InkWell(
//                                     onTap: () => Get.to(() => const SignInMenuScreen()),
//                                     child: BadgeDefault(
//                                       title: _memberPrice,
//                                       icon: FontAwesomeIcons.crown,
//                                       size: 15,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ],
                        
                          
//                           if(showStock)...[
//                             const SizedBox(height: 2),
//                             RichText(
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               textAlign: TextAlign.start,
//                               text: TextSpan(
//                                 text: lController.getLang("text_shipping"),
//                                 style: subtitle2.copyWith(
//                                   color: stockCenter? kAppColor.withValues(alpha: 0.8): kDarkLightGrayColor.withValues(alpha: 0.6),
//                                   fontWeight: FontWeight.w500,
//                                   fontFamily: "Kanit",
//                                 ),
//                                 children: <InlineSpan>[
//                                   const WidgetSpan(child: Gap(gap: kHalfGap)),
//                                   TextSpan(
//                                     text: lController.getLang("text_click_and_collect"),
//                                     style: subtitle2.copyWith(
//                                       color: stockShop? kAppColor.withValues(alpha: 0.8): kDarkLightGrayColor.withValues(alpha: 0.6),
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: "Kanit",
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
                          
//                           if(data.isValidDownPayment()) ...[
//                             RichText(
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               text: TextSpan(
//                                 text: lController.getLang("Deposit")+" ",
//                                 style: subtitle2.copyWith(
//                                   fontFamily: 'Kanit',
//                                   color: kDarkColor,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: data.displayDownPayment(lController, trimDigits: trimDigits),
//                                     style: title.copyWith(
//                                       fontFamily: 'Kanit',
//                                       color: kAppColor,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
