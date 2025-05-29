import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/screens/customer/message/components/message_image.dart';
import 'package:coffee2u/screens/customer/message/components/message_text.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';


class MessageChat extends StatelessWidget {
  const MessageChat({
    Key? key,
    required this.model,
    required this.partnerShop,
    this.showAvatar = true,
    this.showPaddingTop = false
  }) : super(key: key);

  final Map<String, dynamic> model;
  final Map<String, dynamic> partnerShop;
  final bool showAvatar;
  final bool showPaddingTop;

  @override
  Widget build(BuildContext context) {
    bool _isSender = model["fromCustomer"] ?? false;
    String _date = dateFormat(model["createdAt"] ?? DateTime.now(), format: 'dd/MM');
    String _time = dateFormat(model["createdAt"] ?? DateTime.now(), format: 'kk:mm');

    return Padding(
      padding: EdgeInsets.only(
        top: kQuarterGap,
        bottom: showAvatar || showPaddingTop? kGap: 0
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(model["images"].isEmpty)...[
            Row(
              mainAxisAlignment: _isSender
                ? MainAxisAlignment.end: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if(_isSender) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _date,
                        style: caption.copyWith(
                          color: kGrayColor,
                          height: 1.2
                        )
                      ),
                      Text(
                        _time,
                        style: caption.copyWith(
                          color: kGrayColor,
                          height: 1.2
                        )
                      ),
                    ],
                  ),
                  const Gap(gap: kQuarterGap),
                ],
                if(!_isSender) ...[
                  Opacity(
                    opacity: showAvatar? 1: 0,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: ImageProfileCircle(
                        // imageUrl: model["sender"]["icon"] ?? '',
                        imageUrl: partnerShop["icon"] ?? '',
                      ),
                    ),
                  ),
                  const Gap(gap: kHalfGap),
                ],
                MessageText(model: model),

                if(!_isSender) ...[
                  const Gap(gap: kQuarterGap),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _date,
                        style: caption.copyWith(
                          color: kGrayColor,
                          height: 1.2
                        )
                      ),
                      Text(
                        _time,
                        style: caption.copyWith(
                          color: kGrayColor,
                          height: 1.2
                        )
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ]else...[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: _isSender
                ? MainAxisAlignment.end: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if(_isSender) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _date,
                        style: caption.copyWith(
                          color: kGrayColor,
                          height: 1.2
                        )
                      ),
                      Text(
                        _time,
                        style: caption.copyWith(
                          color: kGrayColor,
                          height: 1.2
                        )
                      ),
                    ],
                  ),
                  const Gap(gap: kQuarterGap),
                ],
                if(!_isSender) ...[
                  Opacity(
                    opacity: showAvatar? 1: 0,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: ImageProfileCircle(
                        // imageUrl: model["sender"]["icon"] ?? '',
                        imageUrl: partnerShop["icon"] ?? '',
                      ),
                    ),
                  ),
                  const Gap(gap: kHalfGap),
                ],
                MessageImage(model: model),
                if(!_isSender) ...[
                  const Gap(gap: kQuarterGap),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _date,
                        style: caption.copyWith(
                          color: kGrayColor,
                          height: 1.2
                        )
                      ),
                      Text(
                        _time,
                        style: caption.copyWith(
                          color: kGrayColor,
                          height: 1.2
                        )
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ]
        ],
      ),
    );
  }
}