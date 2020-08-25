import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Location {
  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    bool gpsOn = await Geolocator().isLocationServiceEnabled();

    if (!gpsOn) {
      await getLocalData();
      return;
    }

    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

      latitude = position.latitude;
      longitude = position.longitude;
      storeLocal('latitude', latitude);
      storeLocal('longitude', longitude);
    } catch (e) {
      PlatformException r = e;
      print('error ${r.message}');
      await getLocalData();
    }
  }

  Future getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    latitude = preferences.get('latitude') ?? 51.5074;
    longitude = preferences.get('longitude') ?? 0.1278;
  }

  void storeLocal(String key, double data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(key, data);
  }
}
