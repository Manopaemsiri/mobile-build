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
  final Set<Marker> _mapMarkers = {};

  _initState() async {
    if(widget.model.address != null 
    && widget.model.address?.lat != null 
    && widget.model.address?.lng != null){
      Uint8List dataMarkerIcon = await getBytesFromAsset(defaultPin, 100);
      LatLng dataCenter = LatLng(
        widget.model.address?.lat ?? 0,
        widget.model.address?.lng ?? 0
      );
      setState(() {
        _mapCenter = dataCenter;
        _mapMarkers.add(Marker(
          position: dataCenter,
          markerId: MarkerId(dataCenter.toString()),
          icon: BitmapDescriptor.bytes(dataMarkerIcon),
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
    SellerShopModel widgetModel = widget.model;
    CustomerShippingAddressModel? address = widgetModel.address;

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
                        widgetModel.name,
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

                      if(widgetModel.priceRange != 0) ...[
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
                              widgetModel.displayPriceRange(lController),
                              style: subtitle1.copyWith(
                                color: kDarkLightColor,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if(widgetModel.type != null) ...[
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
                              widgetModel.type!.name,
                              style: subtitle1.copyWith(
                                color: kDarkLightColor,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if(widgetModel.description != '') ...[
                        const SizedBox(height: kQuarterGap),
                        Text(
                          widgetModel.description,
                          style: subtitle1.copyWith(
                            color: kDarkLightColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: kOtGap),
                      _checkboxFeature(
                        widgetModel.capacity != ''
                          ? '${lController.getLang("Shop capacity")} ${widgetModel.capacity}'
                          : '${lController.getLang("Shop capacity")} -',
                        widgetModel.capacity != ''
                      ),
                      const SizedBox(height: 2),
                      _checkboxFeature(
                        lController.getLang("Has parking space"),
                        widgetModel.hasParkingSpace == 1
                      ),
                      const SizedBox(height: 2),
                      _checkboxFeature(
                        lController.getLang("Has Wifi"),
                        widgetModel.hasWifi == 1
                      ),
                      const SizedBox(height: 2),
                      _checkboxFeature(
                        lController.getLang("Accept Credit Cards"),
                        widgetModel.acceptCreditCards == 1
                      ),
                      const SizedBox(height: 2),
                      _checkboxFeature(
                        lController.getLang("Has Delivery"),
                        widgetModel.hasDelivery == 1
                      ),
                      const SizedBox(height: 2),
                      _checkboxFeature(
                        lController.getLang("Aroma Shop Member"),
                        widgetModel.isAromaShopMember == 1
                      ),
                      
                    ],
                  ),
                ),
                const Divider(height: 0.7, thickness: 0.7),

                if(widgetModel.telephones.isNotEmpty || widgetModel.line != '' || widgetModel.facebook != '' 
                || widgetModel.instagram != '' || widgetModel.website != '') ...[
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

                        if(widgetModel.telephones.isNotEmpty) ...[
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
                                widgetModel.telephones.join(', '),
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if(widgetModel.facebook != '') ...[
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
                                widgetModel.facebook,
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if(widgetModel.instagram != '') ...[
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
                                widgetModel.instagram,
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if(widgetModel.line != '') ...[
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
                                widgetModel.line,
                                style: subtitle1.copyWith(
                                  color: kDarkLightColor,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if(widgetModel.website != '') ...[
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
                                widgetModel.website,
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
                      ...widgetModel.workingHours!.map((WorkingHourModel dataModel){
                        return Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 104,
                                child: Text(
                                  dataModel.displayDay(lController),
                                  style: subtitle1.copyWith(
                                    color: kDarkLightColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  dataModel.isOpened == 1? lController.getLang('OPEN'): lController.getLang('CLOSED'),
                                  style: subtitle2.copyWith(
                                    color: dataModel.isOpened == 1? kGreenColor: kRedColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              dataModel.isOpened == 1
                                ? Text(
                                  '${dataModel.startTime} - ${dataModel.endTime}',
                                  style: subtitle2.copyWith(
                                    color: kDarkLightColor,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                                : const SizedBox.shrink(),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const Divider(height: 0.7, thickness: 0.7),
              
                if(widgetModel.youtubeVideoId != '') ...[
                  Padding(
                    padding: kPadding,
                    child: YoutubeView(
                      youtubeId: widgetModel.youtubeVideoId,
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

  _onTabMap(double dataLat, double dataLng) async {
    bool? isMapAvailable = await ml.MapLauncher.isMapAvailable(
      ml.MapType.google
    );
    if(isMapAvailable != null && isMapAvailable){
      await ml.MapLauncher.showMarker(
        mapType: ml.MapType.google,
        coords: ml.Coords(dataLat, dataLng),
        title: widget.model.name,
        description: widget.model.description,
      );
    }
  }
}