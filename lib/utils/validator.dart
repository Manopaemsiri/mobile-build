import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:get/get.dart';
final LanguageController lController = Get.find<LanguageController>();

String? validateString(String? value) {
  if (value == null || value.isEmpty) {
    return lController.getLang('text_error_required_1');
  }
  return null;
}

String? validatatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return '${lController.getLang("text_error_telephone_1")}!';
  } else if (value.length != 10) {
    return '${lController.getLang("text_error_telephone_2")}!';
  } else if (!Utils.isNumeric(value)) {
    return '${lController.getLang("text_error_telephone_3")}!';
  }
  return null;
}

String? validatateNumber(String? value) {
  if (value == null || value.isEmpty) {
    return '${lController.getLang("text_error_telephone_1")}!';
  } else if (!Utils.isNumeric(value)) {
    return '${lController.getLang("text_error_telephone_3")}!';
  }
  return null;
}
