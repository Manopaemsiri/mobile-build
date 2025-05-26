import 'package:coffee2u/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxIdController extends GetxController {
  
  final LanguageController _lController = Get.find<LanguageController>();
  LanguageController get lController => _lController;

  final TextEditingController _cTaxId = TextEditingController();
  TextEditingController get cTaxId => _cTaxId;
  final FocusNode _fTaxId = FocusNode();  
  FocusNode get fTaxId => _fTaxId;  

  @override
  void onClose() {
    _cTaxId.dispose();
    _fTaxId.dispose();
    super.onClose();
  }
}