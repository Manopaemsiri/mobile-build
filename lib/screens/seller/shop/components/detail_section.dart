import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';


class DetailSection extends StatelessWidget {
  const DetailSection({
    super.key,
    required this.model,
    required this.lController,
    this.onPressFav,
  });

  final SellerShopModel model;
  final VoidCallback? onPressFav;
  final LanguageController lController;


  @override
  Widget build(BuildContext context) {
    String widgetImage = model.image?.path ?? "";
    String widgetName = model.name;
    String widgetStatus = "${model.status}";
    String widgetDistance = "${model.distance} km.";
    String widgetStar = "4.5";
    String widgetReview = "128 ${lController.getLang("Review(s)")}";
    String widgetCaption = model.description;
    String widgetClosingTime = model.todayOpenRange();
    bool widgetIsFavorite = false;

    return Column(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
            child: ImageUrl(
              imageUrl: widgetImage,
            ),
          ),
        ),
        ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widgetName,
                  style: headline5.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
              favButton(widgetIsFavorite),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(gap: kQuarterGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BadgeDefault(
                    title: widgetStar,
                    iconRight: Icons.star,
                    size: 12,
                  ),
                  const Gap(gap: kHalfGap),
                  Text(
                    widgetReview,
                    style: caption.copyWith(color: kGrayColor),
                  ),
                  const Gap(gap: kHalfGap),
                  Text(
                    "|",
                    style: caption.copyWith(color: kGrayColor),
                  ),
                  const Gap(gap: kHalfGap),
                  const Icon(
                    Icons.near_me_outlined,
                    color: kGrayColor,
                    size: 14,
                  ),
                  const Gap(gap: kQuarterGap),
                  Text(
                    widgetDistance,
                    style: caption.copyWith(color: kGrayColor),
                  ),
                ],
              ),
              const Gap(gap: kQuarterGap),
              Text(
                widgetCaption,
                style: bodyText2.copyWith(color: kGrayColor),
              ),
              const Gap(),
              Row(
                children: [
                  Text(
                    widgetStatus,
                    style: bodyText2.copyWith(color: kGreenColor),
                  ),
                  const Gap(gap: kHalfGap),
                  Text(
                    widgetClosingTime,
                    style: bodyText2.copyWith(
                      color: kGrayColor,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconButton favButton(bool isFav) {
    if (isFav == true) {
      return IconButton(
        onPressed: onPressFav,
        icon: const Icon(Icons.favorite_rounded, color: Colors.red),
      );
    }
    return IconButton(
      onPressed: onPressFav,
      icon: const Icon(Icons.favorite_outline_rounded),
    );
  }
}
