import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/screens/seller/shop/list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class ListRelatedServices extends StatefulWidget {
  const ListRelatedServices({
    Key? key
  }): super(key: key);

  @override
  State<ListRelatedServices> createState() => _ListRelatedServicesState();
}

class _ListRelatedServicesState extends State<ListRelatedServices> {
  List<Map<String, dynamic>> list = [
    {
      "image": "assets/images/banner/01.jpg",
      //lController
      "title": "COFFEE NEAR BY",
      "withFilter": true,
      "onTab": (){
        Get.to(() => const SellerShopsScreen());
      }
    }, {
      "image": "assets/images/banner/02.jpg",
      "title": "",
      "withFilter": false,
      "onTab": () async {
        await LaunchApp.openApp(
          androidPackageName: 'com.aromagroup.chaodoi',
          iosUrlScheme: 'coffee2u.nilecon://',
          appStoreLink: 'itms-apps://itunes.apple.com/us/app/pulse-secure/id1607244227',
          openStore: true
        );
      }
    }
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: _buildItem(list),
      options: CarouselOptions(
        aspectRatio: 2.8,
        viewportFraction: (Get.width - 16) / Get.width,
      ),
    );
  }

  List<Widget> _buildItem(List<Map<String, dynamic>> list) {
    const _margin = EdgeInsets.all(kHalfGap);
    const _radius = BorderRadius.all(Radius.circular(kRadius));

    return list.map((item) {
      return Stack(
        children: [
          Container(
            margin: _margin,
            child: ClipRRect(
              borderRadius: _radius,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  item["image"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if(item["withFilter"]) ...[
            Positioned.fill(
              child: Container(
                margin: _margin,
                decoration: const BoxDecoration(
                  borderRadius: _radius,
                  color: Colors.black38,
                ),
              ),
            ),
          ],
          Positioned.fill(
            child: Center(
              child: Text(
                item["title"],
                style: headlineRelatedServices,
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: _margin,
                decoration: const BoxDecoration(
                  borderRadius: _radius,
                ),
                child: InkWell(
                  onTap: item["onTab"],
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}