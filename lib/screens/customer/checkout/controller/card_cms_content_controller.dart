import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee2u/models/index.dart';
import 'package:get/get.dart';

class CardCmsContentController extends GetxController {
  final List<CmsContentModel> data;
  CardCmsContentController(this.data);

  int _currentIndex = 0;
  final CarouselSliderController _pageController = CarouselSliderController();

  CarouselSliderController get pageController => _pageController;
  int get currentIndex => _currentIndex;

  onPageChanged(int index) {
    _currentIndex = index;
    update();
  }

}