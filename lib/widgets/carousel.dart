import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';


class Carousel extends StatefulWidget {
  const Carousel({
    super.key,
    required this.images,
    this.isShowIndicator = true,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 0.9,
    this.margin = 5.0,
    this.radius = const BorderRadius.all(Radius.circular(5.0)),
    this.isPopImage = false,
    this.pageSnapping = true,
    this.disableCenter = false,
    this.padEnds = true,
  });

  final List<FileModel>? images;
  final bool isShowIndicator;
  final double aspectRatio;
  final double viewportFraction;
  final double margin;
  final BorderRadius radius;
  final bool isPopImage;
  final bool pageSnapping;
  final bool disableCenter;
  final bool padEnds;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _current = 0;
  final CarouselSliderController controllerWidget = CarouselSliderController();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.images != null && widget.images!.isNotEmpty) ...[
          ClipRRect(
            borderRadius: widget.radius,
            child: CarouselSlider(
              items: _buildItem(widget.images, widget.margin),
              carouselController: controllerWidget,
              options: CarouselOptions(
                aspectRatio: widget.aspectRatio,
                viewportFraction: widget.viewportFraction,
                onPageChanged: (index, reason) {
                  setState(() => _current = index);
                },
                enableInfiniteScroll: widget.images!.length > 1,
                pageSnapping: widget.pageSnapping,
                disableCenter: widget.disableCenter,
                padEnds: widget.padEnds
              ),
            ),
          ),
        ] else ...[
          AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: ClipRRect(
              borderRadius: widget.radius,
              child: Image.asset(
                defaultPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],

        if(widget.isShowIndicator && widget.images != null && widget.images!.length > 1) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images!.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => controllerWidget.animateToPage(entry.key),
                child: Container(
                  width: 6.4,
                  height: 6.4,
                  margin: const EdgeInsets.only(
                    top: 18,
                    bottom: kHalfGap,
                    left: kQuarterGap,
                    right: kQuarterGap,
                  ),
               
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kDarkColor.withValues(alpha: _current == entry.key ? 0.9 : 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
        ]
      ],
    );
  }

  List<Widget> _buildItem(List<FileModel>? images, double margin){
    return images!.map((image) {
      return GestureDetector(
        onTap: !widget.isPopImage
          ? null
          : (){
            Get.to(
              () => Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarBrightness: Brightness.dark,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: kWhiteColor,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: kWhiteColor,
                        size: 32,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                body: Center(
                  child: Container(
                    decoration: const BoxDecoration(color: kDarkColor),
                    child: PhotoView(
                      imageProvider: NetworkImage(
                        image.path,
                      ),
                    ),
                  ),
                ),
              ),
              transition: Transition.downToUp,
              fullscreenDialog: true,
            );
          },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: margin),
          child: ClipRRect(
            borderRadius: widget.radius,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ImageUrl(imageUrl: image.path),
            ),
          ),
        ),
      );
    }).toList();
  }
}
