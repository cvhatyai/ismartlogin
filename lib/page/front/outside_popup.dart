import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ismart_login/page/front/future/attend_future.dart';
import 'package:ismart_login/page/front/model/attendUpdateStart.dart';
import 'package:ismart_login/page/main.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/clock.dart';
import 'package:ismart_login/system/gps.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:location/location.dart';

Completer<GoogleMapController> _controller = Completer();
final currentTime = DateTime.now();

class OutsideDialog extends StatefulWidget {
  final int status;
  final String lat;
  final String uid;
  final String long;
  final String mainLat;
  final String mainLng;
  final String time;
  OutsideDialog({
    Key key,
    @required this.uid,
    this.status,
    this.lat,
    this.long,
    this.time,
    this.mainLat,
    this.mainLng,
  }) : super(key: key);
  @override
  _OutsideDialogState createState() => _OutsideDialogState();
}

class _OutsideDialogState extends State<OutsideDialog> {
  final _formKey = GlobalKey<FormState>();
  //-
  FToast fToast;
  Location _location = new Location();
  double latitude;
  double longitude;
  double myLat = 0.0;
  double myLong = 0.0;
  double setLat = 0.0;
  double setLong = 0.0;
  double totalDistance = 0;

  ///----
  List _checkboxListTile = ['โปรแกรมระบุตำแหน่งผิดพลาด', 'ทำงานนอกสถานที่','อื่นๆ'];
  List<bool> _checkbox = [false, false,false];
  List<String> _select = [];

  //------
  int currentIndex = 0;
  TextEditingController _inputNote = TextEditingController();
  //----
  @override
  void initState() {
    myLocation();
    super.initState();
    setLat = double.parse(widget.lat);
    setLong = double.parse(widget.long);
    fToast = FToast();
    fToast.init(context);
  }

  ///--
  List<ItemsUpdateAttandStartResult> _result = [];
  Future<bool> onLoadUpdateLocationAttandStart(Map map) async {
    await AttandFuture().apiUpdateAttandStart(map).then((onValue) {
      print(onValue[0].MSG);
      if (onValue[0].STATUS == 'success') {
        _result = onValue;
        _showToast(true, _result[0].MSG);
      } else {
        _showToast(false, _result[0].MSG);
      }
    });
    return true;
  }

  myLocation() {
    setState(() {
      myLat = double.parse(widget.lat);
      myLong = double.parse(widget.long);
    });
  }

  mapMark() {
    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.lat), double.parse(widget.long)),
      zoom: 18,
    );
    return _kGooglePlex;
  }

  addMarker({String latMain, String logMain}) {
    print(widget.lat + "," + widget.long);
    Set<Marker> markers = {};
    markers.add(Marker(
      markerId: MarkerId('Marker_main'),
      position:
          LatLng(double.parse(widget.mainLat), double.parse(widget.mainLng)),
      infoWindow: InfoWindow(title: 'ตำแหน่งองค์กร'),
      icon: BitmapDescriptor.defaultMarker,
    ));
    markers.add(Marker(
      markerId: MarkerId('Marker_user'),
      position: LatLng(double.parse(widget.lat), double.parse(widget.long)),
      infoWindow: InfoWindow(title: 'ตำแหน่งคุณ'),
      icon: BitmapDescriptor.defaultMarkerWithHue(95),
    ));
    return markers;
  }

// --- Time

  _circle() {
    Set<Circle> circles = Set.from([
      Circle(
          circleId: CircleId('id'),
          center: LatLng(
              double.parse(widget.mainLat), double.parse(widget.mainLng)),
          radius: 30,
          strokeColor: Colors.blue[200].withOpacity(0.5),
          fillColor: Colors.blue[100].withOpacity(0.3),
          strokeWidth: 2),
    ]);
    return circles;
  }

  //----

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      content: SingleChildScrollView(
        child: Container(
          width: WidhtDevice().widht(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      Clock().getTime(),
                      style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        height: 1,
                        fontSize: 40,
                        color: Color(0xFF757575),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Text(
                  'คุณไม่ได้อยู่ในพื้นที่',
                  style: TextStyle(
                      fontFamily: FontStyles().FontFamily,
                      fontSize: 22,
                      color: Colors.red),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'ตำแหน่งที่คุณล็อกอิน',
                  style: TextStyle(
                      fontFamily: FontStyles().FontFamily,
                      fontSize: 20,
                      color: Color(0xFF089AE5)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 150,
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: addMarker(
                    latMain: myLat.toString(),
                    logMain: myLong.toString(),
                  ),
                  initialCameraPosition: mapMark(),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  circles: _circle(),
                ),
              ),
              Container(
                child: Text(
                  'กรุณาระบุเหตุผล',
                  style: TextStyle(
                      fontFamily: FontStyles().FontFamily,
                      fontSize: 25,
                      color: Color(0xFF089AE5)),
                ),
              ),
              _radioButton(),
              Form(
                  key: _formKey,
                  child: 
                  _checkbox[1] == true || _checkbox[2] == true
                  ?
                  Column(
                    
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(27.0, 0.0, 0.0, 10.0),
                        child: Row(
                          children: [
                            Text(
                              'ระบุ',
                              style: TextStyle(
                                  fontFamily: FontStyles().FontFamily,
                                  fontSize: 22),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _inputNote,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontFamily: FontStyles().FontFamily,
                                    fontSize: 22),
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(
                                        0), // add padding to adjust icon
                                    child: Icon(
                                      Icons.edit,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  print("value $value");
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณาป้อนข้อมูล';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    if (widget.status == 1) {
                                      Map _map = {
                                        "status": "1", //เข้างาน
                                        "uid": widget.uid,
                                        "start_location_note":
                                            json.encode(_select),
                                        "start_location_sub_status":
                                            _inputNote.text,
                                      };
                                      print(_map);
                                      onLoadUpdateLocationAttandStart(_map);
                                    } else {
                                      Map _map = {
                                        "status": "2", //ออกงาน
                                        "uid": widget.uid,
                                        "end_location_note":
                                            json.encode(_select),
                                        "end_location_sub_status":
                                            _inputNote.text,
                                      };
                                      print(_map);
                                      onLoadUpdateLocationAttandStart(_map);
                                    }

                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainPage()),
                                    );
                                  }
                                },
                                child: Container(
            
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'ตกลง',
                                    style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  :Column()),
            ],
          ),
        ),
      ),
    );
  }

  _causeNote() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              'สาเหตุ',
              style:
                  TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 22),
            ),
            Expanded(
              child: TextFormField(
                controller: _inputNote,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    fontFamily: FontStyles().FontFamily, fontSize: 22),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(0), // add padding to adjust icon
                    child: Icon(
                      Icons.edit,
                      size: 22,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  form() {}

  _radioButton() {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 15.0),
        shrinkWrap: true,
        itemCount: _checkboxListTile.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 35.0,
            alignment: Alignment.topCenter,
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                _checkboxListTile[index],
                style: TextStyle(
                    fontFamily: FontStyles().FontFamily, fontSize: 22),
              ),
              value: _checkbox[index],
              onChanged: (value) {
                setState(
                  () {
                    _checkbox[index] = value;
                    print("checkbox");
                    print(_checkbox[index]);
                    if (value) {
                      _select.add(index.toString());
                    } else {
                      _select.remove(index.toString());
                    }
                    print("_select $_select");
                  
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  _showToast(bool _status, String _text) async {
    // this will be our toast UI
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: _status ? Colors.greenAccent : Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_status ? Icons.check : Icons.close),
          SizedBox(
            width: 12.0,
          ),
          Text(
            _text,
            style: TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 22),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 5),
    );
  }
}
