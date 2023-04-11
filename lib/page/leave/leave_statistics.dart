import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ismart_login/page/leave/confirm_leave.dart';
import 'package:ismart_login/page/managements/future/member_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';
import 'package:ismart_login/page/managements/org_member_screen.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:http/http.dart' as http;

import 'leave_detail.dart';
import 'leave_filter.dart';
import 'leave_statistics_dateil.dart';

class LeaveStatisticsScreen extends StatefulWidget {
  @override
  _LeaveStatisticsScreenState createState() => _LeaveStatisticsScreenState();
}

class _LeaveStatisticsScreenState extends State<LeaveStatisticsScreen> {
  List data = [];
  List statusData = [];
  List typesData = [];
  List<int> _daySelect = [];
  DateTime FirstDate = DateTime.now();
  DateTime LastDate = DateTime.now();
  bool select1 = true;
  bool select2 = false;
  bool select3 = false;

  List<String> items = <String>['0'];
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
  List<String> itemsTime = <String>[
    '0.5',
    '1',
    '1.5',
    '2',
    '2.5',
    '3',
    '3.5',
    '4',
    '4.5',
    '5',
    '5.5',
    '6',
    '6.5',
    '7',
    '7.5',
    '8'
  ];
  String selectItem = '1';
  String selectItemTime = '1';
  String sick = '0';
  String leave = '0';
  String other = '0';
  int _selectFullTime = 1;

  TextEditingController _inputCause = TextEditingController();
  TextEditingController inputPhone = TextEditingController();
  List<ItemsMemberResultManage> _itemMember = [];
  List<File> _files = [];

  List<bool> _groupDay = [
    true,
  ];

  TimeOfDay _timeOfDay = TimeOfDay.now();

  List<TextEditingController> _inputTimeIn = [
    TextEditingController(),
  ];

  List<TextEditingController> _inputTimeOut = [
    TextEditingController(),
  ];

  // final difference = LastDate.difference(FirstDate).inDays;
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

