import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/models/file_model.dart';
import 'package:coffee2u/models/seller_shop_rating_model.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  final SellerShopRatingModel model;

  @override
  Widget build(BuildContext context) {
    String _avatar = model.customer?.avatar?.path ?? defaultAvatar;
    String _name = model.customer == null
      ? 'Anonymous Customer': model.customer!.displayName();
    String _rank = model.customer == null
      ? 'Welcome Tier'
      : model.customer?.tier?.name ?? 'Welcome Tier';

    return Column(
      children: [
        ListTile(
          leading: ImageProfileCircle(
            imageUrl: _avatar,
            size: 48,
          ),
          title: Text(
            _name,
            style: subtitle1.copyWith(
              color: kAppColor,
              fontFamily: "CenturyGothic",
              fontWeight: FontWeight.w600
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  FontAwesomeIcons.crown,
                  size: 14,
                  color: kYellowColor,
                ),
                const Gap(gap: kHalfGap),
                Text(
                  _rank,
                  style: subtitle2.copyWith(
                    color: kDarkLightColor,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, kGap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RatingBarIndicator(
                    rating: double.parse(model.rating.toString()),
                    itemBuilder: (context, index) {
                      return SvgPicture.asset(
                        "assets/icons/star_box_icon.svg",
                        color: kAppColor,
                      );
                    },
                    unratedColor: kLightColor,
                    itemCount: 5,
                    itemSize: 20,
                  ),
                  const Gap(gap: kHalfGap),
                  Text(
                    dateFormat(model.createdAt ?? DateTime.now()),
                    style: bodyText1.copyWith(
                      color: kGrayColor
                    ),
                  ),
                ],
              ),
              if(model.comment != '') ...[
                const Gap(gap: kHalfGap),
                Text(
                  model.comment,
                  style: bodyText1,
                ),
              ],
              if(model.images.isNotEmpty) ...[
                const Gap(gap: kHalfGap),
                Wrap(
                  spacing: kHalfGap,
                  children: model.images.map((FileModel item) {
                    if(item.path.isNotEmpty){
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kRadius),
                          color: kGrayLightColor,
                        ),
                        child: ImageUrl(
                          imageUrl: item.path,
                          radius: kRadius
                        ),
                      );
                    }else{
                      return const SizedBox.shrink();
                    }
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 0.7, thickness: 0.7),
      ],
    );
  }
}