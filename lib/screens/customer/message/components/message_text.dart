import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageText extends StatelessWidget {
  const MessageText({
    super.key,
    required this.model,
  });

  final Map<String, dynamic> model;

  @override
  Widget build(BuildContext context) {
    Color widgetColor = kAppColor;
    double _width = MediaQuery.of(context).size.width * 0.75;

    bool _isSender = model["fromCustomer"] ?? false;
    String _message = model["text"] ?? '';

    return Flexible(
      child: Container(
        constraints: BoxConstraints(maxWidth: _width),
        padding: const EdgeInsets.symmetric(
          vertical: 12, horizontal: 14
        ),
        decoration: BoxDecoration(
          color: widgetColor.withValues(alpha: _isSender? 1: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Linkify(
              onOpen: (link) async {
                if (!await launchUrl(Uri.parse(link.url))) {
                  throw Exception('Could not launch ${link.url}');
                }
              },
              text: _message,
              style: TextStyle(
                color: _isSender? kWhiteColor: kDarkColor,
                fontWeight: FontWeight.w400
              ),
              linkStyle: const TextStyle(
                color: kBlueColor,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> luancher() async {
    
  }

}