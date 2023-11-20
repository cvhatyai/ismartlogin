import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ismart_login/page/managements/future/department_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemDepartmentManage.dart';
import 'package:ismart_login/page/managements/model/itemDepartmentResultManage.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:location/location.dart';
import 'package:place_picker/place_picker.dart';

import 'future/time_manage_future.dart';
import 'model/itemTimeResultMange.dart';
import 'org_timedatail_screen.dart';

class OrgDepartmentDetailManage extends StatefulWidget {
  final String id;
  final String seq;
  final String org_id;
  final String type;
  final double lat;
  final double lng;
  final String noti;
  final Function refresh;

  OrgDepartmentDetailManage(
      {Key key,
      @required this.id,
      this.org_id,
      this.type,
      this.lat,
      this.lng,
      this.seq,
      this.refresh,
      this.noti})
      : super(key: key);

  @override
  _OrgDepartmentDetailManageState createState() =>
      _OrgDepartmentDetailManageState();
}

class _OrgDepartmentDetailManageState extends State<OrgDepartmentDetailManage> {
  final _formKey = GlobalKey<FormState>();
  Location _location = new Location();
  double latMain = 0.0;
  double logMain = 0.0;
  StreamSubscription<LocationData> locationSubscription;
  _getLocation() {
    locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      // if (latMain != 0.0 && logMain != 0.0) {
      setState(() {
        latMain = currentLocation.latitude.toDouble();
        logMain = currentLocation.longitude.toDouble();
      });
      // }
    });
  }

