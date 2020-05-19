import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocatorHelper {
  final geoLocator = Geolocator();

  getLocationPermissionsStatus() async {
    var status = await geoLocator.checkGeolocationPermissionStatus();

    if (status == GeolocationStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isGpsEnabled() async {
    final status = await geoLocator.isLocationServiceEnabled();
    print('@isGpsEnabled: Status: $status');
    return status;
  }

  Future<void> enableGps() async {
    if (Platform.isAndroid) {
      final AndroidIntent intent =
          AndroidIntent(action: 'android.settings.LOCATION_SOURCE_SETTINGS');
      await intent.launch();
    }
  }

//  getCurrentLocation() async {
//    final status = await isGpsEnabled();
//    if (status) {
//      Position currentLocation = await geoLocator.getCurrentPosition(
//          desiredAccuracy: LocationAccuracy.best,
//          locationPermissionLevel: GeolocationPermission.location);
//    } else {
//      return null;
//    }
//  }
}
