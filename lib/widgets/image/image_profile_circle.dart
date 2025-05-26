import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee2u/config/themes/colors.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:flutter/material.dart';

class ImageProfileCircle extends StatelessWidget {
  const ImageProfileCircle({
    Key? key,
    required this.imageUrl,
    this.size = 56,
    this.fit = BoxFit.cover,
    this.isFile = false,
    this.defaultImage = defaultAvatar,
    this.defaultBGColor = kLightColor,
  }) : super(key: key);
  final String imageUrl;
  final double size;
  final BoxFit fit;
  final bool isFile;
  final String defaultImage;
  final Color defaultBGColor;

  @override
  Widget build(BuildContext context) {
    bool fromNetwork = imageUrl.contains('http://') || imageUrl.contains('https://');

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox(
        height: size,
        width: size,
        child: !isFile
          ? CircleAvatar(
            backgroundColor: defaultBGColor,
            backgroundImage: fromNetwork? null: AssetImage(defaultImage),
            child: fromNetwork
              ? CachedNetworkImage(
                imageUrl: imageUrl,
                height: size,
                width: size,
                fit: fit,
                placeholder: (context, url) => placeholder(),
                errorWidget: (context, url, error) => errorWidget(),
              )
              : const SizedBox.shrink(),
          )
          : CircleAvatar(
            backgroundColor: defaultBGColor,
            backgroundImage: Image.file(File(imageUrl)).image,
          ),
      ),
    );
  }

  Widget placeholder() {
    return CircleAvatar(
      backgroundColor: defaultBGColor,
      child: const Center(
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
    return const Icon(Icons.person);
  }
}
