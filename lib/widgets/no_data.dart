import 'package:coffee2u/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoData extends StatelessWidget {
  NoData({
    Key? key,
    this.onPressed,
    this.title,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.spacer = true,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String? title;
  final MainAxisAlignment mainAxisAlignment;
  final LanguageController lController = Get.find<LanguageController>();
  final bool spacer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if(spacer)...[
            const SizedBox(height: 32),
          ],
          Text(lController.getLang(title ?? 'No Data Found')),
          if(onPressed != null)...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(lController.getLang('Refresh')),
            ),
          ]
        ],
      ),
    );
  }
}
