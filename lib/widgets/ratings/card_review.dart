import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/index.dart';

class CardReview extends StatelessWidget {
  const CardReview({
    Key? key,
    required this.data,
    this.maxLines,
    this.padding = const EdgeInsets.symmetric(vertical: kGap),
    required this.lController,
  }) : super(key: key);

  final PartnerProductRatingModel data;
  final int? maxLines;
  final EdgeInsetsGeometry? padding;
  final LanguageController lController;

  @override
  Widget build(BuildContext context) {
    if(!data.isValid()) return const SizedBox.shrink();

    String avatar = data.customer?.avatar?.path ?? '';
    String username = data.customer?.displayName() ?? '';
    if(data.isAnonymous == 1 || username.isEmpty){
      if(username.isEmpty) username = 'Anonymous Customer';
      username = reString(username);
      avatar = '';
    }

    String createdAt = dateFormat(data.createdAt, format: 'd MMM y');
    
    final double score = data.rating ?? 0;
    final String comment = data.comment ?? '';
    final List<FileModel> images = data.images ?? [];

    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(kRadius)
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageProfileCircle(
                imageUrl: avatar,
                size: 35
              ),
              const Gap(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: subtitle1.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [1,2,3,4,5].map((e) {
                        return Icon(
                          Icons.star_rounded,
                          color: score >= e
                          ? kYellowColor
                          : kLightColor,
                          size: 18,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if(comment.isNotEmpty)...[
            Text(
              comment,
              softWrap: true,
              maxLines: maxLines,
              overflow: maxLines != null? TextOverflow.ellipsis: null,
              style: subtitle1.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],

          if(images.isNotEmpty)...[
            const Gap(gap: kHalfGap),
            Wrap(
              spacing: kHalfGap,
              children: images.asMap().map((i, d) {
                Widget value = Stack(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(images, i),
                      child: SizedBox(
                        width: (Get.width - (kGap*2) - kHalfGap) /2,
                        height: (Get.width - (kGap*2) - kHalfGap) /2,
                        child: ImageUrl(
                          imageUrl: d.path,
                          radius: 0.0,
                          borderRadius: BorderRadius.circular(kRadius),
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                    if(i == 1 && images.length > 2)...[
                      Positioned(
                        bottom: kHalfGap,
                        right: kHalfGap,
                        child: IgnorePointer(
                          ignoring: true,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: kHalfGap, vertical: kQuarterGap),
                            decoration: BoxDecoration(
                              color: kDarkLightColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(kHalfGap - kRadius)
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.photo_library_outlined,
                                  size: 14,
                                  color: kWhiteColor
                                ),
                                const Gap(gap: kQuarterGap/2),
                                Text(
                                  '+${images.length-2}',
                                  style: subtitle2.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: kWhiteColor
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      )
                    ]
                  ],
                );
                if(i > 1) value = const SizedBox.shrink();

                return MapEntry(i, value);
              }).values.toList(),
            )
          ],
          const Gap(gap: kHalfGap),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              createdAt
            ),
          ),
        ],
      )
    );
  }

  onTap(List<FileModel> values, int index) 
    => Get.to(() => CarouselFullScreen(images: values, initIndex: index));
}