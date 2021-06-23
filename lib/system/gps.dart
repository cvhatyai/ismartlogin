import 'package:location/location.dart';

Location _location = new Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
double _latitude; // Latitude, in degrees
double _longitude; // Longitude, in degrees

class LocationService {
  static checkService() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    print("Check Service Location : " + _serviceEnabled.toString());
  }

  getLocation() {
    String a = '';
    _location.onLocationChanged.listen((LocationData currentLocation) {
      _latitude = currentLocation.latitude.toDouble();
      _longitude = currentLocation.longitude.toDouble();
      a = "" + _latitude.toString() + "," + _longitude.toString();
      print(a);
      return a;
    });
  }
}
