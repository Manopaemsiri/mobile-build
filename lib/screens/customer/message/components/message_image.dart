import 'dart:ui';

import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/screens/customer/message/components/message_images.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageImage extends StatelessWidget {
  const MessageImage({
    super.key,
    required this.model
  });
  final Map<String, dynamic> model;

  @override
  Widget build(BuildContext context) {
    bool _isSender = model["fromCustomer"] ?? false;
    var images = model["images"];
    double imageHeight = images.length > 1? (Get.width*0.8 - kGap*2 - 24)/2: Get.width*0.8 - kGap*2 - 24;
    int row = ((images.length>4? 4: images.length)/2).round();

    return images.length > 1
    ? Container(
      height: imageHeight*row + kQuarterGap,
      width: imageHeight*2 + kQuarterGap,
      padding: const EdgeInsets.all(kQuarterGap),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
        color: kAppColor.withValues(alpha: _isSender? 1: 0.1)
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: imageHeight,
          childAspectRatio: 1/1,
          crossAxisSpacing: kQuarterGap,
          mainAxisSpacing: kQuarterGap
        ),
        itemCount: images.length>4? 4: images.length,
        itemBuilder: (context, index) {
          final imagePath = images[index]; 

          if(images.length > 4 && index == 3){
            return  GestureDetector(
              onTap: () => Get.to(() => MessageImages(model: model), transition: Transition.noTransition),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
                  image: DecorationImage(
                    image: NetworkImage(
                      imagePath,
                    ),
                    fit: BoxFit.cover,
                  )
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '+${images.length-4}',
                        style: headline5.copyWith(
                          color: kWhiteColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return GestureDetector(
            onTap: () => Get.to(() => MessageImages(model: model), transition: Transition.noTransition),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(kRadius)),
              ),
              child: Hero(
                tag: imagePath,
                child: ImageUrl(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
                ),
              ),
            ),
          );
        }
      ),
    ) 
    : Column(
      children: List.generate(
        images.length,
        (index){
          final path = images[index];

          return Padding(
            padding: EdgeInsets.only(top: index>0? kHalfGap: 0),
            child: Container(
              height: imageHeight + kQuarterGap,
              width: imageHeight + kQuarterGap,
              decoration: BoxDecoration(
                color: kAppColor.withValues(alpha: _isSender? 1: 0.1),
                borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
              ),
              padding: const EdgeInsets.all(kQuarterGap),
              child: GestureDetector(
                onTap: () => Get.to(() => MessageImages(model: model), transition: Transition.noTransition),
                child: Container(
                  width: imageHeight,
                  decoration: const BoxDecoration(
                    color: kAppColor,
                    borderRadius: BorderRadius.all(Radius.circular(kRadius)),
                  ),
                  child: Hero(
                    tag: path,
                    child: ImageUrl(
                      imageUrl: path,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.all(Radius.circular(kRadius)),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

}