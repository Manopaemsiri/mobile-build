import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key, 
    this.url,
    this.title = "External Content",
  });
  final String? url;
  final String title;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final LanguageController _lController = Get.find<LanguageController>();
  late WebViewController controller;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
    ..setBackgroundColor(const Color(0xFFFFFFFF))
    ..enableZoom(false)
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {},
        onPageFinished: (_) {
          if(mounted) setState(() => isLoading = false);
        },
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (_) {
          if(mounted) {
            setState(() {
              isLoading = false;
              isError = true;
            });
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(widget.url ?? ''));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text(_lController.getLang(widget.title)),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if(isLoading) ...[
            Loading()
          ]else if(!isLoading && isError == true) ...[
            NoData()
          ]
        ],
      ),
    );
  }
}