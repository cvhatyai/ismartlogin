import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ismart_login/page/managements/future/member_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:url_launcher/url_launcher.dart';

class LeaveDetailScreen extends StatefulWidget {
  final String id;
  final Function loadListLeave;
  final Function loadData;
  const LeaveDetailScreen({Key key, this.id, this.loadListLeave, this.loadData})
      : super(key: key);
  @override
  _LeaveDetailScreenState createState() => _LeaveDetailScreenState();
}

class _LeaveDetailScreenState extends State<LeaveDetailScreen> {
  List data = [];
  List dataFiles = [];
  List<String> items = <String>['0'];
  List<ItemsMemberResultManage> _itemMember = [];
  List<File> _files = [];
  String cateName = '';
  String subject = '';
  String fullname = '';
  String position = '';
  String leaveDate = '';
  String leaveNum = '';
  String createDate = '';
  String cid = '';
  String leaveStatus = '';
  String uid = '';
  String phone = '';
  String leaveStatusText = '';
  String createBy = '';
  String userclass = '';
  String leave_member = '0';
  final List<Color> colorCodes = <Color>[
    Color(0xFFFDAB28),
    Color(0xFF30BEE3),
    Color(0xFF305AE3)
  ];
  final List<Color> colorTextCodes = <Color>[
    Color(0xFFFF7700),
    Color(0xFF01BB50),
    Color(0xFFFF0000),
    Color(0xFFA0BAC6),
  ];
  TextStyle styleDetail = TextStyle(
      fontFamily: FontStyles().FontFamily,
      fontSize: 18,
      color: Colors.black,
      height: 1);
  TextStyle styleButton = TextStyle(
      fontFamily: FontStyles().FontFamily,
      fontSize: 20,
      color: Colors.blue,
      height: 1);
  TextStyle styleHeader = TextStyle(
      fontFamily: FontStyles().FontFamily,
      fontSize: 25,
      color: Colors.white,
      height: 2);
  TextStyle styleSubHeader = TextStyle(
      fontFamily: FontStyles().FontFamily,
      fontSize: 20,
      color: Colors.black38,
      height: 1);

