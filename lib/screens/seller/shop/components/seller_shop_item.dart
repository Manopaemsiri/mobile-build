import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class SellerShopItem extends StatelessWidget {
  const SellerShopItem({
    Key? key,
    required this.model,
    required this.onTap,
  }) : super(key: key);

  final SellerShopModel model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String _image = model.logo != null? model.logo!.path
      : model.image != null? model.image!.path: '';
    String? _distance = model.distance == null ? "" : "${model.distance} km.";
    
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: kPadding,
            color: kWhiteColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageProduct(
                  imageUrl: _image,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: kGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(gap: 2),
                      Text(
                        model.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: subtitle1.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.35
                        ),
                      ),
                      const Gap(gap: kQuarterGap),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RatingBarIndicator(
                            rating: model.averageRating ?? 0,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            unratedColor: kLightColor,
                            itemCount: 5,
                            itemSize: 16,
                          ),
                          const Gap(gap: kOtGap),
                          if(model.distance != null) ...[
                            const Icon(
                              Icons.near_me_outlined,
                              color: kGrayColor,
                              size: 14,
                            ),
                            const Gap(gap: kQuarterGap),
                            Text(
                              _distance,
                              style: caption.copyWith(
                                color: kGrayColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Gap(gap: kHalfGap),
                      Row(
                        children: [
                          model.displayIsOpen(bodyText2),
                          const Gap(gap: kOtGap),
                          model.isOpen()
                            ? Text(
                              model.todayOpenRange(),
                              style: bodyText2.copyWith(
                                color: kGrayColor,
                                fontWeight: FontWeight.w400
                              ),
                            )
                            : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.7, thickness: 0.7),
        ],
      ),
    );
  }
}