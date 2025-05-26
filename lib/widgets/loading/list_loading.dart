import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class ListLoading extends StatelessWidget {
  const ListLoading({
    Key? key,
    this.itemCount = 7
  }) : super(key: key);
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        const double size = 38;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: kGap, horizontal: kGap
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const ShimmerWidget(height: size, width: size),
                  const Gap(gap: kGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(height: title.fontSize!*1.4),
                        const SizedBox(height: 3),
                        ShimmerWidget(height: subtitle2.fontSize!*1.4),
                      ],
                    )
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }
}