  void initState() {
    onLoadDetailLeaveManage();
    onLoadMemberManage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.loadData != null) {
      widget.loadData();
    }
  }

  updateStatusLeave(String status) async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
      "id": widget.id,
      "status_leave": status,
    };
    var body = json.encode(map);
    final response = await http.Client().post(
      Uri.parse(Server().postupdateStatusLeave),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    data = json.decode(response.body);
    if (data[0]['status'] == true) {
      onLoadDetailLeaveManage();
      widget.loadListLeave();
    }
    setState(() {});
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  onLoadDetailLeaveManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
      "id": widget.id,
    };
    print("onLoadDetailLeaveManage : ${map}");
    var body = json.encode(map);
    final response = await http.Client().post(
      Uri.parse(Server().getDetailLeave),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    data = json.decode(response.body);
    // print(data);
    if (data[0]['status'] == true) {
      cateName = data[0]['cateName'].toString();
      cid = data[0]['cid'].toString();
      leaveStatus = data[0]['leaveStatus'].toString();
      fullname = data[0]['fullname'].toString();
      subject = data[0]['subject'].toString();
      position = data[0]['position'].toString();
      leaveDate = data[0]['leaveDate'].toString();
      leaveNum = data[0]['leaveNum'].toString();
      createDate = data[0]['createDate'].toString();
      createBy = data[0]['create_by'].toString();
      phone = data[0]['phone'].toString();
      uid = await SharedCashe.getItemsWay(name: 'id');
      leaveStatusText = data[0]['leaveStatusText'].toString();
      dataFiles = data[0]['files'];
    }
    setState(() {});
  }

  Future<bool> onLoadMemberManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    await MemberManageFuture().apiGetMemberManageList(map).then((onValue) {
      setState(() {
        if (onValue[0].STATUS) {
          _itemMember = onValue[0].RESULT;
          userclass = _itemMember[0].MEMBER_TYPE.toString();
          leave_member = _itemMember[0].LEAVE_MEMBER.toString();
        }
      });
    });
    setState(() {});
    return true;
  }

  alert_confirm(BuildContext context, String text, String status) async {
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
                  padding:
                      EdgeInsets.only(top: 30, bottom: 30, left: 3, right: 3),
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: TextStyle(
                        fontFamily: FontStyles().FontFamily, fontSize: 24),
                    textAlign: TextAlign.center,
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
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'ยกเลิก',
                              style: TextStyle(
                                  fontFamily: FontStyles().FontFamily,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            updateStatusLeave(status);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF00B9FF),
                              borderRadius: BorderRadius.only(
                                // bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'ยืนยัน',
                              style: TextStyle(
                                  fontFamily: FontStyles().FontFamily,
                                  color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Color(0xFF00B1FF),
                      title: Text(
                        'รายละเอียดการลา',
                        style: TextStyle(
                            fontFamily: FontStyles().FontFamily,
                            fontSize: 28,
                            color: Colors.white,
                            // height: 1,
                            fontWeight: FontWeight.bold),
                      ),
                      elevation: 0,
                    ),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: [
                                        Image(
                                            image: AssetImage(
                                                "assets/images/other/bg2.png")),
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(26.0)),
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(3,
                                                        0), // changes position of shadow
                                                  ),
                                                ]),
                                            child:
                                                (data != null &&
                                                        data.length > 0)
                                                    ? Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          //type
                                                          Container(
                                                            height: 47,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: colorCodes[cid ==
                                                                              "1"
                                                                          ? 0
                                                                          : cid == "2"
                                                                              ? 1
                                                                              : 2],
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(26.0),
                                                                        bottomRight:
                                                                            Radius.circular(20.0),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        cateName,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 20),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          //detail
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              child: Container(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text("ชื่อ – สกุล", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8E8E8E))),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(fullname, style: TextStyle(fontSize: 20, color: Color(0xFF8E8E8E))),
                                                                            )
                                                                          ],
                                                                        )),
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text("ตำแหน่ง", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8E8E8E))),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(position, style: TextStyle(fontSize: 20, color: Color(0xFF8E8E8E))),
                                                                            )
                                                                          ],
                                                                        )),
                                                                    Container(
                                                                        child:
                                                                            Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Text(
                                                                              "เนื่องจาก",
                                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8E8E8E))),
                                                                        ),
                                                                        Expanded(
                                                                          child: Text(
                                                                              subject,
                                                                              style: TextStyle(fontSize: 20, color: Color(0xFF8E8E8E))),
                                                                        )
                                                                      ],
                                                                    )),
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text("ลาวันที่", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8E8E8E))),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(leaveDate, style: TextStyle(fontSize: 20, color: Color(0xFF8E8E8E))),
                                                                            )
                                                                          ],
                                                                        )),
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text("รวม", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8E8E8E))),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(leaveNum, style: TextStyle(fontSize: 20, color: Color(0xFF8E8E8E))),
                                                                            )
                                                                          ],
                                                                        )),
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text("ส่งใบลา", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8E8E8E))),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(createDate, style: TextStyle(fontSize: 20, color: Color(0xFF8E8E8E))),
                                                                            )
                                                                          ],
                                                                        )),
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text("เบอร์ที่ติดต่อได้", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8E8E8E))),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(phone, style: TextStyle(fontSize: 20, color: Color(0xFF8E8E8E))),
                                                                            )
                                                                          ],
                                                                        )),
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text("สถานะคำขอลา", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8E8E8E))),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(leaveStatusText, style: TextStyle(fontSize: 20, color: colorTextCodes[int.parse(leaveStatus) - 1])),
                                                                            )
                                                                          ],
                                                                        )),
                                                                    if (dataFiles !=
                                                                            null &&
                                                                        dataFiles.length >
                                                                            0)
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(bottom: 10),
                                                                          child:
                                                                              Container(
                                                                            child: Text("เอกสารแนบ",
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8E8E8E))),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if (dataFiles !=
                                                                            null &&
                                                                        dataFiles.length >
                                                                            0)
                                                                      for (var i =
                                                                              0;
                                                                          i < dataFiles.length;
                                                                          i++)
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _launchInBrowser(dataFiles[i]['path']);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.only(bottom: 10),
                                                                              child: Text(
                                                                                "- " + dataFiles[i]['filename'].toString(),
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Color(0xFF8E8E8E),
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

                                                          //button
                                                          Container(
                                                            height: dataFiles !=
                                                                        null &&
                                                                    dataFiles
                                                                            .length >
                                                                        0
                                                                ? 65
                                                                : 120,
                                                            child: (data !=
                                                                        null &&
                                                                    data.length >
                                                                        0)
                                                                ? Column(
                                                                    children: [
                                                                      //ยกเลิก
                                                                      if ((createBy == uid) &&
                                                                          (leaveStatus !=
                                                                              "3") &&
                                                                          (leaveStatus !=
                                                                              "4") &&
                                                                          (leaveStatus !=
                                                                              "2"))
                                                                        Container(
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              alert_confirm(context, "คุณต้องการ “ยกเลิก” การลาหรือไม่", "4");
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                color: Color(0xFFBBBBBB),
                                                                                borderRadius: BorderRadius.circular(26),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'ยกเลิก',
                                                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      if ((createBy ==
                                                                              uid) &&
                                                                          (leaveStatus ==
                                                                              "2"))
                                                                        Container(
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              alert_confirm(context, "คุณต้องการ “ยกเลิก” การลาหรือไม่", "4");
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                color: Color(0xFFBBBBBB),
                                                                                borderRadius: BorderRadius.circular(26),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'ยกเลิก',
                                                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      // อนุมัติ //ไม่อนุมัติิ
                                                                      if ((createBy != uid) &&
                                                                          (leaveStatus !=
                                                                              "3") &&
                                                                          (leaveStatus !=
                                                                              "2") &&
                                                                          (leaveStatus !=
                                                                              "4") &&
                                                                          (userclass == "admin" ||
                                                                              leave_member == "1"))
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 16.0,
                                                                              right: 16.0),
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      alert_confirm(context, "คุณต้องการ “ไม่อนุมัติ” การลาหรือไม่", "3");
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: Color(0xFFBBBBBB),
                                                                                        borderRadius: BorderRadius.circular(26),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'ไม่อนุมัติ',
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 8),
                                                                                Expanded(
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      alert_confirm(context, "คุณต้องการ “อนุมัติ” การลาหรือไม่", "2");
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: Color(0xFF00B9FF),
                                                                                        borderRadius: BorderRadius.circular(26),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'อนุมัติ',
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  )
                                                                : null,
                                                          ),
                                                        ],
                                                      )
                                                    : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
