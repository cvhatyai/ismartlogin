import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ismart_login/page/managements/future/department_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemDepartmentManage.dart';
import 'package:ismart_login/page/managements/model/itemDepartmentResultManage.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:location/location.dart';

class OrgDepartmentDetailManage extends StatefulWidget {
  final String id;
  final String org_id;
  final String type;
  final double lat;
  final double lng;

  OrgDepartmentDetailManage(
      {Key key, @required this.id, this.org_id, this.type, this.lat, this.lng})
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
//-------
  TextEditingController _inputSubject = TextEditingController();
  TextEditingController _inputLat = TextEditingController();
  TextEditingController _inputLng = TextEditingController();
  TextEditingController _inputDegree = TextEditingController();
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
    };
    print(json.encode(map).toString());
    // EasyLoading.showError('ล้มเหลว');
    onLoadPostDepartmet(map);
  }

  List<ItemsDepartmentManagePostUpdate> _result = [];
  Future<bool> onLoadPostDepartmet(Map map) async {
    await DepartManageFuture().apiPostDepartmentManageList(map).then((onValue) {
      print(onValue[0].STATUS);
      print(onValue[0].MSG);
      if (onValue[0].STATUS == true) {
        EasyLoading.showSuccess('บันทึกแล้ว');
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
    print(map);
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

  @override
  void initState() {
    // TODO: implement initState
    _inputDegree.text = '200';
    super.initState();
    setMarker(lat: widget.lat, log: widget.lng);
    if (widget.type == 'update') {
      onLoadGetDepartment();
    }
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
                      IconButton(
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
                      ),
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
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(
                                        0), // add padding to adjust icon
                                    child: Icon(
                                      Icons.work,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ตำแหน่งที่ตั้งองค์กร',
                                      style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          color: Colors.blue,
                                          fontSize: 24,
                                          height: 1),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 300,
                                child: GoogleMap(
                                    markers: addMarker(),
                                    initialCameraPosition: mapMark(),
                                    // all the other arguments
                                    onTap: (latLng) {
                                      setMarker(
                                          lat: latLng.latitude,
                                          log: latLng.longitude);

                                      print(
                                          '${latLng.latitude}, ${latLng.longitude}');
                                    }),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '* แตะในตำแน่งที่ต้องการ',
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      color: Colors.grey,
                                      fontSize: 18,
                                      height: 1),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
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
                                                      BorderRadius.circular(10),
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
                                                      BorderRadius.circular(10),
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
                                            fontFamily: FontStyles().FontFamily,
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
                                            fontFamily: FontStyles().FontFamily,
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
                              Padding(
                                padding: EdgeInsets.all(5),
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
                                  Expanded(
                                    child: Container(
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
                                        if (_formKey.currentState.validate()) {
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
    );
  }
}
