import 'dart:async';

import 'package:flutter/services.dart';
import 'package:map_launcher/src/directions_url.dart';
import 'package:map_launcher/src/marker_url.dart';
import 'package:map_launcher/src/models.dart';
import 'package:map_launcher/src/utils.dart';

class MapLauncher {
  static const MethodChannel widgetChannel = MethodChannel('map_launcher');

  /// Returns list of installed map apps on the device.
  static Future<List<AvailableMap>> get installedMaps async {
    final maps = await widgetChannel.invokeMethod('getInstalledMaps');
    return List<AvailableMap>.from(
      maps.map((map) => AvailableMap.fromJson(map)),
    );
  }

  /// Opens map app specified in [mapType]
  /// and shows marker at [coords]
  static Future<dynamic> showMarker({
    required MapType mapType,
    required Coords coords,
    required String title,
    String? description,
    int? zoom,
    Map<String, String>? extraParams,
  }) async {
    final String url = getMapMarkerUrl(
      mapType: mapType,
      coords: coords,
      title: title,
      description: description,
      zoom: zoom,
      extraParams: extraParams,
    );

    final Map<String, String?> args = {
      'mapType': Utils.enumToString(mapType),
      'url': Uri.encodeFull(url),
      'title': title,
      'description': description,
      'latitude': coords.latitude.toString(),
      'longitude': coords.longitude.toString(),
    };
    return widgetChannel.invokeMethod('showMarker', args);
  }

  /// Opens map app specified in [mapType]
  /// and shows directions to [destination]
  static Future<dynamic> showDirections({
    required MapType mapType,
    required Coords destination,
    String? destinationTitle,
    Coords? origin,
    String? originTitle,
    List<Waypoint>? waypoints,
    DirectionsMode? directionsMode = DirectionsMode.driving,
    Map<String, String>? extraParams,
  }) async {
    final url = getMapDirectionsUrl(
      mapType: mapType,
      destination: destination,
      destinationTitle: destinationTitle,
      origin: origin,
      originTitle: originTitle,
      waypoints: waypoints,
      directionsMode: directionsMode,
      extraParams: extraParams,
    );

    final Map<String, dynamic> args = {
      'mapType': Utils.enumToString(mapType),
      'url': Uri.encodeFull(url),
      'destinationTitle': destinationTitle,
      'destinationLatitude': destination.latitude.toString(),
      'destinationLongitude': destination.longitude.toString(),
      'destinationtitle': destinationTitle,
      'originLatitude': origin?.latitude.toString(),
      'originLongitude': origin?.longitude.toString(),
      'originTitle': originTitle,
      'directionsMode': Utils.enumToString(directionsMode),
      'waypoints': (waypoints ?? [])
          .map((waypoint) => {
                'latitude': waypoint.latitude.toString(),
                'longitude': waypoint.longitude.toString(),
                'title': waypoint.title,
              })
          .toList(),
    };
    return widgetChannel.invokeMethod('showDirections', args);
  }

  /// Returns boolean indicating if map app is installed
  static Future<bool?> isMapAvailable(MapType mapType) async {
    return widgetChannel.invokeMethod(
      'isMapAvailable',
      {'mapType': Utils.enumToString(mapType)},
    );
  }
}
