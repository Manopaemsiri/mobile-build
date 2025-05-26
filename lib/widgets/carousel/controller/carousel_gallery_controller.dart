import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import '../../../models/index.dart';

class CarouselGalleryController extends GetxController {
  final List<FileModel> images;
  final int initIndex;
  CarouselGalleryController(this.images, {this.initIndex = 0});

  late final List<FileModel> _data = images;
  List<FileModel> get data => _data;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  CarouselSliderController? carouselController;
  
  @override
  void onInit() {
    super.onInit();
    _onInit();
  }

  Future<void> _onInit() async {
    carouselController = CarouselSliderController();
    _currentIndex = initIndex;
  }

  onPageChanged(int index, CarouselPageChangedReason carouselPageChangedReason) {
    _currentIndex = index;
    update();
  }

  animateToPage(int i){
    carouselController?.animateToPage(i);
  }

}