import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    required this.model,
    required this.onPressed,
    required this.lController,
  }): super(key: key);

  final CustomerChatroomModel model;
  final VoidCallback onPressed;
  final LanguageController lController;

  @override
  Widget build(BuildContext context) {
    final lastMessage = model.recentMessage["createdAt"] != null 
    ? model.recentMessage["text"]!=''
      ? model.recentMessage["text"]
      : model.recentMessage["images"].isNotEmpty
        ? model.recentMessage["fromCustomer"]==true
          ? lController.getLang("You sent a photo")
          : lController.getLang("sent a photo")
        : ''
    : '';

    return Container(
      color: kWhiteColor,
      padding: const EdgeInsets.symmetric(vertical: kHalfGap),
      child: ListTile(
        leading: ImageProfileCircle(
          imageUrl: model.partnerShop["icon"],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                model.partnerShop["name"] ?? "",
                style: subtitle1.copyWith(
                  fontWeight: FontWeight.w500
                )
              ),
            ),
            const Gap(gap: kQuarterGap),
            BadgeOnline(
              isOnline: !model.isReadCustomer,
              size: 10
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(gap: 2),
            Text(
              lastMessage,
              style: subtitle2.copyWith(
                fontWeight: FontWeight.w300
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(gap: 3),
            Text(
              model.recentMessage["createdAt"] == null
              ? '': dateFormat(
                DateTime.parse(model.recentMessage["createdAt"]),
                format: 'd MMMM y ${lController.getLang("Time")} kk:mm'
              ),
              style: caption.copyWith(
                fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}