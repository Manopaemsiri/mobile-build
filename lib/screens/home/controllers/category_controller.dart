import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/index.dart';

class CategoryController extends GetxController {
  CategoryController();

  // Category
  ScrollController? controllerWidget;
  final double widgetWidth = kGap*2;
  double _move = 0.0;

  ScrollController? get controller => controllerWidget;
  double get width => widgetWidth;
  double get move => _move;

  @override
  void onInit() {
    _onInit();
    super.onInit();
  }
  Future<void> refreshController() async {
    _onInit();
  }
  _onInit() async {
    controllerWidget = ScrollController();
    await Future.delayed(const Duration(milliseconds: 250));
    if(controllerWidget?.hasListeners == true) controllerWidget?.removeListener((){});
    controllerWidget?.addListener(_scrollListener);
    update();
  }
  void _scrollListener() {
    double currentPixels = controllerWidget?.position.pixels ?? 0;
    double mainContainer = (controllerWidget?.position.maxScrollExtent ?? 0) / widgetWidth;
    _move = (currentPixels / mainContainer);
    update();
  }
  @override
  void onClose() {
    controllerWidget?.removeListener((){});
    controllerWidget?.dispose();
    super.onClose();
  }
}