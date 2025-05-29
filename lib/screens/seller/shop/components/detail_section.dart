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
    String _image = "${model.image!.path}";
    String _name = model.name;
    String _status = "${model.status}";
    String _distance = "${model.distance} km.";
    String _star = "4.5";
    String _review = "128 ${lController.getLang("Review(s)")}";
    String _caption = model.description;
    String _closingTime = model.todayOpenRange();
    bool _isFavorite = false;

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
              imageUrl: _image,
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
                  _name,
                  style: headline5.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
              favButton(_isFavorite),
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
                    title: _star,
                    iconRight: Icons.star,
                    size: 12,
                  ),
                  const Gap(gap: kHalfGap),
                  Text(
                    _review,
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
                    _distance,
                    style: caption.copyWith(color: kGrayColor),
                  ),
                ],
              ),
              const Gap(gap: kQuarterGap),
              Text(
                _caption,
                style: bodyText2.copyWith(color: kGrayColor),
              ),
              const Gap(),
              Row(
                children: [
                  Text(
                    _status,
                    style: bodyText2.copyWith(color: kGreenColor),
                  ),
                  const Gap(gap: kHalfGap),
                  Text(
                    _closingTime,
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
