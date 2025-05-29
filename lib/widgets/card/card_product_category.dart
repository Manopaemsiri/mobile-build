import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';

class CardProductCategory extends StatelessWidget {
  const CardProductCategory({
    super.key,
    this.width = 150,
    required this.model,
    required this.onPressed,
  });

  final double width;
  final PartnerProductCategoryModel model;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    String _image = model.image?.path ?? "";
    String _name = model.name;

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
                      height: 24,
                      child: Text(
                        _name,
                        maxLines: 1,
                        style: bodyText2.copyWith(
                            color: kDarkColor,
                            fontWeight: FontWeight.w500,
                            height: 1.4),
                        overflow: TextOverflow.ellipsis,
                      ),
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
