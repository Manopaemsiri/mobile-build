import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double appBarHeight = 220;

class AppBarSignIn extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSignIn({
    Key? key,
    this.preferredSize = const Size.fromHeight(appBarHeight),
  }) : super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _logoWidth = _width / 5.5;

    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: kWhiteColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: kAppColor,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
        child: Container(
          height: appBarHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/sign-in-bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: kToolbarHeight - kGap),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo-app-white.png',
                  width: _logoWidth,
                  height: _logoWidth,
                ),
                const Gap(gap: kHalfGap),
                Text(
                  "Welcome To Coffee2U",
                  style: subtitle1.copyWith(
                    fontFamily: "CenturyGothic",
                    color: kWhiteColor,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
