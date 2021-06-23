import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/org/join_detail_screen.dart';
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
  TextEditingController _inputCode = TextEditingController();
  Location location = new Location();
  //---
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanQrcode()),
    );

    setState(() {
      _inputCode.text = result;
    });
  }
  //---

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
                            child: TextFormField(
                              controller: _inputCode,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontFamily: FontStyles().FontFamily,
                                  fontSize: 24),
                              decoration: InputDecoration(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrganizationJoinDetailScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 8, bottom: 8),
                                  decoration: BoxDecoration(
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
}