  Future<bool> insertInfoLeave() async {
    String inputCause = _inputCause.text;

    print(inputCause);
    Map map = {
      "uid": await SharedCashe.getItemsWay(name: 'id'),
      'cause': inputCause,
    };
    var body = json.encode(map);
    print(body);

    final http.Response response = await http.post(
      Uri.parse(Server().insertInfoLeave),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "*"
      },
      body: body,
    );
    if (response.statusCode != 200) {
      return false;
    }
    if (response.statusCode == 200) {
      print('yehhhhh');
    }
    print(response);
    final data = json.decode(response.body);
    print(data);
    return data['status'] == 'success';
  }

  void initState() {
    onLoadListLeaveManage();
    onLoadMemberManage();
    super.initState();
  }

  String dropdownValueStartMonth = "เลือกเดือน";
  String dropdownValueStartYear = "เลือกปี";
  String dropdownValueEndMonth = "เลือกเดือน";
  String dropdownValueEndYear = "เลือกปี";

  onSetDataFilter(List status, List types, String monthStart, String yearStart,
      String monthEnd, String yearEnd) async {
    if (status != null && status.length > 0) {
      statusData = status;
    }
    if (types != null && types.length > 0) {
      typesData = types;
    }

    if (monthStart != null && monthStart != "") {
      dropdownValueStartMonth = monthStart;
    } else {
      dropdownValueStartMonth = "เลือกเดือน";
    }

    if (yearStart != null && yearStart != "") {
      dropdownValueStartYear = yearStart;
    } else {
      dropdownValueStartYear = "เลือกปี";
    }

    if (monthEnd != null && monthEnd != "") {
      dropdownValueEndMonth = monthEnd;
    } else {
      dropdownValueEndMonth = "เลือกเดือน";
    }

    if (yearEnd != null && yearEnd != "") {
      dropdownValueEndYear = yearEnd;
    } else {
      dropdownValueEndYear = "เลือกปี";
    }

    onLoadListLeaveManage();
    print("status : $status");
    print("types : $types");
  }

  onLoadListLeaveManage() async {
    String statusLeave = '';
    String typesLeave = '';
    if (statusData != null && statusData.length > 0) {
      statusLeave = statusData.join(',');
    }
    if (typesData != null && typesData.length > 0) {
      typesLeave = typesData.join(',');
    }
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
      "status_leave": statusLeave,
      "cid": typesLeave,
      "month_start": dropdownValueStartMonth != "เลือกเดือน"
          ? dropdownValueStartMonth
          : "",
      "year_start":
          dropdownValueStartYear != "เลือกปี" ? dropdownValueStartYear : "",
      "month_end":
          dropdownValueEndMonth != "เลือกเดือน" ? dropdownValueEndMonth : "",
      "year_end": dropdownValueEndYear != "เลือกปี" ? dropdownValueEndYear : "",
    };
    var body = json.encode(map);
    final response = await http.Client().post(
      Uri.parse(Server().getListLeave),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    data = json.decode(response.body);
    print(data);
    if (data[0]['status'] == true) {
      sick = data[0]['sick'].toString();
      leave = data[0]['leave'].toString();
      other = data[0]['other'].toString();
    } else {
      data = [];
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
        }
      });
    });
    setState(() {});
    return true;
  }

  popup_comfirm(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return ConfirmDialog(
            select1: select1,
            select2: select2,
            select3: select3,
            FirstDate: '${FirstDate.day}/${FirstDate.month}/${FirstDate.year}',
            LastDate: '${LastDate.day}/${LastDate.month}/${LastDate.year}',
            numDate: selectItem,
            phoneNum: inputPhone.text,
            selectFulltime: _selectFullTime.toString(),
            firstTime: _inputTimeIn[0].text,
            lastTime: _inputTimeOut[0].text,
            // uid: SharedCashe.getItemsWay(name: 'id'),
            cause: _inputCause.text,
            fullName: _itemMember[0].FULLNAME,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round() + 1;
    }

    final difference = daysBetween(FirstDate, LastDate);
    // log('difference: $difference');
    for (var i = 0; i <= difference; i++) {
      if (items.every((item) => item != '${i}')) {
        items.add('${i - 0.5}');
        items.add('${i}');
      }
    }
    // log('data: $items');

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    final values = formattedDate.split('-');
    final yearCurr = int.parse(values[0]) + 543;

    List rs = [];
    if (data.length > 0) {
      rs = data[0]['result'];
    }

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
                      'สถิติการลา',
                      style: TextStyle(
                          fontFamily: FontStyles().FontFamily,
                          fontSize: 28,
                          color: Colors.white,
                          height: 1,
                          fontWeight: FontWeight.bold),
                    ),
                    elevation: 0,
                  ),
                  Container(
                    color: Color(0xFF01b4fa),
                    child: Center(
                      child: Text(
                        'สถิติการลาสะสมปี ${yearCurr.toString()}',
                        style: TextStyle(
                            fontFamily: FontStyles().FontFamily,
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Align(
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
                                        height: 180,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFF9C04),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/images/other/injured.svg", //asset location
                                                            height:
                                                                double.infinity,
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Text(
                                                              "ลาป่วย",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              sick,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 40,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF5AD1E9),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0)),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 24.0,
                                                                right: 24.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          6.0),
                                                                  child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "assets/images/other/exit.svg", //asset location
                                                                      color: Colors
                                                                          .white,
                                                                      width: double
                                                                          .infinity,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0,
                                                                        bottom:
                                                                            8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          30,
                                                                      child:
                                                                          Text(
                                                                        "ลากิจ",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                18,
                                                                            height:
                                                                                1.8),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        leave,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              40,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                                                  SizedBox(height: 5),
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF305AE3),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0)),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 24.0,
                                                                right: 24.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          6.0),
                                                                  child: Center(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "assets/images/other/travel.svg", //asset location
                                                                      color: Colors
                                                                          .white,
                                                                      width: double
                                                                          .infinity,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0,
                                                                        bottom:
                                                                            8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          30,
                                                                      child:
                                                                          Text(
                                                                        "อื่นๆ",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                18,
                                                                            height:
                                                                                1.8),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        other,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              40,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 24, right: 24),
                              child: GestureDetector(
                                onTap: () {
                                  print("ตรวจสอบสิทธิ");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LeaveStatisticsDetailScreen(
                                        sick: sick,
                                        leave: leave,
                                        other: other,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "ตรวจสอบสิทธิ >",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Color(0xFF8F8C8C), fontSize: 17),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 24, right: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "ประวัติลางาน",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(0xFF616161),
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        print("ตัวกรอง");
                                        showModalBottomSheet(
                                          elevation: 0.0,
                                          backgroundColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(10.0),
                                                topRight: const Radius.circular(
                                                    10.0)),
                                          ),
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (BuildContext bc) {
                                            return Container(
                                              child: Wrap(
                                                alignment: WrapAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    height: 390,
                                                    child: LeaveFilterScreen(
                                                      statusDataTmp: statusData,
                                                      typesDataTmp: typesData,
                                                      setDataFilterLeaveData:
                                                          onSetDataFilter,
                                                      dropdownValueStartMonthTmp:
                                                          dropdownValueStartMonth,
                                                      dropdownValueStartYearTmp:
                                                          dropdownValueStartYear,
                                                      dropdownValueEndMonthTmp:
                                                          dropdownValueEndMonth,
                                                      dropdownValueEndYearTmp:
                                                          dropdownValueEndYear,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "ตัวกรอง",
                                              style: TextStyle(
                                                  color: Color(0xFF8F8C8C),
                                                  fontSize: 17,
                                                  height: 1),
                                            ),
                                            Icon(Icons.tune_outlined),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, right: 18, top: 4),
                                child: Container(
                                  child: data.length > 0
                                      ? ListView.builder(
                                          padding: EdgeInsets.all(8),
                                          itemCount: rs.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LeaveDetailScreen(
                                                      id: rs[index]['id']
                                                          .toString(),
                                                      loadListLeave:
                                                          onLoadListLeaveManage,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 8),
                                                height: 70,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                26.0)),
                                                    border: Border.all(
                                                      color: Color(0xFF8F8C8C),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 0,
                                                        blurRadius: 7,
                                                        offset: Offset(3,
                                                            0), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      26.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      26.0),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 100,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: colorCodes[rs[index]
                                                                              [
                                                                              'cid'] ==
                                                                          "1"
                                                                      ? 0
                                                                      : rs[index]['cid'] ==
                                                                              "2"
                                                                          ? 1
                                                                          : 2],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            26.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    rs[index][
                                                                            'cate_name']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(
                                                                    rs[index][
                                                                            'dateLeave']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF008FFF),
                                                                        fontSize:
                                                                            15),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 40,
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .navigate_next_outlined,
                                                                    color: Color(
                                                                        0xFFa0bac6),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      26.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          26.0),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20),
                                                                  child: Text(
                                                                    "ส่งใบลา " +
                                                                        rs[index]['create_date']
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF858585),
                                                                        fontSize:
                                                                            13),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    right: 20,
                                                                  ),
                                                                  child: Text(
                                                                    rs[index][
                                                                            'status_leave_text']
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style: TextStyle(
                                                                        color: colorTextCodes[
                                                                            int.parse(rs[index]['status_leave']) -
                                                                                1],
                                                                        fontSize:
                                                                            15),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
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
                                            );
                                          })
                                      : Container(
                                          margin: EdgeInsets.only(top: 40),
                                          child: Text(
                                            "- ไม่มีข้อมูล - ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF616161),
                                                fontSize: 20),
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
                ],
              ),
            ),
          ),
        ),
      ),
    )

        // body: Container(
        //   width: MediaQuery.of(context).size.width,
        //   decoration: StylePage().background,
        //   child: SafeArea(
        //     child: Container(
        //       padding: EdgeInsets.only(left: 20, right: 20),
        //       width: MediaQuery.of(context).size.width,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: [
        //           SingleChildScrollView(
        //             child: Container(
        //               padding: EdgeInsets.only(
        //                   left: 5, right: 5, top: 10, bottom: 20),
        //               width: WidhtDevice().widht(context),
        //               decoration: StylePage().boxWhite,
        //               // child: DevelopBlank.show(),
        //             ),
        //           ),
        //         ],
        //       ),

        //     ),
        //   ),
        );
  }

  Widget _fileView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _files.length,
      padding: const EdgeInsets.all(2.0),
      itemBuilder: (context, index) {
        var fileName = _files[index].path.split('/').last;
        var extensions = fileName.split('.').last.toString();
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: <Widget>[
              Container(
                width: 104.0,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFCCCCCC),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Image(
                            image: AssetImage(
                                "assets/images/extension/$extensions.png"),
                            width: 80.0,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      fileName,
                      maxLines: 1,
                      textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 11.0),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _files.removeWhere((element) => element == _files[index]);
                    });
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _filesExplorer() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      //print("wit files : ${files}");
      if (!mounted) return;
      if (files.length > 0) {
        setState(() {
          if (_files != null && _files.length > 0) {
            _files.addAll(files);
          } else {
            _files = files.toList();
          }
        });
      }
    } else {
      // User canceled the picker
    }

    /*try {
      path = null;
      paths = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
      );
    } on PlatformException catch (e) {
      print("Unsupported operation file _filesExplorer" + e.toString());
    }
    //print('wit file storage: ${paths}');
    if (!mounted) return;

    if (paths != null && paths.length > 0) {
      setState(() {
        if (_files != null && _files.length > 0) {
          _files.addAll(paths);
        } else {
          _files = paths.toList();
        }
      });
    }*/
  }

  alert_time(BuildContext context, int _status, int _day) async {
    String _time = '00:00';
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
                  height: MediaQuery.of(context).size.height / 3,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime:
                        DateTime(_timeOfDay.hour, _timeOfDay.minute),
                    onDateTimeChanged: (DateTime newDateTime) {
                      var newTod = TimeOfDay.fromDateTime(newDateTime);

                      final now = new DateTime.now();
                      print(DateFormat.Hm().format(DateTime(now.year, now.month,
                          now.day, newTod.hour, newTod.minute)));
                      // print(DateTime(now.year, now.month, now.day, newTod.hour,
                      //     newTod.minute));
                      _time = DateFormat.Hm()
                          .format(DateTime(now.year, now.month, now.day,
                              newTod.hour, newTod.minute))
                          .toString();
                    },
                    use24hFormat: true,
                    minuteInterval: 1,
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
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context, _time);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'ตกลง',
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
    ).then((value) {
      if (value != null) {
        print(value.toString());
        setState(() {
          if (_status == 1) {
            _inputTimeIn[_day].text = value.toString().substring(0, 5);
          } else {
            _inputTimeOut[_day].text = value.toString().substring(0, 5);
          }
        });
      }
    });
  }

  _selectDay(int _numday, bool _status) {
    setState(() {
      if (_status) {
        _daySelect.add(_numday);
        _inputTimeIn[_numday].text = _inputTimeIn[_daySelect[0]].text;
        _inputTimeOut[_numday].text = _inputTimeOut[_daySelect[0]].text;
      } else {
        _daySelect.remove(_numday);
      }
    });
    print(_daySelect);
  }

  void expect(int daysBetween, int i) {}
}
