import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/org/future/getJoinOrg_future.dart';
import 'package:ismart_login/page/org/join_detail_screen.dart';
import 'package:ismart_login/page/org/model/getorglist.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/scan_qr.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:location/location.dart';

class OrganizationJoinScreen extends StatefulWidget {
  @override
  _OrganizationJoinScreenState createState() => _OrganizationJoinScreenState();
}

class _OrganizationJoinScreenState extends State<OrganizationJoinScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _inputCode = TextEditingController();
  Location location = new Location();
  //----
  String _receiveKey = "";
  bool _btn = false;
  //---
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    _receiveKey = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RScanCameraDialog()),
    );

    setState(() {
      _inputCode.text = _receiveKey;
      if (_inputCode.text.length == 9) {
        EasyLoading.show();
        onLoadSelectOrganization(_inputCode.text);
      }
    });
  }
  //---

  // --- Post Data Member
  List<ItemsGetOrgList> _resultOrg = [];
  Future<bool> onLoadSelectOrganization(String codeKey) async {
    Map map = {"INVITE_CODE": codeKey};
    await GetOrgFuture().apiGetOrganization(map).then((onValue) {
      print("=========> " + onValue[0].MSG);
      if (onValue[0].MSG == 'success') {
        _resultOrg = onValue[0].RESULT;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationJoinDetailScreen(
              itemsGetOrgList: _resultOrg[0],
            ),
          ),
        );
      } else {
        EasyLoading.dismiss();
        alert_null(context, "ไม่พบทีม/องค์กร\nรหัสเชิญ " + codeKey);
      }
    });
    setState(() {});
    return true;
  }

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
              padding: EdgeInsets.only(left: 20, right: 20),
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
                    title: Text(
                      'เข้าร่วมทีม',
                      style: TextStyle(
                          fontFamily: FontStyles().FontFamily,
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                    backgroundColor: Colors.white.withOpacity(0),
                    elevation: 0,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 20),
                      width: WidhtDevice().widht(context),
                      decoration: StylePage().boxWhite,
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _inputCode,
                              maxLength: 9,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontFamily: FontStyles().FontFamily,
                                  fontSize: 24),
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: 'รหัสทีม 9 หลัก',
                                hintStyle: TextStyle(
                                    fontFamily: FontStyles().FontFamily,
                                    fontSize: 24),
                                suffixIcon: kIsWeb
                                    ? Container(
                                        width: 0,
                                        height: 0,
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          _navigateAndDisplaySelection(context);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            child: Image.asset(
                                              'assets/images/other/qrcode-scan.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                              onChanged: (val) {
                                if (val.length != 9) {
                                  setState(() {
                                    _btn = false;
                                  });
                                } else {
                                  setState(() {
                                    _btn = true;
                                  });
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _navigateAndDisplaySelection(context);
                                },
                                child: Text(
                                  kIsWeb ? '' : 'แสกนคิวอาร์โค้ด',
                                  style: TextStyle(
                                    fontFamily: FontStyles().FontThaiSans,
                                    fontSize: 20,
                                    color: Color(0xFF6093B8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_inputCode.text.length == 9) {
                                    EasyLoading.show();
                                    onLoadSelectOrganization(_inputCode.text);
                                    // _inputCode.text = "";
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 8, bottom: 8),
                                  decoration: _btn
                                      ? BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                          gradient: LinearGradient(
                                              colors: [
                                                Color(0xFF0093E9),
                                                Color(0xFF36C2CF),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              stops: [0.0, 1.0],
                                              tileMode: TileMode.clamp),
                                        )
                                      : BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                          color: Colors.grey,
                                        ),
                                  child: Text(
                                    'เข้าร่วมทีม',
                                    style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                height: 200,
                                child:
                                    Image.asset('assets/images/other/join.png'),
                              )
                            ],
                          )
                          // Container(
                          //   padding: EdgeInsets.only(left: 30, right: 30),
                          //   height: 200,
                          //   child:
                          //       Image.asset('assets/images/other/org_select.png'),
                          // ),
                          // GestureDetector(
                          //   child: Card(
                          //     shadowColor: Color(0xFFE8E8E8),
                          //     elevation: 3.0,
                          //     shape: RoundedRectangleBorder(
                          //       side: BorderSide(width: 0.1),
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child: Container(
                          //       padding: EdgeInsets.all(10),
                          //       child: Row(
                          //         children: [
                          //           Expanded(
                          //             child: Container(
                          //               child: Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   RichText(
                          //                     text: TextSpan(
                          //                       style: Theme.of(context)
                          //                           .textTheme
                          //                           .body1
                          //                           .copyWith(
                          //                               fontSize: 40,
                          //                               fontFamily: FontStyles()
                          //                                   .FontFamily,
                          //                               fontWeight:
                          //                                   FontWeight.bold),
                          //                       children: [
                          //                         TextSpan(
                          //                           text: 'เข้าร่วม',
                          //                           style: TextStyle(
                          //                             color: Color(0xFF0799E5),
                          //                           ),
                          //                         ),
                          //                         TextSpan(
                          //                           text: 'ทีม/องค์กร',
                          //                           style: TextStyle(
                          //                             color: Color(0xFF6B6B6B),
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                   Container(
                          //                     padding: EdgeInsets.only(right: 10),
                          //                     child: Text(
                          //                       'เข้าร่วมทีมที่เพื่อนคุณสร้างไว้แล้ว โดยถาม ID องค์กร/ทีม กับเพื่อนของคุณ',
                          //                       style: TextStyle(
                          //                           color: Color(0xFF6B6B6B),
                          //                           fontFamily:
                          //                               FontStyles().FontFamily,
                          //                           fontSize: 22,
                          //                           height: 1),
                          //                     ),
                          //                   )
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //           Icon(
                          //             Icons.arrow_forward_ios,
                          //             color: Colors.blue,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Padding(padding: EdgeInsets.all(5)),
                          // GestureDetector(
                          //   child: Card(
                          //     shadowColor: Color(0xFFE8E8E8),
                          //     elevation: 3.0,
                          //     shape: RoundedRectangleBorder(
                          //       side: BorderSide(width: 0.1),
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child: Container(
                          //       padding: EdgeInsets.all(10),
                          //       child: Row(
                          //         children: [
                          //           Expanded(
                          //             child: Container(
                          //               child: Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   RichText(
                          //                     text: TextSpan(
                          //                       style: Theme.of(context)
                          //                           .textTheme
                          //                           .body1
                          //                           .copyWith(
                          //                               fontSize: 40,
                          //                               fontFamily: FontStyles()
                          //                                   .FontFamily,
                          //                               fontWeight:
                          //                                   FontWeight.bold),
                          //                       children: [
                          //                         TextSpan(
                          //                           text: 'สร้าง',
                          //                           style: TextStyle(
                          //                             color: Color(0xFFFF6600),
                          //                           ),
                          //                         ),
                          //                         TextSpan(
                          //                           text: 'ทีม/องค์กรใหม่',
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                   Container(
                          //                     padding: EdgeInsets.only(right: 10),
                          //                     child: Text(
                          //                       'แล้วชวนทีมงานมาเข้าร่วม',
                          //                       style: TextStyle(
                          //                           color: Color(0xFF6B6B6B),
                          //                           fontFamily:
                          //                               FontStyles().FontFamily,
                          //                           fontSize: 22,
                          //                           height: 1),
                          //                     ),
                          //                   )
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //           Icon(
                          //             Icons.arrow_forward_ios,
                          //             color: Colors.blue,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
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

  alert_null(BuildContext context, String text) async {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Container(
            width: WidhtDevice().widht(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1,
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'ปิด',
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
            ),
          ),
        );
      },
    );
  }
}
