import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/contact_dev/contactdev_screen.dart';
import 'package:ismart_login/page/faq/faq_screen.dart';
import 'package:ismart_login/page/front/future/relationship_future.dart';
import 'package:ismart_login/page/front/model/itemMemberRelationship.dart';
import 'package:ismart_login/page/front/model/itemMemberResultRelationship.dart';
import 'package:ismart_login/page/managements/future/department_manage_future.dart';
import 'package:ismart_login/page/managements/future/time_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemDepartmentResultManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultMange.dart';
import 'package:ismart_login/page/managements/org_department_screen.dart';
import 'package:ismart_login/page/managements/org_departmentdetail_screen.dart';
import 'package:ismart_login/page/managements/org_holiday_screen.dart';
import 'package:ismart_login/page/managements/org_member_screen.dart';
import 'package:ismart_login/page/managements/org_screen.dart';
import 'package:ismart_login/page/managements/org_time_screen.dart';
import 'package:ismart_login/page/managements/org_timedatail_screen.dart';
import 'package:ismart_login/page/org/create_screen.dart';
import 'package:ismart_login/page/profile/profile_screen.dart';
import 'package:ismart_login/page/profile/vacation_screen.dart';
import 'package:ismart_login/page/sign/signout_popup.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:package_info/package_info.dart';

class MenuDrawer extends StatefulWidget {
  final String images;
  final String fullname;
  final String org;
  final String org_sub;
  final String org_id;
  final String type_member;
  MenuDrawer({
    Key key,
    @required this.images,
    this.fullname,
    this.org,
    this.org_sub,
    this.org_id,
    this.type_member,
  }) : super(key: key);
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  Location _location = new Location();
  TextStyle _txt = TextStyle(
    fontFamily: FontStyles().FontFamily,
    fontSize: 22,
  );
//----
  String _org_id = '';

