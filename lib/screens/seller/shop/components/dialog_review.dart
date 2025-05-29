import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DialogReview extends StatefulWidget {
  const DialogReview({
    super.key,
    required this.model,
    required this.shopId,
  });

  final SellerShopRatingModel model;
  final String shopId;

  @override
  State<DialogReview> createState() => _DialogReviewState();
}

class _DialogReviewState extends State<DialogReview> {
  final LanguageController lController = Get.find<LanguageController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cComment = TextEditingController();
  double _rating = 0;
  
  @override
  void initState() {
    setState(() {
      _rating = double.parse(widget.model.rating.toString());
      _cComment.text = widget.model.comment;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lController.getLang("Rate this shop"),
              style: title.copyWith(
                fontWeight: FontWeight.w600
              ),
            ),
            const Gap(gap: kHalfGap),
            RatingBar.builder(
              initialRating: _rating,
              itemCount: 5,
              itemBuilder: (context, index) {
                return SvgPicture.asset(
                  "assets/icons/star_box_icon.svg",
                  color: kAppColor,
                );
              },
              unratedColor: kLightColor,
              onRatingUpdate: (double rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const Gap(gap: kGap),
            TextFormField(
              controller: _cComment,
              validator: (str) => Utils.validateString(str),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lController.getLang("Write comment"),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const Gap(gap: kOtGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   child: ButtonSmall(
                //     title: "Add Photo",
                //     icon: const Icon(Icons.camera_alt_rounded, size: 20),
                //     width: double.infinity,
                //     onPressed: _onTapAddPhoto,
                //   ),
                // ),
                // const Gap(gap: kHalfGap),
                Expanded(
                  child: ButtonSmall(
                    title: lController.getLang("Confirm"),
                    width: double.infinity,
                    onPressed: _onTapPost,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // void _onTapAddPhoto() {}

  Future<void> _onTapPost() async {
    if (_formKey.currentState!.validate()) {
      bool res = false;
      if(!widget.model.isValid()){
        res = await ApiService.processCreate(
          'seller-shop-rating',
          needLoading: true,
          input: {
            "sellerShopId": widget.shopId,
            "rating": _rating,
            "comment": _cComment.text,
            "images": [],
          },
        );
      }else{
        res = await ApiService.processUpdate(
          'seller-shop-rating',
          needLoading: true,
          input: {
            "_id": widget.model.id,
            "rating": _rating,
            "comment": _cComment.text,
            "images": [],
          },
        );
      }
      if(res){
        Get.back();
        ShowDialog.showForceDialog(
          lController.getLang("Rated successed"),
          lController.getLang("text_rate_1"),
          () => Get.back()
        );
      }
    }
  }
}