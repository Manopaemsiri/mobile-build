import 'package:coffee2u/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoConnection extends StatelessWidget {
  NoConnection({
    super.key, 
    required this.onPressed
  });

  final VoidCallback onPressed;
  final LanguageController lController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(lController.getLang('Connection Failed')),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(lController.getLang('Refresh')),
          ),
        ],
      ),
    );
  }
}
