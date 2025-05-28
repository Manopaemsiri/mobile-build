import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/cms/content/read.dart';
import 'package:coffee2u/screens/web_view/web_view_screen.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.cmsBannerModel,
    this.isShowIndicator = true,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 1,
    this.margin = 6.0,
    this.radius = const BorderRadius.all(Radius.circular(5.0)),
    this.isPopImage = false,
  });

  final List<CmsBannerModel> cmsBannerModel;
  final bool isShowIndicator;
  final double aspectRatio;
  final double viewportFraction;
  final double margin;
  final BorderRadius radius;
  final bool isPopImage;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _current = 0;
  final CarouselSliderController controllerWidget = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel
        CarouselSlider.builder(
          carouselController: controllerWidget,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return carouselCard(
              widget.margin,
              widget.radius,
              widget.cmsBannerModel[index]
            );
          },
          itemCount: widget.cmsBannerModel.length,
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 6),
            aspectRatio: widget.aspectRatio,
            viewportFraction: widget.viewportFraction,
            enableInfiniteScroll: widget.cmsBannerModel.length > 1,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }
          ),
        ),
        // Indicator
        // if(widget.isShowIndicator && widget.cmsBannerModel.length > 1) ...[
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: widget.cmsBannerModel.asMap().entries.map((entry) {
        //       return GestureDetector(
        //         onTap: () => controllerWidget.animateToPage(entry.key),
        //         child: Container(
        //           width: 6.4,
        //           height: 6.4,
        //           margin: const EdgeInsets.symmetric(
        //             vertical: 8.0,
        //             horizontal: 4.0,
        //           ),
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: kDarkColor.withValues(alpha: _current == entry.key ? 0.9 : 0.4),
        //           ),
        //         ),
        //       );
        //     }).toList(),
        //   ),
        // ]
        if(widget.isShowIndicator && widget.cmsBannerModel.length > 1) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.cmsBannerModel.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => controllerWidget.animateToPage(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 450),
                  width: _current == entry.key? 29: 15,
                  height: 6,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _current == entry.key? kAppColor: const Color(0xFFF5CDCB),
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

  Widget carouselCard(
    double margin, 
    BorderRadius radius, 
    CmsBannerModel cmsBannerModel
  ) {
    return GestureDetector(
      onTap: () {
        if(cmsBannerModel.isExternal == 1 && cmsBannerModel.externalUrl?.isNotEmpty == true) {
          Get.to(
            () => WebViewScreen(
              url: cmsBannerModel.externalUrl,
            ),
          );
        }else if(cmsBannerModel.content?.url.isNotEmpty == true) {
          Get.to(
            () => CmsContentScreen(
              url: cmsBannerModel.content!.url,
              showCart: true,
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(margin),
        child: ClipRRect(
          borderRadius: radius,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ImageUrl(
              imageUrl: cmsBannerModel.image!.path,
            ),
          ),
        ),
      ),
    );
  }
}
