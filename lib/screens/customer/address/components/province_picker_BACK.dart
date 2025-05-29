// import 'package:coffee2u/config/index.dart';
// import 'package:coffee2u/controller/language_controller.dart';
// import 'package:coffee2u/models/index.dart';
// import 'package:coffee2u/utils/index.dart';
// import 'package:coffee2u/widgets/index.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// class ProvincePicker<Classer> extends StatefulWidget {
//   const ProvincePicker({
//     super.key,
//     required this.model,
//     required this.onChanged,
//     this.showTitle = false,
//   });

//   final Classer model;
//   final Function(String, String, String, String) onChanged;
//   final bool showTitle;

//   @override
//   State<ProvincePicker> createState() => _ProvincePickerState();
// }

// class _ProvincePickerState extends State<ProvincePicker> {
//   final LanguageController lController = Get.find<LanguageController>();
//   bool isLoading = true;
//   late dynamic model;
  
//   final TextEditingController _cProvince = TextEditingController();
//   final TextEditingController _cDistrict = TextEditingController();
//   final TextEditingController _cSubdistrict = TextEditingController();
//   final TextEditingController _cZipcode = TextEditingController();

//   List<ProvinceModel> dataProvinces = [];
//   List<DistrictModel> dataDistricts = [];
//   List<SubdistrictModel> dataSubdistricts = [];
  
//   ProvinceModel? selectedProvince;
//   DistrictModel? selectedDistrict;
//   SubdistrictModel? selectedSubdistrict;
//   String selectedZipcode = '';
  
//   List<DistrictModel> districts = [];
//   List<SubdistrictModel> subdistricts = [];
//   List<SubdistrictModel> zipcodes = [];

//   updateProvince(String _s) async {
//     setState(() {
//       selectedProvince = null;
//       selectedDistrict = null;
//       selectedSubdistrict = null;
//       selectedZipcode = '';
//       districts = [];
//       subdistricts = [];
//       zipcodes = [];

//       _cProvince.text = '';
//       _cDistrict.text = '';
//       _cSubdistrict.text = '';
//       _cZipcode.text = '';
//     });
//     if(_s != ''){
//       List<ProvinceModel> temp = dataProvinces
//         .where((_d) => _d.name == _s).toList();
//       if(temp.isNotEmpty){
//         setState(() {
//           _cProvince.text = _s;
//           selectedProvince = temp[0];
//           districts = dataDistricts
//             .where((_d) => _d.provinceId == temp[0].id).toList();
//         });
//       }
//     }
//   }
//   updateDistricts(String _s) async {
//     setState(() {
//       selectedDistrict = null;
//       selectedSubdistrict = null;
//       selectedZipcode = '';
//       subdistricts = [];
//       zipcodes = [];

//       _cDistrict.text = '';
//       _cSubdistrict.text = '';
//       _cZipcode.text = '';
//     });
//     if(selectedProvince != null && _s != ''){
//       List<DistrictModel> temp = dataDistricts
//         .where((_d) => _d.name == _s 
//           && _d.provinceId == selectedProvince?.id).toList();
//       if(temp.isNotEmpty){
//         setState(() {
//           _cDistrict.text = _s;
//           selectedDistrict = temp[0];
//           subdistricts = dataSubdistricts
//             .where((_d) => _d.districtId == temp[0].id).toList();
//         });
//       }
//     }
//   }
//   updateSubdistrict(String _s) async {
//     setState(() {
//       selectedSubdistrict = null;
//       selectedZipcode = '';
//       zipcodes = [];

//       _cSubdistrict.text = '';
//       _cZipcode.text = '';
//     });
//     if(selectedProvince != null && selectedDistrict != null && _s != ''){
//       List<SubdistrictModel> temp = dataSubdistricts
//         .where((_d) => _d.name == _s 
//           && _d.districtId == selectedDistrict?.id).toList();
//       if(temp.isNotEmpty){
//         setState(() {
//           _cSubdistrict.text = _s;
//           selectedSubdistrict = temp[0];
//           _cZipcode.text = temp[0].zipcodes.isNotEmpty? temp[0].zipcodes[0]: '';
//           zipcodes = temp;
//         });
//       }
//     }
//   }

//   _initState() async {
//     List<ProvinceModel> _dataProvinces = await widget.model.loadProvinces();
//     List<DistrictModel> _dataDistricts = await widget.model.loadDistricts();
//     List<SubdistrictModel> _dataSubdistricts = await widget.model.loadSubdistricts();
//     setState(() {
//       model = widget.model;
//       dataProvinces = _dataProvinces;
//       dataDistricts = _dataDistricts;
//       dataSubdistricts = _dataSubdistricts;

