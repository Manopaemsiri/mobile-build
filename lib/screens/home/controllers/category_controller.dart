import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/index.dart';

class CategoryController extends GetxController {
  CategoryController();

  // Category
  ScrollController? _controller;
  final double _width = kGap*2;
  double _move = 0.0;

  ScrollController? get controller => _controller;
  double get width => _width;
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
    _controller = ScrollController();
    await Future.delayed(const Duration(milliseconds: 250));
    if(_controller?.hasListeners == true) _controller?.removeListener((){});
    _controller?.addListener(_scrollListener);
    update();
  }
  void _scrollListener() {
    double currentPixels = _controller?.position.pixels ?? 0;
    double mainContainer = (_controller?.position.maxScrollExtent ?? 0) / _width;
    _move = (currentPixels / mainContainer);
    update();
  }
  @override
  void onClose() {
    _controller?.removeListener((){});
    _controller?.dispose();
    super.onClose();
  }
}