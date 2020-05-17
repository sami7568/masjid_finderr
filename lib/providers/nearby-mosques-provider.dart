import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NearbyMosquesProvider extends ChangeNotifier {
  final geoLocator = Geolocator();
  bool isPermissionsGranted;
  bool isGpsEnabled;

  NearbyMosquesProvider() {
    _checkLocationPermissions();
    _isGpsEnabled();
  }

  _checkLocationPermissions() async {
    var status = await geoLocator.checkGeolocationPermissionStatus();

    if (status == GeolocationStatus.granted) {
      isPermissionsGranted = true;
    } else {
      isPermissionsGranted = false;
    }

    print('@checkLocationPermissions: Status: $isPermissionsGranted');
    notifyListeners();
  }

  Future<void> _isGpsEnabled() async {
    isGpsEnabled = await geoLocator.isLocationServiceEnabled();
    print('@isGpsEnabled: Status: $isGpsEnabled');
    notifyListeners();
  }

  enableGPS() async {
    if (Platform.isAndroid) {
      final AndroidIntent intent =
          AndroidIntent(action: 'android.settings.LOCATION_SOURCE_SETTINGS');
      await intent.launch();
      await Future.delayed(Duration(seconds: 2));
      await _isGpsEnabled();
    }
  }
}
