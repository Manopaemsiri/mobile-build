import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({
    super.key,
    required this.onTap,
    required this.imageWidth,
    required this.lController,
    this.images = const [],
    this.maxImage = 3,
  });

  final Function() onTap;
  final double imageWidth;
  final List<dynamic> images;
  final int maxImage;
  final LanguageController lController;
  
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DottedBorder(
        color: kLightColor,
        radius: const Radius.circular(kRadius),
        borderType: BorderType.RRect,
        strokeWidth: 1,
        padding: EdgeInsets.zero,
        child: SizedBox(
          width: imageWidth,
          height: imageWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt_rounded,
                color: kLightColor,
              ),
              if(images.isNotEmpty)...[
                Text(
                  '${maxImage-images.length}/$maxImage',
                  style: bodyText2.copyWith(
                    color: kLightColor,
                    fontWeight: FontWeight.w400
                  ),
                )
              ]else...[
                Text(
                  lController.getLang('Image'),
                  style: bodyText2.copyWith(
                    color: kLightColor,
                    fontWeight: FontWeight.w400
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}