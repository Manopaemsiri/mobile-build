import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';


class CardGeneral extends StatelessWidget {
  const CardGeneral({
    Key? key,
    this.width = 150,
    required this.titleText,
    this.onPressed,
    this.image = '',
    this.maxLines = 1,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  final double width;
  final String titleText;
  final String image;
  final VoidCallback? onPressed;
  final int maxLines;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
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
                    imageUrl: image,
                    fit: boxFit,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: kHalfPadding,
                child: SizedBox(
                  height: 22 * double.parse(maxLines.toString()),
                  child: Text(
                    titleText,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: bodyText2.copyWith(
                      color: kDarkColor,
                      fontWeight: FontWeight.w500,
                      height: 1.4
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
