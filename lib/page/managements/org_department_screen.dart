import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/managements/future/department_manage_future.dart';
import 'package:ismart_login/page/managements/future/time_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemDepartmentResultManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultDayManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultMange.dart';
import 'package:ismart_login/page/managements/org_departmentdetail_screen.dart';
import 'package:ismart_login/page/managements/org_timedatail_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:location/location.dart';

class OrgDepartmentManage extends StatefulWidget {
  final String org_id;
  OrgDepartmentManage({Key key, @required this.org_id}) : super(key: key);
  @override
  _OrgDepartmentManageState createState() => _OrgDepartmentManageState();
}

class _OrgDepartmentManageState extends State<OrgDepartmentManage> {
  ///----
  double latMain = 0.0;
  double logMain = 0.0;
  Location _location = new Location();
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

  ///----  / GET -----
  List<ItemsDepartmentResultManage> _resultItem = [];
  Future<bool> onLoadGetAllDepartment() async {
    Map map = {
      "org_id": widget.org_id,
    };
    print(map);
    await DepartManageFuture().apiGetDepartmentManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        setState(() {
          _resultItem = onValue[0].RESULT;
        });
      }
    });
    EasyLoading.dismiss();
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoadGetAllDepartment();
    _getLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: StylePage().background,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
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
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        actions: [
                          // action button
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrgDepartmentDetailManage(
                                    id: '0',
                                    org_id: widget.org_id,
                                    type: 'insert',
                                    lat: latMain,
                                    lng: logMain,
                                  ),
                                ),
                              ).then((value) {
                                value ? onLoadGetAllDepartment() : null;
                              });
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
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: WidhtDevice().widht(context),
                          child: ListView.builder(
                            itemCount: _resultItem.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  EasyLoading.show();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OrgDepartmentDetailManage(
                                        id: _resultItem[index].ID,
                                        org_id: widget.org_id,
                                        type: 'update',
                                        lat: double.parse(
                                            _resultItem[index].LATITUDE),
                                        lng: double.parse(
                                            _resultItem[index].LONGTITUDE),
                                      ),
                                    ),
                                  ).then((value) {
                                    value ? onLoadGetAllDepartment() : null;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10, top: 5),
                                  width: WidhtDevice().widht(context),
                                  decoration: StylePage().boxWhite,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(padding: EdgeInsets.all(2)),
                                          FaIcon(
                                            FontAwesomeIcons.streetView,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          Padding(padding: EdgeInsets.all(1)),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 3, right: 3),
                                              child: Text(
                                                _resultItem[index].SUBJECT,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 24,
                                                  height: 1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.all(4)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.gps_fixed,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          _resultItem[index]
                                                                  .LATITUDE
                                                                  .substring(
                                                                      0, 7) +
                                                              ' ,' +
                                                              _resultItem[index]
                                                                  .LONGTITUDE
                                                                  .substring(
                                                                      0, 7),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FontStyles()
                                                                    .FontFamily,
                                                            fontSize: 18,
                                                            height: 1,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                Container(
                                                  child: Text(
                                                    '10',
                                                    style: TextStyle(
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
                                                      fontSize: 18,
                                                      height: 1,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
