import 'package:carousel_slider/carousel_options.dart';
import 'package:get/get.dart';

import '../../../models/index.dart';

class CarouselFullScreenController extends GetxController {
  final List<FileModel> images;
  final int initIndex;
  CarouselFullScreenController(this.images, this.initIndex);

  late final List<FileModel> _data = images;
  List<FileModel> get data => _data;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  
  @override
  void onInit() {
    super.onInit();
    _onInit();
  }

  Future<void> _onInit() async {
    _currentIndex = initIndex;
  }

  onPageChanged(int index, CarouselPageChangedReason carouselPageChangedReason) {
    _currentIndex = index;
    update();
  }
}