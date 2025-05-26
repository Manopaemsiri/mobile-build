import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/frontend_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/cms/content/list.dart';
import 'package:coffee2u/screens/cms/content/read.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double _flex = 2.5;
final double _screenwidth = DeviceUtils.getDeviceWidth();
final double _cardWidth = _screenwidth / _flex;

class ListCmsContents extends StatelessWidget {
  const ListCmsContents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<FrontendController>(builder: (controller) {
      return FutureBuilder<Map<String, dynamic>?>(
        future: controller.contentCategories,
        builder: (context, snapshot) {
          List<Widget> _widgets = [];

          if (snapshot.hasData) {
            var len = snapshot.data!['result'].length;
            for (var i = 0; i < len; i++) {
              CmsCategoryModel model = CmsCategoryModel.fromJson(
                  snapshot.data!['result'][i]);
              _widgets.add(_addWidget(model, controller));
            }

            if (_widgets.isEmpty) {
              return const SizedBox.shrink();
            } else {
              return Column(children: _widgets);
            }
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    });
 } 
    
  _addWidget(CmsCategoryModel? model, FrontendController controller) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: controller.futureCmsContents(model?.url ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<CmsContentModel> items = [];
            var len = snapshot.data!['result'].length;
            for (var i = 0; i < len; i++) {
              CmsContentModel model =
                  CmsContentModel.fromJson(snapshot.data!['result'][i]);
              items.add(model);
            }

            if (items.isEmpty) {
              return const SizedBox.shrink();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kGap + kQuarterGap),
                  SectionTitle(
                    titleText: model?.title,
                    isReadMore: true,
                    onTap: () => Get.to(() => CmsContentsScreen(category: model)),
                    padding: const EdgeInsets.fromLTRB(kGap, 0, kGap, 0),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: kGap, vertical: kGap),
                    child: Wrap(
                      spacing: kHalfGap,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: items.map((item) {

                        return CardCmsContent(
                          width: _cardWidth,
                          model: item,
                          onPressed: () => Get.to(() => CmsContentScreen(url: item.url))
                        );
                      }).toList(),
                    )
                  ),
                ],
              );
            }
          }else {
            return const SizedBox.shrink();
          }
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return const ShimmerHorizontalProducts(isCmsCard: true);
        }
        return const SizedBox.shrink();
      }
    );
  }
}
