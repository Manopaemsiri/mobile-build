import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/product/components/youtube_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as ml;
import 'dart:ui' as ui;

class SellerShopInfo extends StatefulWidget {
  const SellerShopInfo({
    super.key,
    required this.model,
  });

  final SellerShopModel model;

  @override
  State<SellerShopInfo> createState() => _SellerShopInfoState();
}

class _SellerShopInfoState extends State<SellerShopInfo> {
  final LanguageController lController = Get.find<LanguageController>();
  LatLng? _mapCenter;
  Set<Marker> _mapMarkers = {};

  _initState() async {
    if(widget.model.address != null 
    && widget.model.address?.lat != null 
    && widget.model.address?.lng != null){
      Uint8List _mapMarkerIcon = await getBytesFromAsset(defaultPin, 100);
      LatLng _tempCenter = LatLng(
        widget.model.address?.lat ?? 0,
        widget.model.address?.lng ?? 0
      );
      setState(() {
        _mapCenter = _tempCenter;
        _mapMarkers.add(Marker(
          position: _tempCenter,
          markerId: MarkerId(_tempCenter.toString()),
          icon: BitmapDescriptor.fromBytes(_mapMarkerIcon),
        ));
      });
    }
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer.asUint8List();
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SellerShopModel _model = widget.model;
    CustomerShippingAddressModel? address = _model.address;

    return SafeArea(
      top: false,
      bottom: true,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: kPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _model.name,
                        style: headline6.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w500,
                          height: 1.4
                        ),
                      ),
                      if(address != null && address.isValid()) ...[
                        const SizedBox(height: kHalfGap),
                        address.address != ''
                          ? Text(
                            address.address,
                            style: subtitle1.copyWith(
                              color: kDarkLightColor,
                              fontWeight: FontWeight.w300,
                              height: 1.35
                            ),
                          ): const SizedBox.shrink(),
                        Text(
                          '${address.prefixSubdistrict(lController)}${address.subdistrict?.name ?? '-'} ${address.prefixDistrict(lController)}${address.district?.name ?? '-'}',
                          style: subtitle1.copyWith(
                            color: kDarkLightColor,
                            fontWeight: FontWeight.w300,
                            height: 1.35
                          ),
                        ),
                        Text(
                          '${lController.getLang("Province")}${address.province?.name ?? '-'} ${lController.getLang("Country")}${address.country?.name ?? '-'}  ${address.zipcode}',
                          style: subtitle1.copyWith(
                            color: kDarkLightColor,
                            fontWeight: FontWeight.w300,
                            height: 1.35
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Divider(height: 0.7, thickness: 0.7),

                Padding(
                  padding: kPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lController.getLang("Shop Info"),
                        style: title.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      if(_model.priceRange != 0) ...[
                        const SizedBox(height: kQuarterGap),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${lController.getLang("Price range")} :',
                              style: subtitle1.copyWith(
                                color: kDarkLightColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: kQuarterGap),
                            Text(
                              _model.displayPriceRange(lController),
                              style: subtitle1.copyWith(
                                color: kDarkLightColor,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if(_model.type != null) ...[
                        const SizedBox(height: kQuarterGap),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${lController.getLang("Shop Type")} :',
                              style: subtitle1.copyWith(
                                color: kDarkLightColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: kQuarterGap),
                            Text(
                              _model.type!.name,
                              style: subtitle1.copyWith(
                                color: kDarkLightColor,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if(_model.description != '') ...[
                        const SizedBox(height: kQuarterGap),
                        Text(
                          _model.description,
                          style: subtitle1.copyWith(
                            color: kDarkLightColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: kOtGap),
                      _checkboxFeature(
                        _model.capacity != ''
                          ? '${lController.getLang("Shop capacity")} ${_model.capacity}'
                          : '${lController.getLang("Shop capacity")} -',
                        _model.capacity != ''
                      ),
                      const SizedBox(height: 2),
                      _checkboxFeature(
                        lController.getLang("Has parking space"),
                        _model.hasParkingSpace == 1
                      ),
                      const SizedBox(height: 2),
                      _checkboxFeature(
                        lController.getLang("Has Wifi"),
                        _model.hasWifi == 1
                      ),
                      const SizedBox(height: 2),
                      _checkboxFeature(
                        lController.getLang("Accept Credit Cards"),
                        _model.acceptCreditCards == 1
                      ),
                      const SizedBox(height: 2),
                      _checkboxFeature(
                        lController.getLang("Has Delivery"),
                        _model.hasDelivery == 1
                      ),
                      const SizedBox(height: 2),
                      _checkboxFeature(
                        lController.getLang("Aroma Shop Member"),
                        _model.isAromaShopMember == 1
                      ),
                      
                    ],
                  ),
                ),
                const Divider(height: 0.7, thickness: 0.7),

                if(_model.telephones.isNotEmpty || _model.line != '' || _model.facebook != '' 
                || _model.instagram != '' || _model.website != '') ...[
                  Padding(
                    padding: kPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lController.getLang("Contact Information"),
                          style: title.copyWith(
                            color: kDarkColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: kQuarterGap),

                        if(_model.telephones.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lController.getLang("Telephone Number")} :',
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: kQuarterGap),
                              Text(
                                _model.telephones.join(', '),
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if(_model.facebook != '') ...[
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lController.getLang("Facebook")} :',
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: kQuarterGap),
                              Text(
                                _model.facebook,
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if(_model.instagram != '') ...[
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lController.getLang("Instagram")} :',
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: kQuarterGap),
                              Text(
                                _model.instagram,
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if(_model.line != '') ...[
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lController.getLang("Line")} :',
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: kQuarterGap),
                              Text(
                                _model.line,
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if(_model.website != '') ...[
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lController.getLang("Website")} :',
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: kQuarterGap),
                              Text(
                                _model.website,
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Divider(height: 0.7, thickness: 0.7),
                ],

                Padding(
                  padding: kPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lController.getLang("Working Hours"),
                        style: title.copyWith(
                          color: kDarkColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: kQuarterGap),
                      ..._model.workingHours!.map((WorkingHourModel _d){
                        return Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 104,
                                child: Text(
                                  _d.displayDay(lController),
                                  style: subtitle1.copyWith(
                                    color: kDarkLightColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  _d.isOpened == 1? lController.getLang('OPEN'): lController.getLang('CLOSED'),
                                  style: subtitle2.copyWith(
                                    color: _d.isOpened == 1? kGreenColor: kRedColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              _d.isOpened == 1
                                ? Text(
                                  '${_d.startTime} - ${_d.endTime}',
                                  style: subtitle2.copyWith(
                                    color: kDarkLightColor,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                                : const SizedBox.shrink(),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const Divider(height: 0.7, thickness: 0.7),
              
                if(_model.youtubeVideoId != '') ...[
                  Padding(
                    padding: kPadding,
                    child: YoutubeView(
                      youtubeId: _model.youtubeVideoId,
                      backTo: Get.currentRoute,
                    ),
                  ),
                  const Divider(height: 0.7, thickness: 0.7),
                ],

                if(_mapCenter != null) ...[
                  Padding(
                    padding: kPadding,
                    child: InkWell(
                      onTap: () => _onTabMap(
                        address?.lat ?? 0,
                        address?.lng ?? 0
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: kGrayLightColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(kRadius),
                          ),
                        ),
                        height: 220,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(kRadius),
                              ),
                              child: IgnorePointer(
                                ignoring: true,
                                child: GoogleMap(
                                  scrollGesturesEnabled: false,
                                  zoomControlsEnabled: false,
                                  zoomGesturesEnabled: false,
                                  myLocationButtonEnabled: false,
                                  markers: _mapMarkers,
                                  initialCameraPosition: CameraPosition(
                                    target: _mapCenter!,
                                    zoom: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),  
                  ),
                  const Divider(height: 0.7, thickness: 0.7),
                ],
              
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkboxFeature(String text, bool isChecked) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          isChecked
            ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded,
          size: 20,
          color: kAppColor,
        ),
        const SizedBox(width: kHalfGap),
        Text(
          text,
          style: subtitle1.copyWith(
            color: kDarkLightColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  _onTabMap(double _lat, double _lng) async {
    bool? _isMapAvailable = await ml.MapLauncher.isMapAvailable(
      ml.MapType.google
    );
    if(_isMapAvailable != null && _isMapAvailable){
      await ml.MapLauncher.showMarker(
        mapType: ml.MapType.google,
        coords: ml.Coords(_lat, _lng),
        title: widget.model.name,
        description: widget.model.description,
      );
    }
  }
}