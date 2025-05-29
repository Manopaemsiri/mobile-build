import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/screens/seller/shop/components/near_by_tab_bar.dart';
import 'package:coffee2u/screens/seller/shop/components/tab_near_by_map.dart';
import 'package:coffee2u/screens/seller/shop/components/tab_near_by.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';


class SellerShopsScreen extends StatefulWidget {
  const SellerShopsScreen({
    super.key
  });

  @override
  State<SellerShopsScreen> createState() => _SellerShopsScreenState();
}

class _SellerShopsScreenState extends State<SellerShopsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  int _tabIndex = 0;

  bool isLoading = true;
  Location location = Location();
  late double _lat;
  late double _lng;

  Widget _body() {
    if(isLoading){
      return Padding(
        padding: const EdgeInsets.only(top: 3*kGap),
        child: Loading(),
      );
    }else{
      if(_tabIndex == 0){
        return TabNearBy(lat: _lat, lng: _lng);
      }else if(_tabIndex == 1){
        return TabNearByMap(lat: _lat, lng: _lng);
      }else{
        return const SizedBox.shrink();
      }
    }
  }

  _completeLoading({ double? lat, double? lng }){
    setState(() {
      isLoading = false;
      _lat = lat ?? 13.8100769629;
      _lng = lng ?? 100.5966026673;
    });
  }

  _initState() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled){
        return _completeLoading();
      }
    }

    //Test 
    return _completeLoading();

    PermissionStatus _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return _completeLoading();
      }
    }


    LocationData _locationData = await location.getLocation();
    return _completeLoading(
      lat: _locationData.latitude,
      lng: _locationData.longitude,
    );
  }
  
  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang("Coffee Near By")),
      ),
      body: Container(
        color: kWhiteColor,
        child: Column(
          children: <Widget>[
            Column(
              children: [
                NearByTabBar(
                  onChange: ((int index) {
                    setState(() {
                      _tabIndex = index;
                    });
                  }),
                ),
                const Divider(height: 1, thickness: 2),
              ],
            ),
            _body(),
          ],
        ),
      ),
    );
  }
}