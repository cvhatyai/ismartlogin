import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ismart_login/page/front/future/attend_future.dart';
import 'package:ismart_login/page/main.dart';
import 'package:ismart_login/page/outside/future/attend_outside_future.dart';
import 'package:ismart_login/page/outside/model/attendOutsideDescription.dart';
import 'package:ismart_login/page/outside/model/attendOutsideEnd.dart';
import 'package:ismart_login/page/outside/model/attendOutsideStart.dart';
import 'package:ismart_login/page/outside/model/attendOutsideToDay.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/clock.dart';
import 'package:ismart_login/system/widht_device.dart';

class OutsideScreen extends StatefulWidget {
  final double lat;
  final double long;
  final String uid;

  OutsideScreen({
    Key key,
    @required this.lat,
    this.long,
    this.uid,
  }) : super(key: key);
  @override
  _OutsideScreenState createState() => _OutsideScreenState();
}

class _OutsideScreenState extends State<OutsideScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _inputTopic = TextEditingController();
  TextEditingController _inputDescription = TextEditingController();
  //Setup
  PickedFile _imageFile_login;
  dynamic _pickImageError;

  var timeNow = DateTime.now();
  //-----
  bool _login = false;
  bool _logout = false;
  //---
  TextStyle styleLabelCamera =
      TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 26, height: 1);
  TextStyle styleTime = TextStyle(
      fontFamily: FontStyles().FontFamily,
      fontSize: 20,
      height: 1,
      color: Colors.grey);
  //-----
  ////---- MAP
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor pinLocationIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //-----
  mapMark() {
    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(widget.lat, widget.long),
      zoom: 18,
    );
    return _kGooglePlex;
  }

  addMarker(context) {
    ImageConfiguration configuration;
    configuration = createLocalImageConfiguration(context);
    Set<Marker> markers = {};
    markers.add(Marker(
      markerId: MarkerId('Marker_user'),
      position: LatLng(widget.lat, widget.long),
      infoWindow: InfoWindow(title: 'ตำแหน่งคุณ'),
      icon: BitmapDescriptor.defaultMarkerWithHue(200),
    ));
    return markers;
  }

  ///----
  ///

  /// ---- Servere---
  List<ItemsAttandOutsideStartResult> _resultAttandStart = [];
  Future<bool> onLoadAttandOutside() async {
    String dateNow = DateFormat("HH:mm:ss").format(timeNow);
    List note = [
      {"topic": _inputTopic.text, "description": _inputDescription.text}
    ];
    Map map = {
      "uid": widget.uid,
      "cid": '3',
      "latitude": widget.lat.toString(),
      "longitude": widget.long.toString(),
      "time": dateNow,
      "start_note": json.encode(note),
    };
    print(map);
    await AttandOutsideFuture().apiPostAttandOutsideStart(map).then((onValue) {
      print(onValue[0].STATUS);
      print(onValue[0].MSG);
      if (onValue[0].STATUS == 'success') {
        _resultAttandStart = onValue;
        if (_imageFile_login != null) {
          onUploadFiles('i_start');
        }
        EasyLoading.showSuccess('บันทึกแล้ว');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } else {
        EasyLoading.showError('ล้มเหลว');
      }
    });
    return true;
  }

  Future<dynamic> onUploadFiles(String statusFile) async {
    await AttandOutsideFuture().uploadAttendOutside(
      file: File(_imageFile_login.path),
      cmd: 'attend',
      uid: widget.uid,
      uploadKey: _resultAttandStart[0].UPLOADKEY,
      attact_type: statusFile,
    );
    return true;
  }

  ///-----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: StylePage().background,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
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
                  title: Text('ทำงานนอกสถานที่', style: StylesText.titleAppBar),
                  backgroundColor: Colors.white.withOpacity(0),
                  elevation: 0,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 20),
                          width: WidhtDevice().widht(context),
                          decoration: StylePage().boxWhite,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
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
                                  height: 200,
                                  child: GoogleMap(
                                    mapType: MapType.normal,
                                    markers: addMarker(context),
                                    initialCameraPosition: mapMark(),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                  ),
                                ),
                                TextFormField(
                                  controller: _inputTopic,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 22),
                                  decoration: InputDecoration(
                                    hintText: 'เรื่อง',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(
                                          0), // add padding to adjust icon
                                      child: Icon(
                                        Icons.topic_outlined,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณาป้อนข้อความบางอย่าง';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: _inputDescription,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 22),
                                  decoration: InputDecoration(
                                    hintText: 'รายละเอียด',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              60), // add padding to adjust icon
                                      child: Icon(
                                        Icons.description_outlined,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _imageFile_login != null
                                            ? Container(
                                                child: Center(
                                                  child: Container(
                                                    height: 150,
                                                    padding:
                                                        EdgeInsets.only(top: 5),
                                                    child: Image.file(
                                                      File(_imageFile_login
                                                          .path),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  _imgFromCamera_in(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.6),
                                                        spreadRadius: 0,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            6), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.camera_alt),
                                                      Text(
                                                        'ถ่ายรูป',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                FontStyles()
                                                                    .FontFamily,
                                                            fontSize: 22),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            EasyLoading.show();
                                            print('ถัดไป');
                                            onLoadAttandOutside();
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          padding: EdgeInsets.only(
                                              left: 25, right: 25),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF079CFD),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            'ตกลง',
                                            style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                color: Colors.white,
                                                fontSize: 26),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _imgFromCamera_in(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front,
      );
      setState(() {
        _imageFile_login = pickedFile;
      });

      // if (_imageFile != null) {
      //   _getMyLocation();
      // Map _map = {
      //   "uid": _items[0].ID,
      //   "pathImage": pickedFile.path,
      //   "lat": _resultItemDepartment[0].LATITUDE,
      //   "long": _resultItemDepartment[0].LONGTITUDE,
      //   "time": timeIn,
      //   "myLat": _myLat,
      //   "myLng": _myLng,
      // };
      // print(_map);
      //   showDialog(
      //       context: context,
      //       builder: (_) {
      //         return InsiteDialog(
      //           uid: _items[0].ID,
      //           pathImage: pickedFile.path,
      //           lat: _resultItemDepartment[0].LATITUDE,
      //           long: _resultItemDepartment[0].LONGTITUDE,
      //           time: timeIn,
      //           myLat: _myLat,
      //           myLng: _myLng,
      //           radius: double.parse(_resultItemDepartment[0].RADIUS),
      //         );
      //       });
      // }
    } catch (e) {
      setState(() {
        _pickImageError = e;
        print(_pickImageError.toString());
      });
    }
  }
}
