import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/cms/content/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/card_cms_content_controller.dart';

class CardCmsContents extends StatelessWidget {
  const CardCmsContents({
    super.key,
    required this.lController,
    this.appBarTitle = 'Related Contents',
    this.contents = const [],
  });
  final LanguageController lController;
  final String appBarTitle;
  final List<CmsContentModel> contents;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardCmsContentController>(
      init: CardCmsContentController(contents),
      
      builder: (controller) {
        return controller.data.isNotEmpty 
        ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kGap),
              child: Text(
                lController.getLang(appBarTitle),
                style: title.copyWith(
                  fontWeight: FontWeight.w600,
                  // color: kAppColor2,
                  color: kWhiteColor,
                ),
              ),
            ),
            const Gap(gap: kHalfGap),
            LayoutBuilder(
              builder: (_, constraints) {
                double cardHeight = (kHalfGap*2) + kQuarterGap + ((bodyText2.fontSize!*3)*1.4);
                double cardWidth = constraints.maxWidth;
                double aspectratio = cardWidth/cardHeight;

                return CarouselSlider.builder(
                  carouselController: controller.pageController,
                  itemBuilder: (BuildContext context, int index, int realIndex) =>
                    widgetBody(controller.data[index], (id) => Get.to(() => CmsContentScreen(url: id, backTo: '/CheckOutScreen'))),
                  itemCount: controller.data.length,
                  options: CarouselOptions(
                    autoPlay: false,
                    aspectRatio: aspectratio,
                    viewportFraction: 1,
                    enableInfiniteScroll: controller.data.length > 1,
                    onPageChanged: (index, reason) => controller.onPageChanged(index),
                  ),
                );
              }
            ),
            if(controller.data.length > 1) ...[
              const Gap(gap: kHalfGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.data.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => controller.pageController.animateToPage(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 450),
                      width: controller.currentIndex == entry.key? 24: 10,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: kQuarterGap/2),
                      decoration: BoxDecoration(
                        // color: controller.currentIndex == entry.key? kAppColor: const Color(0xFFF5CDCB),
                        color: controller.currentIndex == entry.key? kWhiteColor: kWhiteColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(kCardRadius)
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        )
        : const SizedBox.shrink();
      }
    );
  }

  Widget widgetBody(CmsContentModel item, Function(String)? onTap) {
    final url = item.url;
    final imageUrl = item.image?.path ?? '';
    final title = item.title;
    final desc = item.description;
  
    return GestureDetector(
      onTap: onTap != null? () => onTap(url): null,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: kGap),
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(kRadius)
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 66/44,
                child: ImageUrl(
                  imageUrl: imageUrl,
                  borderRadius:  BorderRadius.zero,
                ),
              ),
              const Gap(gap: kHalfGap),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: kHalfGap, horizontal: kHalfGap),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyText2.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      const Gap(gap: kQuarterGap),
                      Expanded(
                        child: Text(
                          '$desc\n\n',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: bodyText2.copyWith(
                            color: kDarkColor,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}