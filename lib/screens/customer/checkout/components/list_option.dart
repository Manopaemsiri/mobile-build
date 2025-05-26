import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:flutter/material.dart';

class ListOption extends StatelessWidget {
  const ListOption({
    Key? key,
    required this.icon,
    required this.title,
    this.iconImageAsset,
    this.description = '',
    this.trailings = const <Widget>[],
    this.onTap,
    this.divider = true,
    required this.lController,
    this.descriptionColor

  }) : super(key: key);

  final IconData icon;
  final String title;
  final String? iconImageAsset;
  final String description;
  final List<Widget> trailings;
  final VoidCallback? onTap;
  final bool divider;
  final LanguageController lController;
  final Color? descriptionColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          minLeadingWidth: 0,
          contentPadding: const EdgeInsets.only(left: kGap, right: kGap),
          leading: SizedBox(
            width: 24,
            child: Center(child: iconImageAsset != null? Image.asset(iconImageAsset!, width: 16, height: 16, color: kAppColor,): Icon(icon, size: 16, color: kAppColor)),
          ),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, kQuarterGap, 0, kQuarterGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: subtitle1.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                ),
                description != ''
                  ? Text(
                    description,
                    style: subtitle2.copyWith(
                      fontWeight: FontWeight.w400,
                      color: descriptionColor ?? kDarkLightColor
                    )
                  ): const SizedBox.shrink(),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailings.isNotEmpty) ...[
                ...trailings
              ] else ...[
                Text(
                  lController.getLang("Apply coupon"),
                  style: bodyText2.copyWith(
                    color: kGrayColor,
                    fontWeight: FontWeight.w300
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ],
          ),
          onTap: onTap,
        ),
        if (divider) ...[
          const Divider(height: 1),
        ],
      ],
    );
  }
}