  ///----
  double latMain = 0.0;
  double logMain = 0.0;
  StreamSubscription<LocationData> locationSubscription;
  _getLocation() {
    locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        latMain = currentLocation.latitude.toDouble();
        logMain = currentLocation.longitude.toDouble();
      });
    });
  }

  //----------------------
  List<ItemsTimeResultManage> _resultCount = [];
  Future<bool> onLoadCountTime() async {
    Map _timeMap = {"org_id": await SharedCashe.getItemsWay(name: 'org_id')};
    await TimeManageFuture().apiGetTimeManageList(_timeMap).then((onValue) {
      setState(() {
        _resultCount = onValue[0].RESULT;
      });
    });
    print(_resultCount.length);
    return true;
  }

  //----------------------
  //----------------------
  List<ItemsDepartmentResultManage> _resultDepartCount = [];
  Future<bool> onLoadCountDepartment() async {
    Map _timeMap = {"org_id": widget.org_id};
    await DepartManageFuture()
        .apiGetDepartmentManageList(_timeMap)
        .then((onValue) {
      setState(() {
        _resultDepartCount = onValue[0].RESULT;
      });
    });
    print("Department : " + _resultDepartCount.length.toString());
    return true;
  }

  //----------------------
  List<ItemsMemberResultRelationship> _resultRelation = [];
  Future<bool> onLoadRelation() async {
    Map _timeMap = {"uid": await SharedCashe.getItemsWay(name: 'id')};
    await MemberRelationshipFuture()
        .apiGetMemberRelationshipList(_timeMap)
        .then((onValue) {
      setState(() {
        _resultRelation = onValue[0].RESULT;
      });
    });
    return true;
  }

  //----------------------
  String _version = '0.0.0';
  _checkVer() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    onLoadCountTime();
    onLoadCountDepartment();
    onLoadRelation();
    _checkVer();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Row(
                children: [
                  widget.images == ''
                      ? Container(
                          alignment: Alignment.center,
                          width: 70,
                          height: 70,
                          decoration: new BoxDecoration(
                            color: Color(0xFFF2F2F2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 0), // changes position of shadow
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
                          alignment: Alignment.centerLeft,
                          width: 70,
                          height: 70,
                          decoration: new BoxDecoration(
                            color: Color(0xFFF2F2F2),
                            image: DecorationImage(
                              image: NetworkImage(Server.url + widget.images),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.fullname,
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      height: 1),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.org,
                                  style: TextStyle(
                                    fontFamily: FontStyles().FontFamily,
                                    fontSize: 24,
                                    height: 1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.org_sub,
                                  style: TextStyle(
                                    fontFamily: FontStyles().FontFamily,
                                    fontSize: 12,
                                    color: Colors.black54,
                                    height: 1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            decoration: StylePage().background,
          ),
          ListTile(
            minLeadingWidth: 0.5,
            leading: FaIcon(
              FontAwesomeIcons.userAlt,
              size: 20,
            ),
            title: Text(
              'ข้อมูลส่วนตัว',
              style: _txt,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            minLeadingWidth: 0.5,
            leading: FaIcon(
              FontAwesomeIcons.userAlt,
              size: 20,
            ),
            title: Text(
              'ลา',
              style: _txt,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VacationScreen(),
                ),
              );
            },
          ),
          Visibility(
            visible: widget.type_member == 'member' ? false : true,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(), //here is a divider
                  Text(
                    " Administrator",
                    style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                          minLeadingWidth: 0.5,
                          leading: FaIcon(
                            FontAwesomeIcons.building,
                            size: 20,
                          ),
                          title: Text(
                            'จัดการองค์กร',
                            style: _txt,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrgManageScreen(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          minLeadingWidth: 0.5,
                          leading: FaIcon(
                            FontAwesomeIcons.userFriends,
                            size: 20,
                          ),
                          title: Text(
                            'สมาชิก',
                            style: _txt,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            EasyLoading.show();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrgMemberScreen(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          minLeadingWidth: 0.5,
                          leading: FaIcon(
                            FontAwesomeIcons.streetView,
                            size: 20,
                          ),
                          title: Text(
                            'สาขา',
                            style: _txt,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            if (_resultDepartCount.length > 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrgDepartmentManage(
                                      org_id: widget.org_id),
                                ),
                              );
                            } else {
                              EasyLoading.show();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrgDepartmentDetailManage(
                                    id: _resultDepartCount.length == 1
                                        ? _resultDepartCount[0].ID
                                        : '0',
                                    org_id: widget.org_id,
                                    type: _resultDepartCount.length == 1
                                        ? 'update'
                                        : 'insert',
                                    lat: _resultDepartCount.length == 1
                                        ? double.parse(
                                            _resultDepartCount[0].LATITUDE)
                                        : latMain,
                                    lng: _resultDepartCount.length == 1
                                        ? double.parse(
                                            _resultDepartCount[0].LONGTITUDE)
                                        : logMain,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        ListTile(
                          minLeadingWidth: 0.5,
                          leading: FaIcon(
                            FontAwesomeIcons.businessTime,
                            size: 20,
                          ),
                          title: Text(
                            'เวลาทำงาน',
                            style: _txt,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            if (_resultCount.length > 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrgTimeManage(
                                    org_id: widget.org_id,
                                  ),
                                ),
                              );
                            } else {
                              EasyLoading.show();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrgTimeDetailManage(
                                    id: _resultCount.length == 1
                                        ? _resultCount[0].ID
                                        : '0',
                                    org_id: widget.org_id,
                                    type: _resultCount.length == 1
                                        ? 'update'
                                        : 'insert',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        // ListTile(
                        //   minLeadingWidth: 0.5,
                        //   leading: FaIcon(
                        //     FontAwesomeIcons.solidCalendarTimes,
                        //     size: 20,
                        //   ),
                        //   title: Text(
                        //     'วันหยุด',
                        //     style: _txt,
                        //   ),
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => OrgHolidayManage(),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Divider(), //here is a divider
          Padding(padding: EdgeInsets.all(5)),
          Text(
            " อื่น ๆ",
            style: TextStyle(
                fontFamily: FontStyles().FontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  minLeadingWidth: 0.5,
                  leading: FaIcon(
                    FontAwesomeIcons.question,
                    size: 20,
                  ),
                  title: Text(
                    'คำถามที่พบบ่อย',
                    style: _txt,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Faq(),
                      ),
                    );
                  },
                ),
                ListTile(
                  minLeadingWidth: 0.5,
                  leading: FaIcon(
                    FontAwesomeIcons.code,
                    size: 20,
                  ),
                  title: Text(
                    'ติดต่อผู้พัฒนา',
                    style: _txt,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactDeveloper(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(), //here is a divider
          Padding(padding: EdgeInsets.all(5)),
          ListTile(
            minLeadingWidth: 0.5,
            leading: FaIcon(
              FontAwesomeIcons.signOutAlt,
              size: 20,
            ),
            title: Text(
              'ออกจากระบบ',
              style: _txt,
            ),
            onTap: () {
              Navigator.pop(context);
              alert_signout(context);
            },
          ),
          Divider(), //here is a divider
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: [
                Text(
                  'iSmartLogin  V.' + _version,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontStyles().FontFamily,
                    fontSize: 12,
                    color: Colors.grey[400],
                    height: 1,
                    // color: Colors.white,
                  ),
                ),
                Text(
                  "Copyright© Powered by CityVariety Corporation.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontStyles().FontFamily,
                    fontSize: 12,
                    color: Colors.grey[400], height: 1,
                    // color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }
}
