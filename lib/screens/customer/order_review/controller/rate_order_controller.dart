import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RateOrderController extends GetxController {
  final CustomerOrderModel customerOrder;
  RateOrderController(this.customerOrder);

  int stateStatus = 0;

  bool hideUsername = false;

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

  _onInit() async {
    try {
      final res = await ApiService.processRead('order-rating', input: { 'orderId': customerOrder.id });
      if(res?.isNotEmpty == true){
        CustomerOrderRatingModel model = CustomerOrderRatingModel.fromJson(res?['result']);
        final index = ratingDescription.indexWhere((d) =>  d['value']?.floor() == model.rating?.floor());
        if(index > -1) selectedRating = ratingDescription[index];
        comment.text = model.comment ?? '';
        if(model.images?.isNotEmpty == true) images = (model.images ?? []).map((e) => { 'type': 'FileModel', 'value': e }).toList();
        stateStatus = model.isValid()? 1: 2;
        update();
        return;
      }
    } catch (_) { }
    stateStatus = 1;
    update();
    return;
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
      if(dataImages.isNotEmpty){
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
      List<FileModel>? dataImages = [];
      if(images.isNotEmpty){
        List<XFile> tempImages = images.map((e) => e['type'] == 'XFile'? e['value'] as XFile: null).where((e) => e != null).cast<XFile>().toList();
        if(tempImages.isNotEmpty){
          List<FileModel>? dataFiles = await ApiService.uploadMultipleFile(
            tempImages,
            needLoading: true,
            folder: 'customer-order-ratings',
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
        'rating': selectedRating?['value']
      };
      if(hideUsername || Get.find<CustomerController>().isCustomer() == false) input['isAnonymous'] = 1;
      if(comment.text.isNotEmpty) input['comment'] = comment.text.trim();
      if(images.isNotEmpty) input['images'] = dataImages;

      return await ApiService.processUpdate('order-rating', input: input, needLoading: true);
    }else {
      ShowDialog.showErrorToast(
        title: lController.getLang("Error"),
        desc: lController.getLang('คุณยังไม่ได้ให้คะแนน'),
      );
    }
    return false;
  }
}