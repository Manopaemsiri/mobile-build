import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageImages extends StatefulWidget {
  const MessageImages({
    Key? key,
    required this.model
  }) : super(key: key);
  final Map<String, dynamic> model;

  @override
  State<MessageImages> createState() => _MessageImagesState();
}

class _MessageImagesState extends State<MessageImages> {
  final LanguageController lController = Get.find<LanguageController>();
  late final List<dynamic> images = widget.model["images"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang("Images")),
      ),
      body: images.isNotEmpty
      ? ListView.separated(
        padding: kPadding,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final path = images[index];

          return FutureBuilder<ui.Image>(
            future: _getImageInfo(path),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                final image = snapshot.data!;
                final aspectRatio = image.width / image.height;
                
                return GestureDetector(
                  onTap: () => Get.to(() => MessageImages(model: widget.model), transition: Transition.noTransition),
                  child: Container(
                    width: Get.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(kRadius))
                    ),
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Hero(
                        tag: path,
                        child: ImageUrl(
                          imageUrl: path,
                          borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const SizedBox.shrink();
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }, 
        separatorBuilder: (BuildContext context, int index) {
          return const Gap(gap: kHalfGap);
        },
      )
      : const SizedBox.shrink()
    );
  }

  Future<ui.Image> _getImageInfo(String url) async {
    final response = await http.get(Uri.parse(url));
    final byteData = response.bodyBytes;
    final ui.Image image = await decodeImageFromList(byteData);
    return image;
  }

  // Future<void> fullScreen(String img) async {
  //   Get.to(
  //     () => ImageView(imageUrl: img,),
  //     transition: Transition.noTransition,
  //     fullscreenDialog: true
  //   );
  // }
}