import 'package:coffee2u/controller/language_controller.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBody extends StatelessWidget {
  const MapBody({
    Key? key,
    required this.lController
  }) : super(key: key);
  final LanguageController lController;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      child: Center(
        child: Text(lController.getLang("text_map_error_1")),
      ),
      // child: const GoogleMap(
      //   mapType: MapType.normal,
      //   initialCameraPosition: CameraPosition(
      //     target: LatLng(13.7650836, 100.523186),
      //     zoom: 10,
      //   ),
      //   myLocationButtonEnabled: true,
      //   myLocationEnabled: true,
      // ),
    );
  }
}
