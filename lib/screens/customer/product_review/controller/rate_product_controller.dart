import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// stateStatus
//   - 0: Loading
//   - 1: Done
//   - 2: Done No Data Found
//   - 3: Error

class RateProductController extends GetxController {
  final CustomerOrderModel customerOrder;
  RateProductController(this.customerOrder);

  int stateStatus = 0;

  bool hideUsername = false;

  // Products
  List<PartnerProductModel> products = [];
  List<PartnerProductModel> selectedProducts = [];

  // Star
  Map<String, dynamic>? selectedRating;
  List<Map<String, dynamic>> ratingDescription = [
    { 'id': 0, 'value': 1.0, 'name': 'rating_1' },
    { 'id': 1, 'value': 2.0, 'name': 'rating_2' },
    { 'id': 2, 'value': 3.0, 'name': 'rating_3' },
    { 'id': 3, 'value': 4.0, 'name': 'rating_4' },
    { 'id': 4, 'value': 5.0, 'name': 'rating_5' },
  ];

  final ImagePicker picker = ImagePicker();
  int maxImage = 3;
  List<Map<String, dynamic>> images = [];

  TextEditingController comment = TextEditingController();
  FocusNode commentFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();
    _onInit();
  }

  Future<void> _onInit() async {
    await Future.wait([
      _readData(),
      _getData(),
    ]);
  }
  Future<void> _readData() async {
    try {
      final res = await ApiService.processRead('partner-product-rating', input: { 'orderId': customerOrder.id });
      if(res?.isNotEmpty == true){
        PartnerProductRatingModel model = PartnerProductRatingModel.fromJson(res?['result']);
        final index = ratingDescription.indexWhere((d) =>  d['value']?.floor() == model.rating?.floor());
        if(index > -1) selectedRating = ratingDescription[index];
        comment.text = model.comment ?? '';
        if(model.products?.isNotEmpty == true) selectedProducts = model.products ?? [];
        if(model.images?.isNotEmpty == true) images = (model.images ?? []).map((e) => { 'type': 'FileModel', 'value': e }).toList();
        stateStatus = model.isValid()? 1: 2;
        update();
        return;
      }
    } catch (_) {}
    stateStatus = 1;
    update();
    return;
  }
  Future<void> _getData() async {
    products.map((e) => e.id).toSet().toList();

    List<PartnerProductModel> uniqueProducts = [];
    Set<String> seenIds = {};
    for (var p in customerOrder.products) {
      if (!seenIds.contains(p.id)) {
        uniqueProducts.add(p);
        seenIds.add(p.id!);
      }
    }
    products = uniqueProducts;
  }

  onChangedProduct(bool? value, PartnerProductModel product) {
    if(value != null && product.isValid()){
      final index = selectedProducts.indexWhere((d) => d.id == product.id);
      if(index > -1){
        selectedProducts.removeAt(index);
      }else {
        selectedProducts.add(product);
      }
      update();
    }
  }

  onChangedRating(Map<String, dynamic> value){
    final index = ratingDescription.indexWhere((d) => d['id'] == value['id']);
    if(index > -1){
      selectedRating = ratingDescription[index];
      update();
    }
  }

  imagePicker({ ImageSource source = ImageSource.gallery }) async {
    Get.back();
    if(source == ImageSource.gallery){
      List<XFile>? dataImages = await picker.pickMultiImage();
      if(dataImages.isNotEmpty == true){
        dataImages = dataImages.sublist(0, maxImage-images.length > dataImages.length? dataImages.length: maxImage-images.length);
        images = [
          ...images,
          ...dataImages.map((e) => { 'type': 'XFile', 'value': e })
        ];
      }
    }else{
      XFile? widgetImage = await picker.pickImage(source: source);
      if(widgetImage != null){
        images = [
          ...images,
          { 'type': 'XFile', 'value': widgetImage }
        ];
      }
    }
    update();
  } 
  onDeleteImage(int index) async {
    try {
      dynamic widgetImage = images[index];
      if(widgetImage != null && images.isNotEmpty) images.removeAt(index);
    } catch (_) {}
    update();
  }

  Future<bool> onSubmit() async {
    if(selectedRating != null){
      List<String> productIds = selectedProducts.map((d) => d.id ?? '').where((e) => e.isNotEmpty).toList();
      if(productIds.isEmpty){
        List<PartnerProductModel> uniqueProducts = [];
        Set<String> seenIds = {};
        for (var p in customerOrder.products) {
          if (!seenIds.contains(p.id)) {
            uniqueProducts.add(p);
            seenIds.add(p.id!);
          }
        }
        productIds = uniqueProducts.map((d) => d.id ?? '').where((e) => e.isNotEmpty).toList();
      }
      List<FileModel>? dataImages = [];
      if(images.isNotEmpty){
        List<XFile> tempImages = images.map((e) => e['type'] == 'XFile'? e['value'] as XFile: null).where((e) => e != null).cast<XFile>().toList();
        if(tempImages.isNotEmpty){
          List<FileModel>? dataFiles = await ApiService.uploadMultipleFile(
            tempImages,
            needLoading: true,
            folder: 'partner-product-ratings',
            resize: 950,
          );
          if(dataFiles?.isNotEmpty == true){
            for (var d in dataFiles!) {
              if(d.isValid()) dataImages.add(d);
            }
          }
        }
        List<FileModel> tempImagesFileModel = images.map((e) => e['type'] == 'FileModel'? e['value'] as FileModel: null).where((e) => e != null).cast<FileModel>().toList();
        if(tempImagesFileModel.isNotEmpty){
          dataImages = [
            ...tempImagesFileModel,
            ...dataImages,
          ];
        }
      }
      Map<String, dynamic> input = {
        'orderId': customerOrder.id,
        'productIds': productIds,
        'rating': selectedRating?['value']
      };
      if(hideUsername || Get.find<CustomerController>().isCustomer() == false) input['isAnonymous'] = 1;
      if(comment.text.isNotEmpty) input['comment'] = comment.text.trim();
      if(images.isNotEmpty) input['images'] = dataImages;

      return await ApiService.processUpdate('partner-product-rating', input: input, needLoading: true);
    }else {
      ShowDialog.showErrorToast(
        title: lController.getLang("Error"),
        desc: lController.getLang('คุณยังไม่ได้ให้คะแนน'),
      );
    }
    return false;
  }
}