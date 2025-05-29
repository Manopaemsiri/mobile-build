import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee2u/config/themes/colors.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageProduct extends StatelessWidget {
  const ImageProduct({
    super.key,
    required this.imageUrl,
    this.selected = false,
    this.width = 56,
    this.height = 56,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.padding2,
    this.decoration,
    this.imgRadius,
  });

  final String imageUrl;
  final bool selected;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final EdgeInsets? padding;
  final EdgeInsets? padding2;
  final BoxDecoration? decoration;
  final BorderRadius? imgRadius;

  @override
  Widget build(BuildContext context) {
    Color _color = Theme.of(context).primaryColor;
    bool fromNetwork = imageUrl.contains('http://') || imageUrl.contains('https://');

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: decoration ?? BoxDecoration(
        color: selected? _color.withValues(alpha: 0.125): kGrayLightColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: padding2 ?? const EdgeInsets.all(1),
        child: ClipRRect(
          borderRadius: imgRadius ?? BorderRadius.circular(4),
          child: fromNetwork
          ? CachedNetworkImage(
            fit: fit,
            alignment: alignment,
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
              borderRadius: imgRadius ?? BorderRadius.circular(4),
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              ),
            ),
            placeholder: (context, url) => placeholder(),
            errorWidget: (context, url, error) => Image.asset(defaultPath),
          )
          : Image.asset(
            defaultPath,
            fit: fit,
            alignment: alignment,
          ),
        ),
      ),
    );
  }

  Widget placeholder() {
    return const Center(
      child: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget errorWidget() {
    return const Center(
      child: FaIcon(
        FontAwesomeIcons.gift,
        color: kGrayColor,
      ),
    );
  }
}
