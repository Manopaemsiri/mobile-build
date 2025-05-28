import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;


class PinOnMaps extends StatefulWidget {
  PinOnMaps({
    super.key,
    this.addressModel,
    required this.onSubmit,
    this.latLng,
    this.isEditMode = false,
  });

  CustomerShippingAddressModel? addressModel;
  Function(double, double) onSubmit;
  LatLng? latLng;
  bool isEditMode;

  @override
  State<PinOnMaps> createState() => _PinOnMapsState();
}

class _PinOnMapsState extends State<PinOnMaps> {
  final LanguageController lController = Get.find<LanguageController>();
  late GoogleMapController _mapController;
  late LatLng _mapCenter = widget.latLng 
    ?? const LatLng(13.793125766310437, 100.71096012637591);
  late Set<Marker> _mapMarkers = {};
  late Uint8List? _mapMarkerIcon;
  late String address;

  @override
  void initState() {
    setState(() {
      address = widget.addressModel?.displayAddress(lController) ?? '';
    });
    if(widget.latLng != null){
      _onAddMarkerButtonPressed(widget.latLng!);
    }
    super.initState();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer.asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((value) {
        _mapCenter = LatLng(value.latitude, value.longitude);
        _onAddMarkerButtonPressed(_mapCenter);
        _mapController.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _mapCenter, zoom: 12)));
      });
  }

  Future<void> getAddressFromLatLong() async {
    List<Location>? locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      _mapCenter = LatLng(locations.first.latitude, locations.first.longitude);
      _onAddMarkerButtonPressed(_mapCenter);
      setState(() {
        _mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _mapCenter, zoom: 12),
          ),
        );
      });
    }
  }

  void _onAddMarkerButtonPressed(LatLng latLng) async {
    _mapMarkerIcon = await getBytesFromAsset(defaultPin, 100);
    if (_mapMarkers.isNotEmpty) {
      _mapMarkers.clear();
    }
    setState(() {
      _mapCenter = latLng;
      _mapMarkers.add(Marker(
        position: latLng,
        markerId: MarkerId(latLng.toString()),
        icon: BitmapDescriptor.bytes(_mapMarkerIcon!),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang(
          widget.isEditMode ? "Edit Address" : "Add New Address"
        )),
        bottom: const AppBarDivider(),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            markers: _mapMarkers,
            onTap: (latLng) {
              _onAddMarkerButtonPressed(
                LatLng(latLng.latitude, latLng.longitude)
              );
            },
            initialCameraPosition: CameraPosition(
              target: _mapCenter,
              zoom: 12.0,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: kHalfPadding,
              child: Row(
                children: [
                  ButtonTextBackground(
                    title: lController.getLang("Current Location"),
                    onTap: _getGeoLocationPosition,
                    backgroundColor: kAppColor,
                    textColor: kWhiteColor,
                  ),
                  const Gap(
                    gap: kHalfGap,
                  ),
                  if(address != '') ...[
                    ButtonTextBackground(
                      title: lController.getLang("Lat Lng"),
                      onTap: getAddressFromLatLong,
                      textColor: kWhiteColor,
                      backgroundColor: kAppColor,
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Padding(
        padding: kPaddingSafeButton,
        child: ButtonFull(
          title: lController.getLang("Save"),
          onPressed: () {
            widget.onSubmit(_mapCenter.latitude, _mapCenter.longitude);
            Get.back();
          },
        ),
      ),
    );
  }
}