import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/index.dart';
import '../image/image_url.dart';
import 'controller/carousel_gallery_controller.dart';

class CarouselGallery extends StatelessWidget {
  const CarouselGallery({
    Key? key,
    required this.data,
    this.aspectRatio = 16/9,
    this.isShowIndicator = true,
    this.viewportFraction = 0.8,
    this.padding = const EdgeInsets.symmetric(horizontal: kGap),
  }) : super(key: key);
  final List<FileModel> data;
  final double aspectRatio;
  final bool isShowIndicator;

  final double viewportFraction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CarouselGalleryController>(
      init: CarouselGalleryController(data),
      builder: (controller) {
        return Column(
          children: [
            CarouselSlider.builder(
              carouselController: controller.carouselController,
              itemBuilder: (_, int index, int realIndex) => carouselCard(context, controller.data[index]),
              itemCount: data.length,
              options: CarouselOptions(
                autoPlay: false,
                aspectRatio: aspectRatio,
                viewportFraction: viewportFraction,
                onPageChanged: controller.onPageChanged,
                enableInfiniteScroll: controller.data.length > 1
              ),
            ),
            if(isShowIndicator && controller.data.length > 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.data.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => controller.animateToPage(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 450),
                      width: controller.currentIndex == entry.key? 29: 15,
                      height: 6,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: controller.currentIndex == entry.key? kAppColor: const Color(0xFFF5CDCB),
                        borderRadius: BorderRadius.circular(kCardRadius)
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        );
      }
    );
  }

  Widget carouselCard(
    BuildContext context,
    FileModel item
  ) {
    if(item.path.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: padding,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadius)
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: ClipRRect(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ImageUrl(
                  imageUrl: item.path,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}