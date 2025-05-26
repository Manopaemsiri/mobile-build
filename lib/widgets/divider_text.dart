import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class DividerText extends StatelessWidget {
  const DividerText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Divider(
                thickness: 2,
                color: kAppColor,
              ),
            ),
          ),
          Text(text, style: headline6.copyWith(color: kAppColor)),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Divider(
                thickness: 2,
                color: kAppColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
