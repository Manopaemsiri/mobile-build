import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: PopupMenuButton<int>(
        icon: SvgPicture.asset(
          Utils.appLocale.languageCode == 'th'
              ? "assets/icons/th.svg"
              : "assets/icons/us.svg",
          height: 20,
          width: 20,
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/th.svg",
                  height: 18,
                  width: 18,
                ),
                const Gap(gap: kHalfGap),
                Text(
                  "TH",
                  style: subtitle2.copyWith(
                      color: Utils.appLocale.languageCode == 'th'
                          ? kAppColor
                          : kDarkColor),
                )
              ],
            ),
            value: 0,
          ),
          const PopupMenuDivider(height: 0),
          PopupMenuItem(
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/us.svg",
                  height: 18,
                  width: 18,
                ),
                const Gap(gap: kHalfGap),
                Text(
                  "EN",
                  style: subtitle2.copyWith(
                      color: Utils.appLocale.languageCode == 'en'
                          ? kAppColor
                          : kDarkColor),
                )
              ],
            ),
            value: 1,
          ),
        ],
        onSelected: (value) async {
          final prefs = await SharedPreferences.getInstance();

          if (value == 0) {
            await prefs.setInt(prefLocalLanguage, 0);
          } else {
            await prefs.setInt(prefLocalLanguage, 1);
          }
          Phoenix.rebirth(context);
        },
      ),
    );
  }
}