//-------
  TextEditingController _inputSubject = TextEditingController();
  TextEditingController _inputLat = TextEditingController();
  TextEditingController _inputLng = TextEditingController();
  TextEditingController _inputDegree = TextEditingController();
  TextEditingController _seq = TextEditingController();
  FocusNode _focusDegree = FocusNode();

  ///----
  bool _editLatlng = false;

  ///---- INSER/UPDATE -----
  _setDetailDepartmentToJson() async {
    EasyLoading.show();
    Map map = {
      "subject": _inputSubject.text,
      "org_id": widget.org_id != ''
          ? widget.org_id
          : await SharedCashe.getItemsWay(name: 'org_id'),
      "status": "1",
      "latitude": _inputLat.text,
      "longitude": _inputLng.text,
      "radius": _inputDegree.text,
      "id": widget.id,
      "type": widget.type,
      "time_id": dropdownValueTime,
    };
    print(json.encode(map).toString());
    // EasyLoading.showError('ล้มเหลว');
    onLoadPostDepartmet(map);
  }

  _insertSeq(String seq, String id) async {
    Map _map = {};
    _map.addAll({
      "id": id,
      "seq": seq,
    });
    print("_map : $_map");
    var body = json.encode(_map);
    final response = await http.Client().post(
      Uri.parse(Server().updateSeqOrg),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    var data = json.decode(response.body);
    print('insertSeq : $data');
    if (data != null) {
      if (data[0]['msg'].toString() == "success") {
        print('onLoadGetAllDepartment reload');
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }
    }
  }

  List<ItemsDepartmentManagePostUpdate> _result = [];
  Future<bool> onLoadPostDepartmet(Map map) async {
    await DepartManageFuture().apiPostDepartmentManageList(map).then((onValue) {
      print(onValue[0].STATUS);
      print(onValue[0].MSG);
      if (onValue[0].STATUS == true) {
        EasyLoading.showSuccess('บันทึกแล้ว');
        Navigator.pop(context, true);
      } else {
        EasyLoading.showError('ล้มเหลว');
      }
    });
    return true;
  }

  ///----  / GET -----
  List<ItemsDepartmentResultManage> _resultItem = [];
  Future<bool> onLoadGetDepartment() async {
    Map map = {"org_id": widget.org_id, "id": widget.id};
    print("onLoadGetDepartment ${map}");
    await DepartManageFuture().apiGetDepartmentManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        setState(() {
          _resultItem = onValue[0].RESULT;
        });
      }
    });
    _setShowValue();
    EasyLoading.dismiss();
    return true;
  }

  _setShowValue() {
    setState(() {
      _inputSubject.text = _resultItem[0].SUBJECT;
      _inputLat.text = _resultItem[0].LATITUDE;
      _inputLng.text = _resultItem[0].LONGTITUDE;
      _inputDegree.text = _resultItem[0].RADIUS;
      latMain = widget.lat;
      logMain = widget.lng;
    });
  }

  //แผนที่
  Completer<GoogleMapController> _controller = Completer();
  Future<void> showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              //PlacePicker("AIzaSyC_toS4JYdMubnqCRVg7mbJk4t6nvkRUlY")),
              PlacePicker(
                "AIzaSyB91yhHGMRWDgLYajpg8ACtG5Dl1YUFFEw",
                displayLocation: LatLng(latMain, logMain),
              )),
    );
    // Handle the result in your way
    if (result == null) {
      return;
    }
    final cameraPosition = CameraPosition(
      target: LatLng(result.latLng.latitude, result.latLng.longitude),
      zoom: 18,
    );
    final GoogleMapController controller = await _controller.future;
    await controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setMarker(lat: result.latLng.latitude, log: result.latLng.longitude);
  }

  ///---- GPS
  mapMark() {
    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(latMain, logMain),
      zoom: 18,
    );
    return _kGooglePlex;
  }

  setMarker({double lat, double log}) {
    setState(() {
      latMain = lat;
      logMain = log;
      _inputLat.text = latMain.toString();
      _inputLng.text = logMain.toString();
    });
  }

  addMarker() {
    Set<Marker> markers = {};
    markers.add(Marker(
      markerId: MarkerId('Marker_user'),
      position: LatLng(latMain, logMain),
      infoWindow: InfoWindow(title: 'ตำแหน่งที่ต้องการ'),
      icon: BitmapDescriptor.defaultMarkerWithHue(0),
    ));
    return markers;
  }

  String dropdownValueTime = '0';
  List<ItemsTimeResultManage> _itemTime = [];
  Future<bool> onLoadGetAllTime() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
    };
    await TimeManageFuture().apiGetTimeManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        setState(() {
          _itemTime = onValue[0].RESULT;
          if (_resultItem != null && _resultItem.length > 0) {
            if (_resultItem[0].TIME_ID != '') {
              dropdownValueTime = _resultItem[0].TIME_ID;
            } else {
              dropdownValueTime = _itemTime[0].ID;
            }
          } else {
            dropdownValueTime = _itemTime[0].ID;
          }
          print("onloadTime : ${dropdownValueTime}");
        });
      }
    });
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    _inputDegree.text = '200';
    EasyLoading.dismiss();
    super.initState();
    setMarker(lat: widget.lat, log: widget.lng);
    if (widget.type == 'update') {
      onLoadGetDepartment();
    } else {
      // _getLocation();
    }
    //noti
    if (widget.noti != null) {
      if (widget.noti == "0") {
        _switchNoti = false;
      } else {
        _switchNoti = true;
      }
    }
    onLoadGetAllTime();
  }

  bool _switchNoti = true;

  _updateNotiStatus(String status, String id) async {
    Map _map = {};
    _map.addAll({
      "id": id,
      "noti_status": status,
    });
    print("_map : $_map");
    var body = json.encode(_map);
    final response = await http.Client().post(
      Uri.parse(Server().updateNotiStatus),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    var data = json.decode(response.body);
    print('insertSeq : $data');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // locationSubscription.cancel();
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
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
              // physics: const NeverScrollableScrollPhysics(),
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
                      actions: [
                        // action button
                        /*IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrgDepartmentDetailManage(
                                  id: '0',
                                  org_id: widget.org_id,
                                  type: 'insert',
                                  lat: widget.lat,
                                  lng: widget.lng,
                                ),
                              ),
                            );
                          },
                        ),*/
                      ],
                      title: Text(
                        'สาขา',
                        style: StylesText.titleAppBar,
                      ),
                      backgroundColor: Colors.white.withOpacity(0),
                      elevation: 0,
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 20),
                          width: WidhtDevice().widht(context),
                          decoration: StylePage().boxWhite,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _inputSubject,
                                  // focusNode: _focusSubject,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 24),
                                  decoration: InputDecoration(
                                    hintText: 'ชื่อสาขา',
                                    hintStyle: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 24),
                                    /*prefixIcon: Padding(
                                      padding: EdgeInsets.all(
                                          0), // add padding to adjust icon
                                      child: Icon(
                                        Icons.work,
                                        size: 26,
                                      ),
                                    ),*/
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'รัศมีในการล็อกอิน',
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      width: 120,
                                      child: TextFormField(
                                        controller: _inputDegree,
                                        focusNode: _focusDegree,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 24),
                                        decoration: InputDecoration(
                                          hintText: 'ควรมากกว่า 50',
                                          hintStyle: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              fontSize: 20),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Icon(
                                              Icons.room,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'เมตร',
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                if (widget.type == 'update')
                                  Row(children: [
                                    Container(
                                      child: Text(
                                        'เรียง :',
                                        style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 24,
                                          height: 1,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 35,
                                      child: TextFormField(
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        controller:
                                            TextEditingController.fromValue(
                                          TextEditingValue(
                                            text: _seq.text != ''
                                                ? _seq.text
                                                : '${widget.seq}',
                                            selection:
                                                TextSelection.fromPosition(
                                              TextPosition(
                                                  affinity:
                                                      TextAffinity.downstream,
                                                  offset:
                                                      '${widget.seq}'.length),
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 24),
                                        onChanged: (text) {
                                          if (text.toString() != "") {
                                            _seq.text = text;
                                            _insertSeq(text.toString(),
                                                widget.id.toString());
                                          }
                                        },
                                      ),
                                    ),
                                  ]),

                                Padding(
                                  padding: EdgeInsets.all(5),
                                ),

                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'กำหนดเวลาทำงาน : ',
                                        style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 24,
                                          height: 1,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 120,
                                      child: DropdownButton(
                                        value: dropdownValueTime,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.grey,
                                        ),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 24,
                                          height: 1,
                                          color: Colors.black,
                                        ),
                                        isExpanded: true,
                                        underline: Container(
                                          height: 2,
                                          color: Colors.blue,
                                        ),
                                        onChanged: (newValue) {
                                          setState(() {
                                            dropdownValueTime = newValue;
                                          });
                                          print('id time ' + dropdownValueTime);
                                        },
                                        items: _itemTime.length == 0
                                            ? <String>['0']
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                return DropdownMenuItem(
                                                  child: Text('- เลือก -'),
                                                  value: value,
                                                );
                                              }).toList()
                                            : _itemTime.map((map) {
                                                return DropdownMenuItem(
                                                  child: Text(map.SUBJECT,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  value: map.ID,
                                                );
                                              }).toList(),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_formKey.currentState.validate()) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrgTimeDetailManage(
                                                id: '0',
                                                org_id: widget.org_id,
                                                type: 'insert',
                                                updateLoadTime:
                                                    onLoadGetAllTime,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF079CFD),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Text(
                                          'เพิ่ม',
                                          style: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              color: Colors.white,
                                              fontSize: 24),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: EdgeInsets.all(5),
                                ),

                                Row(children: [
                                  Container(
                                    child: Text(
                                      'การแจ้งเตือนก่อนเข้างาน 5 นาที : ',
                                      style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 24,
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  FlutterSwitch(
                                    value: _switchNoti ? true : false,
                                    width: 60.0,
                                    height: 30.0,
                                    valueFontSize: 13.0,
                                    toggleSize: 30.0,
                                    borderRadius: 20.0,
                                    padding: 2.0,
                                    showOnOff: true,
                                    activeText: '',
                                    activeColor: Colors.green,
                                    inactiveText: '',
                                    inactiveColor: Colors.grey,
                                    onToggle: (state) {
                                      setState(() {
                                        _switchNoti = state;
                                        if (_switchNoti) {
                                          var status = "1";
                                          _updateNotiStatus(status.toString(),
                                              widget.id.toString());
                                        } else {
                                          var status = "0";
                                          _updateNotiStatus(status.toString(),
                                              widget.id.toString());
                                        }
                                      });
                                    },
                                  ),
                                ]),

                                Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            'แตะเพื่อเลือกที่ตั้งสาขา',
                                            style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                color: Colors.blue,
                                                fontSize: 24,
                                                height: 1),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 120,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Color(0xFFFF841B)),
                                          ),
                                          onPressed: () {
                                            showPlacePicker();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.location_pin),
                                                Container(
                                                  child: Text(
                                                    "คันหา",
                                                    style: TextStyle(
                                                        fontFamily: FontStyles()
                                                            .FontFamily,
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        height: 1),
                                                  ),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                ),
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
                                  child: GoogleMap(
                                      markers: addMarker(),
                                      initialCameraPosition: mapMark(),
                                      zoomGesturesEnabled: true,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                      // all the other arguments
                                      onTap: (latLng) {
                                        setMarker(
                                            lat: latLng.latitude,
                                            log: latLng.longitude);
                                        print(
                                            '${latLng.latitude}, ${latLng.longitude}');
                                      }),
                                ),
                                // Container(
                                //   alignment: Alignment.center,
                                //   child: Text(
                                //     '* แตะในตำแน่งที่ต้องการ',
                                //     style: TextStyle(
                                //         fontFamily: FontStyles().FontFamily,
                                //         color: Colors.grey,
                                //         fontSize: 18,
                                //         height: 1),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.all(5),
                                // ),
                                Visibility(
                                  visible: _editLatlng,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.gps_fixed,
                                                size: 20,
                                                color: Colors.blue,
                                              ),
                                              Text(
                                                ' ละติจูด,ลองติจูด',
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontStyles().FontFamily,
                                                    color: Colors.blue,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        _editLatlng
                                            ? GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _editLatlng = false;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 2, right: 3),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.blue,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.done,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      Text(
                                                        'ตกลง',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FontStyles()
                                                                    .FontFamily,
                                                            fontSize: 18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _editLatlng = true;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 2, right: 2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.grey,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      Text(
                                                        'กำหนดเอง',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                FontStyles()
                                                                    .FontFamily,
                                                            fontSize: 18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _editLatlng,
                                  child: Container(
                                    color: _editLatlng
                                        ? Colors.white
                                        : Colors.grey[100],
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          enabled: _editLatlng,
                                          controller: _inputLat,
                                          // focusNode: _focusUsername,
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              fontSize: 24),
                                          decoration: InputDecoration(
                                            hintText: 'ละติจูด',
                                            hintStyle: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                fontSize: 24),
                                          ),
                                        ),
                                        TextFormField(
                                          enabled: _editLatlng,
                                          controller: _inputLng,
                                          // focusNode: _focusUsername,
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              fontSize: 24),
                                          decoration: InputDecoration(
                                            hintText: 'ลองติจูด',
                                            hintStyle: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                fontSize: 24),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.all(5),
                                // ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                Visibility(
                                  visible: _editLatlng ? false : true,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _setDetailDepartmentToJson();
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 25, right: 25),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF079CFD),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            'บันทึก',
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
