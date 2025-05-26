// import 'package:coffee2u/apis/api_service.dart';
// import 'package:coffee2u/config/index.dart';
// import 'package:coffee2u/controller/customer_controller.dart';
// import 'package:coffee2u/controller/language_controller.dart';
// import 'package:coffee2u/models/index.dart';
// import 'package:coffee2u/screens/partner/shop/read.dart';
// import 'package:coffee2u/utils/index.dart';
// import 'package:coffee2u/widgets/index.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// const double _flex = 2.5;
// final double _screenwidth = DeviceUtils.getDeviceWidth();
// final double _cardWidth = _screenwidth / _flex;


// class PartnerShopsScreen extends StatefulWidget {
//   const PartnerShopsScreen({
//     Key? key,
//     this.type = '',
//     this.onPressed,
//   }) : super(key: key);

//   final String type;
//   final Function(PartnerShopModel)? onPressed;

//   @override
//   State<PartnerShopsScreen> createState() => _PartnerShopsScreenState();
// }

// class _PartnerShopsScreenState extends State<PartnerShopsScreen> {
//   final LanguageController lController = Get.find<LanguageController>();
//   final CustomerController _customerController = Get.find<CustomerController>();

//   List<PartnerShopModel> _data = [];

//   int page = 0;
//   bool isLoading = false;
//   bool isEnded = false;

//   @override
//   void initState() {
//     loadData();
//     super.initState();
//   }

//   Future<void> onRefresh() async {
//     setState(() {
//       page = 0;
//       isLoading = false;
//       isEnded = false;
//       _data = [];
//     });
//     loadData();
//   }

//   Future<void> loadData() async {
//     if (!isEnded && !isLoading) {
//       try {
//         page += 1;
//         setState(() {
//           isLoading = true;
//         });

//         ApiService.processList("partner-shops", input: {
//           "paginate": {"page": page, "pp": 10},
//           "dataFilter": {
//             "lat": _customerController.shippingAddress?.lat,
//             "lng": _customerController.shippingAddress?.lng,
//           }
//         }).then((value) {
//           PaginateModel paginateModel =
//               PaginateModel.fromJson(value?["paginate"]);

//           var len = value?["result"].length;
//           for (var i = 0; i < len; i++) {
//             PartnerShopModel model =
//                 PartnerShopModel.fromJson(value!["result"][i]);
//             _data.add(model);
//           }

//           setState(() {
//             _data;
//             if (_data.length >= paginateModel.total!) {
//               isEnded = true;
//               isLoading = false;
//             } else if (value != null) {
//               isLoading = false;
//             }
//           });
//         });
//       } catch (e) {}
//     }
//   }

//   void onLoadMore(info) async {
//     if (info.visibleFraction > 0 && !isEnded && !isLoading) {
//       await loadData();
//     }
//   }

//   Widget loaderWidget() {
//     return GridView.builder(
//       shrinkWrap: true,
//       itemCount: 2,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisExtent: 194,
//       ),
//       itemBuilder: (BuildContext context, int index) {
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(kRadius),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 100,
//                 width: double.infinity,
//                 color: kGrayLightColor,
//                 child: const Center(
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: widget.type == 'select'
//           ? Text(lController.getLang("Select Shop"))
//           : Text(lController.getLang("all_shops2")),
//         bottom: const AppBarDivider(),
//       ),
//       body: Stack(
//         children: [
//           RefreshIndicator(
//             onRefresh: onRefresh,
//             color: kAppColor,
//             child: SingleChildScrollView(
//               padding: kPadding,
//               child: Column(
//                 children: [
//                   _data.isEmpty
//                     ? const SizedBox(height: 0)
//                     : GridView.builder(
//                       shrinkWrap: true,
//                       itemCount: _data.length,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisExtent: 194,
//                       ),
//                       itemBuilder: (BuildContext context, int index) {
//                         PartnerShopModel item = _data[index];
//                         return CardShop(
//                           width: _cardWidth,
//                           model: item,
//                           onPressed: widget.onPressed != null
//                             ? () => widget.onPressed!(item)
//                             : () => _onTapShop(item.id ?? '')
//                         );
//                       },
//                     ),
//                   isEnded
//                     ? Padding(
//                       padding: const EdgeInsets.only(top: kGap, bottom: kGap),
//                       child: Text(
//                         lController.getLang("No more data"),
//                         textAlign: TextAlign.center,
//                         style: title.copyWith(
//                           fontWeight: FontWeight.w500,
//                           color: kGrayColor
//                         ),
//                       ),
//                     )
//                     : VisibilityDetector(
//                       key: const Key('loader-widget'),
//                       onVisibilityChanged: onLoadMore,
//                       child: loaderWidget()
//                     ),
//                 ],
//               )
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _onTapShop(String shopId) {
//     // Get.to(() => PartnerShopScreen(shopId: shopId));
//   }
// }
