import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/seller/shop/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;


class TabNearByMap extends StatefulWidget {
  const TabNearByMap({
    super.key,
    this.lat,
    this.lng,
  });

  final double? lat;
  final double? lng;

  @override
  State<TabNearByMap> createState() => _TabFavoritesState();
}

class _TabFavoritesState extends State<TabNearByMap> {
  final LanguageController lController = Get.find<LanguageController>();
  bool isReady = true;
  bool isTabReady = true;

  late GoogleMapController _mapController;
  Set<Marker> _mapMarkers = {};
  List<String> _markerIds = [];
  late Uint8List? _mapMarkerIcon;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer.asUint8List();
  }

  _onMapCreated(GoogleMapController _controller) {
    setState(() {
      _mapController = _controller;
    });
  }
  _onCameraIdle() async {
    if(isReady && _mapMarkerIcon != null){
      setState(() => isReady = false);
      LatLngBounds bounds = await _mapController.getVisibleRegion();
      var res = await ApiService.processList('map-seller-shops', input: {
        "paginate": { "pp": 50 },
        "dataFilter": {
          "lat": widget.lat,
          "lng": widget.lng,
          "exceptIds": _markerIds,
          "bounds": {
            "northeast": {
              "lat": bounds.northeast.latitude,
              "lng": bounds.northeast.longitude,
            },
            "southwest": {
              "lat": bounds.southwest.latitude,
              "lng": bounds.southwest.longitude,
            }
          }
        }
      });

      if(res!["result"] != null){
        Set<Marker> _temp = _mapMarkers;
        int len = res["result"].length;
        for(int i=0; i<len; i++){
          SellerShopModel _d = SellerShopModel.fromJson(res["result"][i]);
          setState(() => _markerIds.add(_d.id ?? ''));
          _temp.add(Marker(
            position: LatLng(
              _d.address?.lat ?? 0,
              _d.address?.lng ?? 0
            ),
            markerId: MarkerId(_d.id ?? ''),
            icon: BitmapDescriptor.fromBytes(_mapMarkerIcon!),
            anchor: const Offset(0.5, 0.5),
            onTap: () => _onTabMarker(_d),
          ));
        }
        setState(() => _mapMarkers = _temp);
      }
      setState(() => isReady = true);
    }
  }

  _initState() async {
    _mapMarkerIcon = await getBytesFromAsset(defaultPin, 100);
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _mapMarkers,
        minMaxZoomPreference: const MinMaxZoomPreference(10, null),
        onMapCreated: _onMapCreated,
        onCameraIdle: _onCameraIdle,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.lat ?? 13.8100769629,
            widget.lng ?? 100.5966026673,
          ),
          zoom: 14.0,
        ),
      ),
    );
  }

  _onTabMarker(SellerShopModel model) {
    if(isTabReady){
      setState(() => isTabReady = false);

      String widgetImage = model.logo != null? model.logo!.path
        : model.image != null? model.image!.path: '';
      String? widgetDistance = model.distance == null ? "" : "${model.distance} km.";

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: kPadding,
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: title.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.35
                    ),
                  ),
                  const Gap(gap: kQuarterGap),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RatingBarIndicator(
                        rating: model.averageRating ?? 0,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        unratedColor: kLightColor,
                        itemCount: 5,
                        itemSize: 16,
                      ),
                      const Gap(gap: kOtGap),
                      if(model.distance != null) ...[
                        const Icon(
                          Icons.near_me_outlined,
                          color: kGrayColor,
                          size: 14,
                        ),
                        const Gap(gap: kQuarterGap),
                        Text(
                          widgetDistance,
                          style: caption.copyWith(
                            color: kGrayColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(gap: kQuarterGap),
                  Row(
                    children: [
                      model.displayIsOpen(bodyText2),
                      const Gap(gap: kOtGap),
                      model.isOpen()
                        ? Text(
                          model.todayOpenRange(),
                          style: bodyText2.copyWith(
                            color: kGrayColor,
                            fontWeight: FontWeight.w400
                          ),
                        )
                        : const SizedBox.shrink(),
                    ],
                  ),
                  const Gap(gap: kHalfGap),
                  Container(
                    width: double.infinity,
                    height: 240,
                    decoration: BoxDecoration(
                      border: Border.all(color: kLightColor, width: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0)
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ImageUrl(imageUrl: widgetImage),
                      ),
                    ),
                  ),
                  const Gap(gap: kGap),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ButtonCustom(
                          isOutline: true,
                          height: kButtonMiniHeight,
                          title: lController.getLang("Close"),
                          onPressed: (){
                            Get.back();
                            setState(() => isTabReady = true);
                          },
                        ),
                      ),
                      const Gap(gap: kHalfGap),
                      Expanded(
                        child: ButtonCustom(
                          height: kButtonMiniHeight,
                          title: lController.getLang("View Shop"),
                          onPressed: (){
                            Get.back();
                            Get.to(() => SellerShopScreen(
                              shopId: model.id ?? '',
                              lat: widget.lat,
                              lng: widget.lng
                            ));
                            setState(() => isTabReady = true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ).then((value){
        setState(() => isTabReady = true);
      });
    }
  }
}