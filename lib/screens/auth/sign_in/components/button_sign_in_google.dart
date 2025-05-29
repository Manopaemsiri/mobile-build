import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonSignInGoogle extends StatelessWidget {
  const ButtonSignInGoogle({
    super.key,
    this.title = "Signin with Google",
    required this.lController
  });

  final String title;
  final LanguageController lController;


  @override
  Widget build(BuildContext context) {
    return ButtonSignInSocial(
      title: lController.getLang(title),
      leftWigget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kAppColor, width: 1),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.google,
                size: 24,
                color: kAppColor,
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
