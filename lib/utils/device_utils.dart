import 'package:flutter/material.dart';
import 'package:get/get.dart';

BuildContext context = Get.context!;

class DeviceUtils {
  static double getDeviceWidth() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return MediaQuery.of(context).size.width;
    }
    return MediaQuery.of(context).size.height;
  }
}
