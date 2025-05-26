import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';


class AppBarMessage extends StatelessWidget implements PreferredSizeWidget {
  const AppBarMessage({
    Key? key,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
    required this.model,
  }) : super(key: key);

  @override
  final Size preferredSize;

  final CustomerChatroomModel model;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          const Gap(gap: kQuarterGap),
          const BackButton(),
          SizedBox(
            width: 32,
            height: 32,
            child: ImageProfileCircle(
              imageUrl: model.partnerShop["icon"] ?? '',
            ),
          ),
          const Gap(gap: kGap),
          Text(
            model.partnerShop["name"] ?? '',
            style: headline6.copyWith(
              fontWeight: FontWeight.w600
            )
          ),
        ],
      ),
    );
  }
}