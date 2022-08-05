import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
import 'package:ismart_login/server/server.dart';
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
  final List<FocusNode> _focusNodes = [];
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
        onLoadGetAllDepartment();
      }
    }
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
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
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
                            GestureDetector(
                              onTap: () {
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
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 20.0),
                                child: Container(
                                  child: Text(
                                    'เพิ่ม',
                                    style: StylesText.titleAppBar,
                                  ),
                                ),
                              ),
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
                            // width: WidhtDevice().widht(context),
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: _resultItem.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    EasyLoading.show();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            OrgDepartmentDetailManage(
                                          id: _resultItem[index].ID,
                                          seq: _resultItem[index].SEQ,
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
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                        top: 5),
                                    // width: WidhtDevice().widht(context),
                                    width: MediaQuery.of(context).size.width,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                            // Container(
                                            //   child: Text(
                                            //     'เรียง :',
                                            //     style: TextStyle(
                                            //       fontFamily:
                                            //           FontStyles().FontFamily,
                                            //       fontSize: 24,
                                            //       height: 1,
                                            //       color: Colors.black,
                                            //     ),
                                            //   ),
                                            // ),
                                            // Container(
                                            //   width: 50,
                                            //   height: 35,
                                            //   child: TextFormField(
                                            //     // focusNode: _focusNodes[index],
                                            //     // focusNode: _focusDegree,
                                            //     maxLines: 1,
                                            //     textAlign: TextAlign.center,
                                            //     controller:
                                            //         TextEditingController
                                            //             .fromValue(
                                            //       TextEditingValue(
                                            //         text:
                                            //             '${_resultItem[index].SEQ}',
                                            //         selection: TextSelection
                                            //             .fromPosition(
                                            //           TextPosition(
                                            //               affinity: TextAffinity
                                            //                   .downstream,
                                            //               offset:
                                            //                   '${_resultItem[index].SEQ}'
                                            //                       .length),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     keyboardType:
                                            //         TextInputType.number,
                                            //     style: TextStyle(
                                            //         fontFamily:
                                            //             FontStyles().FontFamily,
                                            //         fontSize: 24),
                                            //     onChanged: (text) => {
                                            //       if (text.toString() != "")
                                            //         {
                                            //           _insertSeq(
                                            //               text.toString(),
                                            //               _resultItem[index]
                                            //                   .ID
                                            //                   .toString())
                                            //         }
                                            //     },
                                            //   ),
                                            // ),
                                          
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
                                                                _resultItem[
                                                                        index]
                                                                    .LONGTITUDE
                                                                    .substring(
                                                                        0, 7),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FontStyles()
                                                                      .FontFamily,
                                                              fontSize: 18,
                                                              height: 1,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Container(
                                            //   child: Row(
                                            //     children: [
                                            //       Icon(
                                            //         Icons.person,
                                            //         size: 16,
                                            //         color: Colors.grey,
                                            //       ),
                                            //       Container(
                                            //         child: Text(
                                            //           '10',
                                            //           style: TextStyle(
                                            //             fontFamily: FontStyles()
                                            //                 .FontFamily,
                                            //             fontSize: 18,
                                            //             height: 1,
                                            //             color: Colors.grey,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
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
      ),
    );
  }
}
