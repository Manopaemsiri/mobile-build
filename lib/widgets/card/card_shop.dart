import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CardShop extends StatelessWidget {
  const CardShop({
    Key? key,
    this.width = 150,
    required this.model,
    this.onPressed,
    this.showDistance = true,
  }): super(key: key);

  final double width;
  final PartnerShopModel model;
  final VoidCallback? onPressed;
  final bool showDistance;

  @override
  Widget build(BuildContext context) {
    final CustomerController _customerController = Get.find<CustomerController>();

    String _image = model.image?.path ?? "";
    String _name = model.name ?? "";
    String? _distance = model.distance == null ? "" : "${model.distance} km.";

    return SizedBox(
      width: width,
      child: Card(
        elevation: 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(kRadius),
                    topRight: Radius.circular(kRadius),
                  ),
                  child: ImageUrl(
                    imageUrl: _image,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: kHalfPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 48,
                      child: Text(
                        _name,
                        maxLines: 2,
                        style: bodyText2.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w500,
                          height: 1.4
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // model.displayIsOpen(bodyText2),
                        if (showDistance && _customerController.shippingAddress != null) ...[
                          Row(
                            children: [
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
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
