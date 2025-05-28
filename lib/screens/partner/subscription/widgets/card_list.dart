import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import '../../../../models/index.dart';

class SubscriptionCardList extends StatefulWidget {
  const SubscriptionCardList({
    super.key,
    required this.onTap,
    required this.data,
    required this.lController,
    this.cardWidth,
  });

  final PartnerProductSubscriptionModel data;
  final Function(String) onTap;
  final LanguageController lController;
  final double? cardWidth;

  @override
  State<SubscriptionCardList> createState() => _SubscriptionCardListState();
}

class _SubscriptionCardListState extends State<SubscriptionCardList> {

  static final Map<String, Color> _paletteCache = {};

  Color _textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadColor();
  }

  Future<void> _loadColor() async {
    final String path = widget.data.image?.path ?? '';
    if (path.isEmpty || _paletteCache.containsKey(path)) {
      setState(() {
        _textColor = _paletteCache[path] ?? Colors.black;
      });
      return;
    }

    try {
      final palette = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(path),
      );

      final dominant = palette.dominantColor?.color ?? Colors.black;
      final opposite = Color.fromARGB(
        dominant.alpha,
        255 - dominant.red,
        255 - dominant.green,
        255 - dominant.blue,
      );

      _paletteCache[path] = opposite;
      if (mounted) {
        setState(() {
          _textColor = opposite;
        });
      }
    } catch (_) {
      _paletteCache[path] = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    if (!data.isValid()) return const SizedBox.shrink();

    final imagePath = data.image?.path ?? '';
    final isDiscounted = data.isDiscounted();
    final priceInVAT = priceFormat(data.priceInVAT, widget.lController, trimDigits: true);
    final discountPriceInVAT = priceFormat(data.discountPriceInVAT, widget.lController, trimDigits: true);
    final discountPrice = priceFormat(data.priceInVAT, widget.lController, trimDigits: true);

    final contract = widget.lController.getLang('text_subscription_contract')
        .replaceFirst('_VALUE_', '${data.recurringCount}')
        .replaceFirst('_VALUE2_', data.displayRecurringTypeName(widget.lController));

    return InkWell(
      onTap: () => widget.onTap(data.id),
      child: RepaintBoundary(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 3.5),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(kRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ImageUrl(imageUrl: imagePath),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kGap * 1.5, vertical: kGap * 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          data.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: headline6.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: kHalfGap),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: isDiscounted ? discountPriceInVAT : priceInVAT,
                                          style: headline5.copyWith(
                                            color: const Color(0xFFC90E29),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Kanit',
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' / ${data.displayRecurringTypeName(widget.lController)}',
                                          style: subtitle1.copyWith(
                                            color: _textColor,
                                            fontFamily: 'Kanit',
                                          ),
                                        ),
                                        if (isDiscounted) ...[
                                          const WidgetSpan(child: SizedBox(width: kHalfGap)),
                                          TextSpan(
                                            text: discountPrice,
                                            style: subtitle2.copyWith(
                                              color: _textColor.withValues(alpha: 0.4),
                                              decoration: TextDecoration.lineThrough,
                                              fontFamily: 'Kanit',
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Text(
                                    contract,
                                    style: subtitle2.copyWith(
                                      color: _textColor,
                                      fontFamily: 'Kanit',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: kQuarterGap, horizontal: kHalfGap),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC90E29),
                                borderRadius: BorderRadius.circular(kRadius),
                              ),
                              child: Text(
                                widget.lController.getLang('choose package'),
                                style: subtitle2.copyWith(
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (widget.cardWidth != null)
              SizedBox(
                width: widget.cardWidth,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ImageUrl(imageUrl: imagePath),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
