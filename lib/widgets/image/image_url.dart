import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee2u/config/themes/colors.dart';
import 'package:flutter/material.dart';

class ImageUrl extends StatelessWidget {
  const ImageUrl({
    super.key,
    required this.imageUrl,
    this.radius = 0.0,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.color,
    this.showMugIcon = false,
  });

  final String imageUrl;
  final double radius;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final Color? color;
  final bool showMugIcon;

  @override
  Widget build(BuildContext context) {

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => placeholder(),
      errorWidget: (context, url, error) => errorWidget(),
    );
  }

  Widget placeholder() {
    return const Center(
      child: Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget errorWidget() {
    return Container(
      decoration: showMugIcon? null: BoxDecoration(
        color: kWhiteSmokeColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: showMugIcon
      ? Image.asset(
        "assets/icons/coffee_mug.png",
      )
      : const Center(
        child: Icon(
          Icons.hide_image_outlined,
          color: kGrayColor,
        ),
      ),
    );
  }
}