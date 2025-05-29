import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class TextFieldRating extends StatelessWidget {
  const TextFieldRating({
    super.key,
    required this.controller,
    required this.focusNode,
  });
  
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: bodyText2.copyWith(
        fontWeight: FontWeight.w300
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(kHalfGap, kHalfGap, kHalfGap, kHalfGap),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kLightColor),
          borderRadius: BorderRadius.circular(kRadius) 
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kAppColor),
          borderRadius: BorderRadius.circular(kRadius)
        ),
      ),
      textInputAction: TextInputAction.newline,
      onFieldSubmitted: (str) => FocusScope.of(context).unfocus(),
      maxLines: 5,
      maxLength: 500,
    );
  }
}