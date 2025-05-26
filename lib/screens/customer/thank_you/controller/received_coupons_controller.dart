import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import '../../../../models/partner_product_coupon_log_model.dart';

class ReceivedCouponsController extends GetxController {
  final List<PartnerProductCouponLogModel> data;
  ReceivedCouponsController(this.data);

  int _currentIndex = 0;
  final CarouselSliderController _pageController = CarouselSliderController();

  CarouselSliderController get pageController => _pageController;
  int get currentIndex => _currentIndex;

  onPageChanged(int index) {
    _currentIndex = index;
    update();
  }

}