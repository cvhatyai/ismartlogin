import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ismart_login/page/front/drawer.dart';
import 'package:ismart_login/page/front/front_count_widget.dart';
import 'package:ismart_login/page/front/future/attend_future.dart';
import 'package:ismart_login/page/front/future/org_future.dart';
import 'package:ismart_login/page/front/history_day_widget.dart';
import 'package:ismart_login/page/front/insite_popup.dart';
import 'package:ismart_login/page/front/model/attendToDay.dart';
import 'package:ismart_login/page/front/model/orglist.dart';
import 'package:ismart_login/page/front/offside_popup.dart';
import 'package:ismart_login/page/main.dart';
import 'package:ismart_login/page/managements/future/department_manage_future.dart';
import 'package:ismart_login/page/managements/future/member_manage_future.dart';
import 'package:ismart_login/page/managements/future/time_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemDepartmentResultManage.dart';
import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultDayManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultMange.dart';
import 'package:ismart_login/page/outside/outside_screen.dart';
import 'package:ismart_login/page/sign/model/memberlist.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/clock.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrontScreen extends StatefulWidget {
  @override
  _FrontScreenState createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  TextEditingController _inputNote = TextEditingController();

  //---
  Location location = new Location();
  StreamSubscription<LocationData> locationSubscription;
  double _myLat = 0.0;
  double _myLng = 0.0;
  //--
  Timer _timer;
  Timer _date;
  Timer _re;
  String _time_id;
  //---
  List<ItemsMemberList> _items = [];
  String _dateString;
  String _timeString;
  //----
  String org_id;
  bool dayWorking = false;
  bool affiliate = false;
  String timeIn = '';
  String timeOut = '';
  //Setup
  PickedFile _imageFile;
  dynamic _pickImageError;
  //-----
  bool _login = false;
  bool _logout = false;
  //-----
  TextStyle styleTime = TextStyle(
      fontFamily: FontStyles().FontFamily, fontSize: 22, color: Colors.white);
  TextStyle styleLabelCamera = TextStyle(
      fontFamily: FontStyles().FontFamily,
      fontSize: 26,
      fontWeight: FontWeight.bold,
      height: 1);
  TextStyle styleDetailCamera = TextStyle(
      fontFamily: FontStyles().FontFamily,
      fontSize: 18,
      color: Color(0xFF8D8B8B),
      height: 1);
  //-----
  var map;

  @override
  void initState() {
    onLoadMemberManage();
    _getMyLocation();
    _getShaerd();
    _timeString = _formatTime(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _dateString = _formatDate(DateTime.now());
    _date = Timer.periodic(Duration(seconds: 1), (Timer t) => _getDate());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _date.cancel();
    super.dispose();
    locationSubscription.cancel();
  }

  _getMyLocation() {
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _myLat = currentLocation.latitude.toDouble();
        _myLng = currentLocation.longitude.toDouble();
      });
      // dispose();
    });
  }

  // --- Post Data Member
  List<ItemsOrgList> _resultOrg = [];
  Future<bool> onLoadSelectOrganization(Map map) async {
    await OrgFuture().apiGetOrganization(map).then((onValue) {
      print(onValue[0].MSG);
      if (onValue[0].MSG == 'success') {
        _resultOrg = onValue[0].RESULT;
        onLoadAttend();
      }
    });
    setState(() {});
    return true;
  }

  // --- Post Data Member
  List<ItemsAttandToDay> _resultAttand = [];
  Future<bool> onLoadAttend() async {
    Map map = {
      "uid": _items.length > 0 ? _items[0].ID : '',
      "time_id": await SharedCashe.getItemsWay(name: 'time_id') != ""
          ? await SharedCashe.getItemsWay(name: 'time_id')
          : _items[0].TIME_ID
    };
    print("apiGetAttandCheck $_itemMember");
    print("apiGetAttandCheck : $map");
    await AttandFuture().apiGetAttandCheck(map).then((onValue) {
      print("apiGetAttandCheck ${onValue[0].STATUS}");
      if (onValue[0].STATUS != 'success') {
        setState(() {
          _login = true;
          _logout = false;
        });
      } else {
        setState(() {
          _resultAttand = onValue;
          if (_resultAttand[0].END_TIME == null && !_login) {
            _logout = true;
          } else {
            _logout = false;
          }
        });
      }
      print("apiGetAttandCheck _login : $_login");
      print("apiGetAttandCheck _logout : $_logout");
    });
    setState(() {});
    return true;
  }

  List<ItemsMemberResultManage> _itemMember = [];
  Future<bool> onLoadMemberManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    await MemberManageFuture().apiGetMemberManageList(map).then((onValue) {
      setState(() {
        if (onValue[0].STATUS) {
          _itemMember = onValue[0].RESULT;
          _time_id = _itemMember[0].TIME_ID;
          print("onLoadMemberManage ${_itemMember[0].ORG_SUB_ID}");
          print("onLoadMemberManage ${_itemMember[0].TIME_ID}");
          if (_itemMember[0].ORG_SUB_ID != '' && _itemMember[0].TIME_ID != '') {
            onLoadGetDepartment(_itemMember[0].ORG_SUB_ID);
            onLoadGetTime(_itemMember[0].TIME_ID);
            affiliate = true;
          } else {
            affiliate = false;
          }
          print("onLoadMemberManage $affiliate");
        }
      });
    });
    setState(() {});
    return true;
  }

  ///----  / GET -----
  List<ItemsTimeResultManage> _resultItem = [];
  List<ItemsTimeResultDayManage> _resultItemDay = [];
  Future<bool> onLoadGetTime(String time_id) async {
    var today = DateTime.now();
    _resultItemDay.clear();
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "id": time_id,
    };
    print("apiGetTimeManageList :$map");
    await TimeManageFuture().apiGetTimeManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        _resultItem = onValue[0].RESULT;
        print(_resultItem.length);
        _resultItemDay = List.from(json
            .decode(_resultItem[0].DESCRIPTION)
            .map((m) => ItemsTimeResultDayManage.fromJson(m)));
      }
      print('count day ' + _resultItemDay.length.toString());
      print('to day ' + today.weekday.toString());

      for (int i = 0; i < _resultItemDay.length; i++) {
        if ((today.weekday - 1).toString() ==
            _resultItemDay[i].DAY.toString()) {
          setState(() {
            dayWorking = true;
            timeIn = _resultItemDay[i].TIME_START;
            timeOut = _resultItemDay[i].TIME_END;
          });
        }
      }
      print("apiGetTimeManageList :$dayWorking");
    });
    return true;
  }

  List<ItemsDepartmentResultManage> _resultItemDepartment = [];
  Future<bool> onLoadGetDepartment(String org_sub_id) async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "id": org_sub_id
    };
    print(map);
    await DepartManageFuture().apiGetDepartmentManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        setState(() {
          _resultItemDepartment = onValue[0].RESULT;
        });
      }
    });
    return true;
  }

  ///------

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  void _getDate() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDate(now);
    List date = formattedDateTime.split("-");
    String day = date[0];
    String month = Clock().thMonth[int.parse(date[1])];
    String year = (int.parse(date[2]) + 543).toString();
    String display = day + ' ' + month + ' ' + year;
    setState(() {
      _dateString = display;
    });
  }

  _getShaerd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String item = prefs.getString('item');
    _items =
        List.from(json.decode(item).map((m) => ItemsMemberList.fromJson(m)));
    if (_items.length > 0) {
      setState(() {
        org_id = _items[0].ORG_ID;
      });
      Map _map = {"ID": _items[0].ORG_ID != '' ? _items[0].ORG_ID : ''};
      onLoadSelectOrganization(_map);
    }
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('d-M-y').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuDrawer(
          images: _itemMember.length > 0 ? _itemMember[0].AVATAR : '',
          fullname: _itemMember.length > 0
              ? _itemMember[0].NICKNAME == '' || _itemMember[0].NICKNAME == null
                  ? _subFullname(_itemMember[0].FULLNAME)
                  : _itemMember[0].NICKNAME
              : '',
          org: _itemMember.length > 0 ? _itemMember[0].ORG_NAME : '',
          org_sub: _itemMember.length > 0
              ? _itemMember[0].ORG_SUB_NAME == '' ||
                      _itemMember[0].ORG_SUB_NAME == null
                  ? ''
                  : _itemMember[0].ORG_SUB_NAME
              : '',
          org_id: org_id,
          type_member:
              _itemMember.length > 0 ? _itemMember[0].MEMBER_TYPE : 'member'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: StylePage().background,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20),
                    width: WidhtDevice().widht(context),
                    decoration: StylePage().boxWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        child: _itemMember.length > 0
                                            ? _itemMember[0].AVATAR != ''
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: 15),
                                                    alignment: Alignment.center,
                                                    width: 60,
                                                    height: 60,
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Color(0xFFF2F2F2),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            Server.url +
                                                                _itemMember[0]
                                                                    .AVATAR),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 2,
                                                          blurRadius: 5,
                                                          offset: Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        top: 15),
                                                    alignment: Alignment.center,
                                                    width: 60,
                                                    height: 60,
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Color(0xFFF2F2F2),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 2,
                                                          blurRadius: 5,
                                                          offset: Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                      size: 50,
                                                    ),
                                                  )
                                            : Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                alignment: Alignment.center,
                                                width: 60,
                                                height: 60,
                                                decoration: new BoxDecoration(
                                                  color: Color(0xFFF2F2F2),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0,
                                                          0), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                              ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.only(left: 10, top: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    _itemMember.length > 0
                                                        ? _itemMember[0].NICKNAME ==
                                                                    '' ||
                                                                _itemMember[0]
                                                                        .NICKNAME ==
                                                                    null
                                                            ? _subFullname(
                                                                _itemMember[0]
                                                                    .FULLNAME)
                                                            : _itemMember[0]
                                                                .NICKNAME
                                                        : '',
                                                    style: TextStyle(
                                                        fontFamily: FontStyles()
                                                            .FontFamily,
                                                        fontSize: 28,
                                                        height: 1,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    _itemMember.length > 0
                                                        ? _itemMember[0]
                                                            .ORG_NAME
                                                        : '',
                                                    style: TextStyle(
                                                        fontFamily: FontStyles()
                                                            .FontFamily,
                                                        fontSize: 22,
                                                        height: 1,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    _itemMember.length > 0
                                                        ? _itemMember[0].ORG_SUB_NAME ==
                                                                    '' ||
                                                                _itemMember[0]
                                                                        .ORG_SUB_NAME ==
                                                                    null
                                                            ? ''
                                                            : _itemMember[0]
                                                                .ORG_SUB_NAME
                                                        : '',
                                                    style: TextStyle(
                                                        fontFamily: FontStyles()
                                                            .FontFamily,
                                                        fontSize: 10,
                                                        height: 1,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal),
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
                              GestureDetector(
                                onTap: () {
                                  _scaffoldKey.currentState.openDrawer();
                                  // Scaffold.of(context).openDrawer();
                                  // alert_signout(context);
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.menu,
                                    size: 26,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 25, right: 25),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF398EFD),
                                          Color(0xFFFFA2C2),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.repeated),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        _dateString,
                                        style: styleTime,
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              _timeString + ' น. ',
                                              style: styleTime,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainPage(),
                                                  ),
                                                );
                                              },
                                              child: FaIcon(
                                                FontAwesomeIcons.sync,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FrontCountWidget(),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  _timeString.toString(),
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 70,
                                      height: 0.5),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Text(
                                  _dateString,
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 26,
                                      height: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        affiliate
                            ? dayWorking
                                ? Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (_login) {
                                                _imgFromCamera_in(context);
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey[400],
                                                    width: 1,
                                                  ),
                                                  right: BorderSide(
                                                    color: Colors.grey[400],
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    width: 120,
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                        color: !_login
                                                            ? Colors.grey[100]
                                                            : Color(0xFFD6F5FF),
                                                        shape: BoxShape.circle),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: !_login
                                                              ? Colors.grey[300]
                                                              : Color(
                                                                  0xFFA7E9FF),
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: !_login
                                                                ? Colors
                                                                    .grey[400]
                                                                : Color(
                                                                    0xFF36C8FF),
                                                            shape: BoxShape
                                                                .circle),
                                                        child: Icon(
                                                          Icons.camera_alt,
                                                          size: 50,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'เข้างาน',
                                                    style: styleLabelCamera,
                                                  ),
                                                  Text(
                                                    'ถ่ายรูปคุณคู่กับสถานที่',
                                                    style: styleDetailCamera,
                                                  ),
                                                  Text(
                                                    'เวลาเข้างาน ' +
                                                        Clock().convertTime(
                                                            time: dayWorking
                                                                ? timeIn
                                                                : '--:--') +
                                                        ' น.',
                                                    style: styleDetailCamera,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (_logout) {
                                                _imgFromCamera_out(context);
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) => CameraCustom(),
                                                //   ),
                                                // );
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey[400],
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    width: 120,
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                        color: !_logout
                                                            ? Colors.grey[100]
                                                            : Color(0xFFFFEDCE),
                                                        shape: BoxShape.circle),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: !_logout
                                                              ? Colors.grey[300]
                                                              : Color(
                                                                  0xFFFAD7A0),
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: !_logout
                                                                ? Colors
                                                                    .grey[400]
                                                                : Color(
                                                                    0xFFFFAF36),
                                                            shape: BoxShape
                                                                .circle),
                                                        child: Icon(
                                                          Icons.camera_alt,
                                                          size: 50,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'ออกงาน',
                                                    style: styleLabelCamera,
                                                  ),
                                                  Text(
                                                    'ถ่ายรูปคุณคู่กับสถานที่',
                                                    style: styleDetailCamera,
                                                  ),
                                                  Text(
                                                    'เวลาออกงาน ' +
                                                        Clock().convertTime(
                                                            time: dayWorking
                                                                ? timeOut
                                                                : '--:--') +
                                                        ' น.',
                                                    style: styleDetailCamera,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 100,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            '-- วันหยุด --',
                                            style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                fontSize: 26,
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                            : Container(
                                height: 150,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "--\n กรุณาแก้ไขข้อมูลส่วนตัว \nเลือก 'สาขา' และ 'เวลาทำงาน' \n--",
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 24,
                                            color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        Padding(padding: EdgeInsets.all(5)),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'รายการที่บันทึก',
                                style: TextStyle(
                                    fontFamily: FontStyles().FontFamily,
                                    fontSize: 24,
                                    height: 1,
                                    fontWeight: FontWeight.bold),
                              ),
                              HistoryDayWidget(),
                            ],
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
      floatingActionButton: Container(
        width: 100,
        height: 100,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OutsideScreen(
                      uid: _itemMember[0].ID,
                      lat: _myLat,
                      long: _myLng,
                    ),
                  ),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5)
                  ],
                ),
                child: CircleAvatar(
                    backgroundColor: Color(0xFFB907BD),
                    child: FaIcon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                      size: 30,
                    )),
              ),
            ),
            Padding(padding: EdgeInsets.all(1)),
            Text(
              'ทำงานนอกสถานที่',
              style:
                  TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 14),
            )
          ],
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
        _imageFile = pickedFile;
      });
      _getMyLocation();
      Map _map = {
        "uid": _items[0].ID,
        "pathImage": pickedFile.path,
        "lat": _resultItemDepartment[0].LATITUDE,
        "long": _resultItemDepartment[0].LONGTITUDE,
        "time": timeIn,
        "myLat": _myLat,
        "myLng": _myLng,
      };
      print(_map);
      if (_imageFile != null) {
        showDialog(
            context: context,
            builder: (_) {
              return InsiteDialog(
                uid: _items[0].ID,
                pathImage: pickedFile.path,
                lat: _resultItemDepartment[0].LATITUDE,
                long: _resultItemDepartment[0].LONGTITUDE,
                time: timeIn,
                myLat: _myLat,
                myLng: _myLng,
                timeId: _time_id,
                radius: double.parse(_resultItemDepartment[0].RADIUS),
              );
            });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
        print(_pickImageError.toString());
      });
    }
  }

  _imgFromCamera_out(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front,
      );
      setState(() {
        _imageFile = pickedFile;
      });
      if (_imageFile != null) {
        showDialog(
            context: context,
            builder: (_) {
              return OffsideDialog(
                uid: _items[0].ID,
                pathImage: pickedFile.path,
                lat: _resultItemDepartment[0].LATITUDE,
                long: _resultItemDepartment[0].LONGTITUDE,
                time: timeOut,
                myLat: _myLat,
                myLng: _myLng,
                timeId: _time_id,
                radius: double.parse(_resultItemDepartment[0].RADIUS),
              );
            });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
        print(_pickImageError.toString());
      });
    }
  }

  _subFullname(String fullname) {
    String name = '';
    List list = fullname.split(",");
    name = list[0];
    if (list.length > 1) {
      name += ' ' + list[1];
    }
    return name;
  }
}
