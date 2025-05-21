import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';

class OrgMap extends StatefulWidget {
  OrgMap({
    Key key,
  }) : super(key: key);

  @override
  _OrgMapState createState() => _OrgMapState();
}

class _OrgMapState extends State<OrgMap> {
  GoogleMapController _mapController;
  LatLng _center = LatLng(13.736717, 100.523186); // ตำแหน่งเริ่มต้น (กรุงเทพฯ)
  LatLng _lastMapPosition = LatLng(13.736717, 100.523186); // พิกัดล่าสุด

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastMapPosition = position.target;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: StylePage().background,
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppBar(
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  actions: [],
                  title: Text(
                    'MAP',
                    style: StylesText.titleAppBar,
                  ),
                  backgroundColor: Colors.white.withOpacity(0),
                  elevation: 0,
                ),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 15.0,
                        ),
                        onCameraMove:
                            _onCameraMove, // ดึงพิกัดใหม่เมื่อเลื่อนแผนที่
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Center(
                        child: Icon(Icons.location_pin,
                            size: 50, color: Colors.red),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(
                        'Lat: ${_lastMapPosition.latitude}, Lng: ${_lastMapPosition.longitude}',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
