import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonSignInFacebook extends StatelessWidget {
  const ButtonSignInFacebook({
    super.key,
    this.title = "Signin with Facebook",
    required this.lController
  });

  final String title;
  final LanguageController lController;

  @override
  Widget build(BuildContext context) {
    return ButtonSignInSocial(
      title: lController.getLang(title),
      color: kLightColor,
      leftWigget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kLightColor, width: 1),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.facebookF,
                size: 24,
                color: kLightColor,
              ),
            ),
          ),
        ],
      ),
      onPressed: _onPress,
    );
  }

  void _onPress() {
    //
  }
}