//       _cProvince.text = model.province.name;
//       _cDistrict.text = model.district.name;
//       _cSubdistrict.text = model.subdistrict.name;
//       _cZipcode.text = model.zipcodes.name;
//     });

//     if(model.province != ''){
//       List<ProvinceModel> _temp1 = _dataProvinces
//         .where((_d) => _d.name == model.province).toList();
//       if(_temp1.isNotEmpty){
//         setState(() {
//           _cProvince.text = model.province;
//           selectedProvince = _temp1[0];
//           districts = dataDistricts
//             .where((_d) => _d.provinceId == _temp1[0].id).toList();
//         });
//       }
//     }
//     if(model.district != ''){
//       List<DistrictModel> _temp2 = _dataDistricts
//         .where((_d) => _d.name == model.district).toList();
//       if(_temp2.isNotEmpty){
//         setState(() {
//           _cDistrict.text = model.district;
//           selectedDistrict = _temp2[0];
//           subdistricts = dataSubdistricts
//             .where((_d) => _d.districtId == _temp2[0].id).toList();
//         });
//       }
//     }
//     if(model.subdistrict != ''){
//       List<SubdistrictModel> _temp3 = _dataSubdistricts
//         .where((_d) => _d.name == model.subdistrict 
//           && _d.districtId == selectedDistrict?.id).toList();
//       if(_temp3.isNotEmpty){
//         setState(() {
//           _cSubdistrict.text = model.subdistrict;
//           selectedSubdistrict = _temp3[0];
//           zipcodes = _temp3;
//         });
//         if(model.zipcodes != ''){
//           setState(() {
//             _cZipcode.text = model.zipcodes;
//           });
//         }
//       }
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     _initState();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//       ? const SizedBox.shrink()
//       : Column(
//         children: [
//           if (widget.showTitle) ...[
//             LabelText(
//               text: lController.getLang("Province"),
//               isRequired: true
//             ),
//             const Gap(gap: kHalfGap),
//           ],
          
//           TextFormField(
//             controller: _cProvince,
//             showCursor: false,
//             readOnly: true,
//             decoration: InputDecoration(
//               border: const OutlineInputBorder(),
//               labelText: '${lController.getLang("Province")} *',
//               alignLabelWithHint: true,
//               suffixIcon: const Icon(
//                 Icons.arrow_drop_down,
//               ),
//             ),
//             validator: (value) => Utils.validateString(value),
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(4.0),
//                   ),
//                 ),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 builder: (context) {
//                   return FractionallySizedBox(
//                     heightFactor: 0.8,
//                     child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setModalState) {
//                         return Column(
//                           children: [
//                             Padding(
//                               padding: kPadding,
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Container(
//                                   width: 80,
//                                   height: 8,
//                                   padding: kPadding,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade300,
//                                     borderRadius: BorderRadius.circular(4.0),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: ListView(
//                                 shrinkWrap: true,
//                                 children: [
//                                   Wrap(
//                                     children: dataProvinces.map((ProvinceModel _d) {
//                                       return ListTile(
//                                         title: Text(_d.name),
//                                         onTap: (){
//                                           updateProvince(_d.name);
//                                           widget.onChanged(_d.name, '', '', '');
//                                           Get.back();
//                                         },
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   );
//                 },
//                 isScrollControlled: true,
//               );
//             },
//           ),
//           const Gap(),

