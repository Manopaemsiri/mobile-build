import 'dart:io';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

class ImageRating extends StatelessWidget {
  const ImageRating({
    super.key,
    required this.imagePath,
    this.onDeleteImage,
    required this.imageWidth,
    this.imageFile = true,
  });
  
  final String imagePath;
  final Function()? onDeleteImage;
  final double imageWidth;
  final bool imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: imageWidth,
      height: imageWidth,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(
          color: kLightColor,
          strokeAlign: BorderSide.strokeAlignCenter
        )
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: imageFile
            ? Image.file(
              File(imagePath),
              fit: BoxFit.fill,
              alignment: Alignment.center,
            )
            : ImageUrl(
              imageUrl: imagePath,
              radius: 0.0,
              borderRadius: BorderRadius.circular(kRadius),
              fit: BoxFit.cover,
            )
          ),
          if(onDeleteImage != null)...[
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onDeleteImage,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: const BoxDecoration(
                    color: kRedColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(kRadius))
                  ),
                  child: Icon(
                    Icons.remove_rounded,
                    color: kWhiteColor,
                    size: imageWidth*0.22,
                  ),
                ),
              )
            )
          ]
        ],
      ),
    );
  }
}