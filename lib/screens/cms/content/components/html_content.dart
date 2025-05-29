import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html_unescape/html_unescape.dart';

class HtmlContent extends StatefulWidget {
  const HtmlContent({
    super.key,
    required this.content,
  });

  final String content;

  @override
  State<HtmlContent> createState() => _HtmlContentState();
}

class _HtmlContentState extends State<HtmlContent> {
  var unescape = HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return Html(
      data: unescape.convert(widget.content.replaceAll('\n', '')),
      shrinkWrap: true,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(16.0),
          fontFamily: 'Kanit',
          lineHeight: const LineHeight(1.7)
        ),
        'h1, h2, h3, h4, h5, h6, p': Style(
          margin: Margins.only(top: 6),
          padding: HtmlPaddings.zero,
          fontSize: FontSize(16.0),
          lineHeight: const LineHeight(1.7),
          fontFamily: 'Kanit',
        ),
        'h6': Style(
          fontSize: FontSize(18.0),
          lineHeight: const LineHeight(1.6),
        ),
        'h5': Style(
          fontSize: FontSize(20.0),
          lineHeight: const LineHeight(1.45),
        ),
        'h4': Style(
          fontSize: FontSize(22.0),
          lineHeight: const LineHeight(1.3),
        ),
        'h3': Style(
          fontSize: FontSize(24.0),
          lineHeight: const LineHeight(1.25),
        ),
        'h2': Style(
          fontSize: FontSize(26.0),
          lineHeight: const LineHeight(1.2),
        ),
        'h1': Style(
          fontSize: FontSize(28.0),
          lineHeight: const LineHeight(1.15),
        ),
        'ul, ol': Style(
          fontFamily: 'Kanit',
          margin: Margins.zero,
          padding: HtmlPaddings.only(left: 22),
        ),
        'li': Style(
          fontFamily: 'Kanit',
          margin: Margins.zero,
          padding: HtmlPaddings.only(left: 6, top: 0, right: 6, bottom: 0),
          lineHeight: const LineHeight(1.7),
        ),
        'table': Style(
          fontFamily: 'Kanit',
          margin: Margins.only(top: 15),
          border: const Border(
            top: BorderSide(color: Colors.black12),
          )
        ),
        'table th': Style(
          fontFamily: 'Kanit',
          padding: HtmlPaddings.only(left: 10, top: 10, right: 10, bottom: 0),
          alignment: Alignment.centerLeft,
          border: const Border(
            right: BorderSide(color: Colors.black12),
            bottom: BorderSide(color: Colors.black12)
          ),
          backgroundColor: const Color(0xEEEEEEEE),
          lineHeight: const LineHeight(1.7),
        ),
        'table th:first-child': Style(
          fontFamily: 'Kanit',
          padding: HtmlPaddings.all(10),
          alignment: Alignment.centerLeft,
          border: const Border(
            left: BorderSide(color: Colors.black12),
            right: BorderSide(color: Colors.black12),
            bottom: BorderSide(color: Colors.black12)
          ),
          backgroundColor: const Color(0xEEEEEEEE),
        ),
        'table td': Style(
          fontFamily: 'Kanit',
          padding: HtmlPaddings.all(10),
          alignment: Alignment.centerLeft,
          border: const Border(
            right: BorderSide(color: Colors.black12),
            bottom: BorderSide(color: Colors.black12)
          ),
          lineHeight: const LineHeight(1.7),
        ),
        'table td:first-child': Style(
          fontFamily: 'Kanit',
          padding: HtmlPaddings.only(left: 10, top: 10, right: 10, bottom: 0),
          alignment: Alignment.centerLeft,
          border: const Border(
            left: BorderSide(color: Colors.black12),
            right: BorderSide(color: Colors.black12),
            bottom: BorderSide(color: Colors.black12)
          )
        ),
      },
      onLinkTap: (String? url, Map<String, String> attributes, element) async {
        if(url != null && url.contains("FRONTEND_URL")){
          if(url.contains('/page/') 
          || url.contains('/content/') 
          || url.contains('/event/')){
            // var temp = url.split('/');
          }else{
            await launchUrl(Uri.parse(url));
          }
        }else if(url != null){
          await launchUrl(Uri.parse(url));
        }
      },
      // onImageError: (Object object, StackTrace? stackTrace) => AspectRatio(
      //   aspectRatio: 1.8,
      //   child: Container(
      //     decoration: const BoxDecoration(
      //       color: kGrayColor,
      //       borderRadius: BorderRadius.all(Radius.circular(kRadius)),
      //     ),
      //     child: const Center(
      //       child: Icon(
      //         Icons.photo,
      //         size: 40,
      //         color: kGrayLightColor,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}