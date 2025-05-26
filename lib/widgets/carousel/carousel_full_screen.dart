import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import 'controller/carousel_full_screen_controller.dart';

class CarouselFullScreen extends StatelessWidget {
  const CarouselFullScreen({
    Key? key,
    required this.images,
    this.initIndex = 0,
  }) : super(key: key);

  final List<FileModel> images;
  final int initIndex;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarouselFullScreenController>(
      init: CarouselFullScreenController(images, initIndex),
      builder: (controller) {

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light,
            ),
            backgroundColor: Colors.black,
            foregroundColor: kWhiteColor,
            title: controller.data.length > 1
            ? Container(
              padding: const EdgeInsets.symmetric(horizontal: kHalfGap),
              decoration: BoxDecoration(
                color: kDarkLightColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(kRadius)
              ),
              child: Text(
                '${controller.currentIndex+1}/${controller.data.length}',
                style: caption.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
            )
            : null,
          ),
          body: CarouselSlider(
            items: _body(context, controller.data),
            options: CarouselOptions(
              initialPage: controller.currentIndex,
              aspectRatio: Get.width/Get.height,
              viewportFraction: 1,
              onPageChanged: controller.onPageChanged,
              enableInfiniteScroll: controller.data.length > 1,
              pageSnapping: true,
              // padEnds: widget.padEnds
            ),
          ),
        );
      }
    );
  }

  List<Widget> _body(BuildContext context, List<FileModel> values) {

    return values.map((value){
      return Container(
        // margin: EdgeInsets.symmetric(horizontal: margin),
        color: kDarkColor,
        child: ClipRRect(
          // borderRadius: widget.radius,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: PhotoView(
              imageProvider: NetworkImage(
                value.path,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}