//           if (widget.showTitle) ...[
//             LabelText(
//               text: lController.getLang("District"),
//               isRequired: true
//             ),
//             const Gap(gap: kHalfGap),
//           ],
//           TextFormField(
//             controller: _cDistrict,
//             enabled: _cProvince.text != '',
//             showCursor: false,
//             readOnly: true,
//             decoration: InputDecoration(
//               border: const OutlineInputBorder(),
//               labelText: '${model.prefixDistrict(lController)} *',
//               alignLabelWithHint: true,
//               suffixIcon: const Icon(Icons.arrow_drop_down),
//             ),
//             validator: (value) => Utils.validateString(value),
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
//                 ),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 builder: (context) {
//                   return FractionallySizedBox(
//                     heightFactor: 0.8,
//                     child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setModalState) {
//                         if (selectedProvince != null) {
//                           return Column(
//                             children: [
//                               Padding(
//                                 padding: kPadding,
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Container(
//                                     width: 80,
//                                     height: 8,
//                                     padding: kPadding,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey.shade300,
//                                       borderRadius: BorderRadius.circular(4.0),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: ListView(
//                                   shrinkWrap: true,
//                                   children: [
//                                     Wrap(
//                                       children: districts.map((DistrictModel _d) {
//                                         return ListTile(
//                                           title: Text(_d.name),
//                                           onTap: () {
//                                             updateDistricts(_d.name);
//                                             widget.onChanged(
//                                               selectedProvince?.name ?? '',
//                                               _d.name, '', ''
//                                             );
//                                             Get.back();
//                                           },
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         } else {
//                           return NoDataCoffeeMug(
//                             titleText: 'Please select a province',
//                           );
//                         }
//                       },
//                     ),
//                   );
//                 },
//                 isScrollControlled: true,
//               );
//             },
//           ),
//           const Gap(),

//           if (widget.showTitle) ...[
//             LabelText(
//               text: lController.getLang("Subdistrict"),
//               isRequired: true
//             ),
//             const Gap(gap: kHalfGap),
//           ],
//           TextFormField(
//             controller: _cSubdistrict,
//             enabled: _cDistrict.text != '',
//             showCursor: false,
//             readOnly: true,
//             decoration: InputDecoration(
//               border: const OutlineInputBorder(),
//               labelText: '${model.prefixSubdistrict(lController)} *',
//               alignLabelWithHint: true,
//               suffixIcon: const Icon(Icons.arrow_drop_down),
//             ),
//             validator: (value) => Utils.validateString(value),
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
//                 ),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 builder: (context) {
//                   return FractionallySizedBox(
//                     heightFactor: 0.8,
//                     child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setModalState) {
//                         if (selectedDistrict != null) {
//                           return Column(
//                             children: [
//                               Padding(
//                                 padding: kPadding,
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Container(
//                                     width: 80,
//                                     height: 8,
//                                     padding: kPadding,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey.shade300,
//                                       borderRadius: BorderRadius.circular(4.0),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: ListView(
//                                   shrinkWrap: true,
//                                   children: [
//                                     Wrap(
//                                       children: subdistricts.map((SubdistrictModel _d) {
//                                         return ListTile(
//                                           title: Text(_d.name),
//                                           onTap: () {
//                                             updateSubdistrict(_d.name);
//                                             widget.onChanged(
//                                               selectedProvince?.name ?? '',
//                                               selectedDistrict?.name ?? '',
//                                               _d.name, _d.zipcodes.isNotEmpty? _d.zipcodes[0]: ''
//                                             );
//                                             Get.back();
//                                           },
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         } else {
//                           return NoDataCoffeeMug(
//                             titleText: 'Please select a district',
//                           );
//                         }
//                       },
//                     ),
//                   );
//                 },
//                 isScrollControlled: true,
//               );
//             },
//           ),
//           const Gap(),

//           if (widget.showTitle) ...[
//             LabelText(
//               text: lController.getLang("ZIP Code"),
//               isRequired: true
//             ),
//             const Gap(gap: kHalfGap),
//           ],
//           TextFormField(
//             controller: _cZipcode,
//             enabled: _cSubdistrict.text != '',
//             showCursor: false,
//             readOnly: true,
//             decoration: InputDecoration(
//               border: const OutlineInputBorder(),
//               labelText: '${lController.getLang("ZIP Code")} *',
//               alignLabelWithHint: true,
//               suffixIcon: const Icon(
//                 Icons.arrow_drop_down,
//               ),
//             ),
//             validator: (value) => Utils.validateString(value),
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(4.0),
//                   ),
//                 ),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 builder: (context) {
//                   return FractionallySizedBox(
//                     heightFactor: 0.8,
//                     child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setModalState) {
//                         if (selectedSubdistrict != null) {
//                           return Column(
//                             children: [
//                               Padding(
//                                 padding: kPadding,
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Container(
//                                     width: 80,
//                                     height: 8,
//                                     padding: kPadding,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey.shade300,
//                                       borderRadius: BorderRadius.circular(4.0),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: ListView(
//                                   shrinkWrap: true,
//                                   children: [
//                                     Wrap(
//                                       children: zipcodes.map((SubdistrictModel _d) {
//                                         return ListTile(
//                                           title: Text(_d.zipcodes[0]),
//                                           onTap: () {
//                                             setState(() {
//                                               selectedZipcode = _d.zipcodes[0];
//                                               _cZipcode.text = _d.zipcodes[0];
//                                             });
//                                             widget.onChanged(
//                                               selectedProvince?.name ?? '',
//                                               selectedDistrict?.name ?? '',
//                                               selectedSubdistrict?.name ?? '',
//                                               _d.zipcodes[0]
//                                             );
//                                             Get.back();
//                                           },
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         } else {
//                           return NoDataCoffeeMug(
//                             titleText: 'Please select a subdistrict',
//                           );
//                         }
//                       },
//                     ),
//                   );
//                 },
//                 isScrollControlled: true,
//               );
//             },
//           ),
        
//         ],
//       );
//   }
// }