import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:flutter/material.dart';

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    Key? key,
    required this.txtTitle,
    required this.lController,
    required this.onTap,
    this.leadingIcon,
    this.leadingColor,
  }) : super(key: key);

  final String txtTitle;
  final LanguageController lController;
  final Function()? onTap;
  final IconData? leadingIcon;
  final Color? leadingColor;
  
  @override
  Widget build(BuildContext context) {
    
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(kGap, 0, kGap, 0),
      leading: leadingIcon != null? Icon(leadingIcon, color: leadingColor): null,
      title: Text(
        lController.getLang(txtTitle),
        style: subtitle1.copyWith(
          fontWeight: FontWeight.w400,
          color: leadingColor
        ),
      ),
      onTap: onTap,
    );
  }
}