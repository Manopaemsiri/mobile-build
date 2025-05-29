import 'dart:math';

import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/product_review/controller/rate_product_controller.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/index.dart';
import '../../../controller/language_controller.dart';
import 'widgets/product_item.dart';

class ProductReviewScreen extends StatelessWidget {
  ProductReviewScreen({
    super.key,
    required this.customerOrder,
  });

  final CustomerOrderModel customerOrder;
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RateProductController>(
      init: RateProductController(customerOrder),
      builder: (controller) {
        Widget body = Center(child: Loading());
        if(controller.stateStatus == 1){
          body = _body(controller);
        }else if(controller.stateStatus == 2){
          body = NoData();
        }else if(controller.stateStatus == 3){
          body = PageError();
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: kWhiteColor,
            appBar: AppBar(
              title: Text(
                lController.getLang("Rate the Product")
              ),
            ),
            body: body,
            bottomNavigationBar: controller.stateStatus == 1 
            && (customerOrder.canRateProduct() || customerOrder.canUpdateRateProduct())
            ? Padding(
              padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, 30),
              child: ButtonSmall(
                title: lController.getLang("Confirm"),
                titleStyle: subtitle1.copyWith(
                  fontWeight: FontWeight.w500
                ),
                width: double.infinity,
                onPressed: () => _onTap(controller),
              ),
            ): const SizedBox.shrink(),
          ),
        );
      }
    );
  }

  Widget _body(RateProductController controller) {
    double imageWidth = min(Get.width/5, 78.54);

    return SingleChildScrollView(
      child: Padding(
        padding: kPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(controller.products.isNotEmpty)...[
              Text(
                lController.getLang('text_rating_2'),
                style: caption.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const Gap(gap: kHalfGap + 5),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  final PartnerProductModel product = controller.products[index];
                  bool checkboxValue = controller.selectedProducts.any((d) => d.id == product.id);

                  return ProductItem(
                    product: product,
                    onChanged: (d) => controller.onChangedProduct(d, product), 
                    value: checkboxValue,
                    imageWidth: imageWidth,
                  );
                },
                separatorBuilder: (_, index) => const Divider(indent: 0, endIndent: 0, height: kGap, thickness: 1),
                itemCount: controller.products.length,
              ),
              const Divider(indent: 0, endIndent: 0, height: kGap, thickness: 1),
            ],
            const Gap(gap: kHalfGap + 4),
            Text(
              lController.getLang('text_rating_3'),
              style: bodyText2.copyWith(
                color: kDarkColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 26*1.6,
                  child: Text(
                    '${controller.selectedRating?['value'] ?? '0.0'}',
                    style: headline5.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                    ),
                  ),
                ),
                const Gap(gap: kHalfGap),
                StarRating(
                  data: controller.ratingDescription,
                  onChanged: (d) => controller.onChangedRating(d),
                  selectedRating: controller.selectedRating,
                ),
                const Gap(gap: kHalfGap),
                Text(
                  lController.getLang('${controller.selectedRating?['name'] ?? ''}'),
                  style: bodyText2.copyWith(
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: kGap),
              child: Wrap(
                spacing: kHalfGap,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: <dynamic>[ ...controller.images, controller.images.length < controller.maxImage? { 'type': '' }: null ].asMap().map((i, d) {
                  Widget widget = const SizedBox.shrink();
                  
                  if(d != null){
                    final String imageType = d?['type'] ?? '';
                    if(imageType.isNotEmpty == true){
                    String imagePath = '';
                      if(imageType == 'FileModel'){
                        imagePath = (d['value'] as FileModel).path;
                      }else if(imageType == 'XFile'){
                        imagePath = (d['value'] as XFile).path;
                      }
                      widget = ImageRating(
                        imagePath: imagePath,
                        onDeleteImage: () => controller.onDeleteImage(i),
                        imageWidth: imageWidth,
                        imageFile:imageType == 'XFile',
                      );
                    }else {
                      widget = AddImageButton(
                        onTap: () => _onTapAddImage(controller),
                        imageWidth: imageWidth,
                        images: controller.images,
                        maxImage: controller.maxImage,
                        lController: lController,
                      );
                    }
                  }
                  return MapEntry(i, widget);
                }).values.toList(),
              )
            ),
            TextFieldRating(
              controller: controller.comment,
              focusNode: controller.commentFocus,
            ),
          ],
        ),
      ),
    );
  }
  _onTap(RateProductController controller) async {
    final res = await controller.onSubmit();
    if(res){
      ShowDialog.showSuccessToast(
        title: lController.getLang("Rated successed"),
        desc: lController.getLang('text_rate_1'),
      );
      await Future.delayed(const Duration(milliseconds: 450));
      Get.until((route) => Get.currentRoute == "/CustomerOrderScreen");
    }
  }

  void _onTapAddImage(RateProductController controller) async {
    showModalBottomSheet(
      context: context, 
      builder: (context){

        return Padding(
          padding: EdgeInsets.only(bottom: max(MediaQuery.of(context).padding.bottom, kGap)),
          child: Wrap(
            children: [
              ListTileItem(
                txtTitle: 'Choose from library',
                leadingIcon: Icons.image_outlined,
                onTap: () => controller.imagePicker(source: ImageSource.gallery),
                lController: lController,
              ),
              const Divider(),
              ListTileItem(
                txtTitle: 'Take photo',
                leadingIcon: Icons.photo_camera_outlined,
                onTap: () => controller.imagePicker(source: ImageSource.camera),
                lController: lController,
              ),
            ],
          ),
        );
      },
    );
  }
}