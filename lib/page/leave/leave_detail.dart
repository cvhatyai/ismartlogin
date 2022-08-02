import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ismart_login/page/front/confirm_leave.dart';
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

class LeaveDetailScreen extends StatefulWidget {
  @override
  _LeaveDetailScreenState createState() => _LeaveDetailScreenState();
}



class _LeaveDetailScreenState extends State<LeaveDetailScreen> {
  List<int> _daySelect = [];
  DateTime FirstDate = DateTime.now();
  DateTime LastDate = DateTime.now();
  bool select1 = true;
  bool select2 = false;
  bool select3 = false;
  List<String> items = <String>['0'];
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
    onLoadMemberManage();
    super.initState();
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
    log('difference: $difference');

    for (var i = 0; i <= difference; i++) {
      if (items.every((item) => item != '${i}')) {
        items.add('${i - 0.5}');
        items.add('${i}');
      }
    }
    log('data: $items');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF00B1FF),
          title: Text(
            'สถิติ',
            style: StylesText.titleAppBar,
          ),
        ),
        body: Container(
          decoration: StylePage().background,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'ใบลา',
                              textAlign: TextAlign.left,
                              style: styleHeader,
                            ),
                          ),
                          GestureDetector(
                            child:
                          Expanded(
                            child: Text(
                              'ดูสถิติการลา',
                              textAlign: TextAlign.right,
                              style: styleHeader,
                            ),
                            
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // EasyLoading.show();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrgMemberScreen(),
                              ),
                            );
                          },),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage("assets/images/other/bg2.png"),
                            fit: BoxFit.cover),
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // Toggle light when tapped.
                                select1 = true;
                                select2 = false;
                                select3 = false;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: select1
                                      ? Colors.lightBlue.shade200
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                                ),
                                height: 100,
                                width: 100,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0),
                                        ),
                                      ),
                                      height: 70,
                                      child: SvgPicture.asset(
                                        "assets/images/other/injured.svg", //asset location
                                        color: select1 == true
                                            ? Colors.white
                                            : Colors.grey[400], //svg color
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "ลาป่วย",
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 18,
                                            color: select1 == true
                                                ? Colors.white
                                                : Colors.black,
                                            height: 1),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // Toggle light when tapped.
                                select1 = false;
                                select2 = true;
                                select3 = false;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: select2
                                      ? Colors.lightBlue.shade200
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                                ),
                                height: 100,
                                width: 100,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0),
                                        ),
                                      ),
                                      height: 70,
                                      child: SvgPicture.asset(
                                        "assets/images/other/exit.svg", //asset location
                                        color: select2 == true
                                            ? Colors.white
                                            : Colors.grey[400], //svg color
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "ลากิจ",
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 18,
                                            color: select2 == true
                                                ? Colors.white
                                                : Colors.black,
                                            height: 1),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // Toggle light when tapped.
                                select1 = false;
                                select2 = false;
                                select3 = true;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: select3
                                      ? Colors.lightBlue.shade200
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                                ),
                                height: 100,
                                width: 100,
                                child: Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            topRight: Radius.circular(15.0),
                                          ),
                                        ),
                                        height: 70,
                                        child: SvgPicture.asset(
                                          "assets/images/other/travel.svg", //asset location
                                          color: select3 == true
                                              ? Colors.white
                                              : Colors.grey[400], //svg color
                                        )),
                                    Container(
                                      child: Text(
                                        "อื่น",
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 18,
                                            color: select3 == true
                                                ? Colors.white
                                                : Colors.black,
                                            height: 1),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                              style: styleSubHeader,
                              controller: _inputCause,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'เนื่องจาก',
                              ),
                            ),
                          ),
                          Container(
                              padding:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ตั้งแต่วันที่',
                                      textAlign: TextAlign.left,
                                      style: styleSubHeader,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 40),
                                      child: Text(
                                        'รวม',
                                        textAlign: TextAlign.right,
                                        style: styleSubHeader,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                    width: 150,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.black38,
                                      ),
                                      child: Text(
                                          '${FirstDate.day}/${FirstDate.month}/${FirstDate.year}'),
                                      onPressed: () async {
                                        DateTime newDate = await showDatePicker(
                                          context: context,
                                          initialDate: FirstDate,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100),
                                        );
                                        if (newDate == null) return;

                                        setState(() {
                                          FirstDate = newDate;
                                        });
                                      },
                                    )),
                                Container(
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      'ถึง',
                                      style: styleSubHeader,
                                    )),
                                Container(
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.black38,
                                      ),
                                      child: Text(
                                          '${LastDate.day}/${LastDate.month}/${LastDate.year}'),
                                      onPressed: () async {
                                        DateTime newDate = await showDatePicker(
                                          context: context,
                                          initialDate: LastDate,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100),
                                        );
                                        if (newDate == null) return;
                                        setState(() {
                                          LastDate = newDate;
                                        });
                                      },
                                    )),
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: DropdownButton<String>(
                                    onChanged: (String newValue) {
                                      setState(() {
                                        selectItem = newValue;
                                      });
                                    },
                                    value: selectItem,
                                    items: items.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Container(
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Text('วัน')),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: _selectFullTime,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectFullTime = value;
                                      });
                                    }),
                                Text("ลาทั้งวัน"),
                                Radio(
                                    value: 2,
                                    groupValue: _selectFullTime,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectFullTime = value;
                                      });
                                    }),
                                Text("ลาไม่เต็มวัน"),
                              ],
                            ),
                          ),
                          _selectFullTime == 2
                              ? Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(right: 60),
                                                child: Text(
                                                  'รวม',
                                                  textAlign: TextAlign.right,
                                                  style: styleSubHeader,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 15),
                                            child: Text(
                                              "ตั้งแต่เวลา",
                                              style: styleSubHeader,
                                            ),
                                          ),
                                          Container(
                                            width: 200,
                                            child: ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: _groupDay.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  // child: Text(index.toString()),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      5.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      5.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      5.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                          ),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (_groupDay[
                                                                  index]) {
                                                                alert_time(
                                                                    context,
                                                                    1,
                                                                    index);
                                                              }
                                                            },
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  _inputTimeIn[
                                                                      index],
                                                              enabled: false,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      FontStyles()
                                                                          .FontFamily,
                                                                  fontSize: 24),
                                                              decoration: InputDecoration(
                                                                  // hintText: 'เข้า',
                                                                  // hintStyle: TextStyle(
                                                                  //     fontFamily: FontStyles()
                                                                  //         .FontFamily,
                                                                  //     fontSize: 18),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          width: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                          ),
                                                          child: Text(
                                                            'ถึง',
                                                            style:
                                                                styleSubHeader,
                                                          )),
                                                      Expanded(
                                                        child: Container(
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      5.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      5.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      5.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                          ),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (_groupDay[
                                                                  index]) {
                                                                alert_time(
                                                                    context,
                                                                    2,
                                                                    index);
                                                              }
                                                            },
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  _inputTimeOut[
                                                                      index],
                                                              enabled: false,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      FontStyles()
                                                                          .FontFamily,
                                                                  fontSize: 24),
                                                              decoration: InputDecoration(
                                                                  // hintText: 'ออก',
                                                                  // hintStyle: TextStyle(
                                                                  //     fontFamily: FontStyles()
                                                                  //         .FontFamily,
                                                                  //     fontSize: 18),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 5),
                                            child: DropdownButton<String>(
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  selectItemTime = newValue;
                                                });
                                              },
                                              value: selectItemTime,
                                              items: itemsTime.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          Container(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: Text('ชม.')),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 15, bottom: 20),
                            child: TextField(
                              controller: inputPhone,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'เบอร์ที่ติดต่อขณะลางาน',
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 15, bottom: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFFCCCCCC),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _filesExplorer();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.attach_file,
                                          color: Colors.blue,
                                          size: 24,
                                        ),
                                        Text(
                                          'เอกสาร(หากมี)',
                                          style: styleButton,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_files != null && _files.length > 0)
                            Container(
                              height: 120.0,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFDFDFDF),
                                  ),
                                ),
                              ),
                              child: _fileView(),
                            ),
                          Container(
                            width: 200,
                            padding: EdgeInsets.only(
                                left: 20, right: 25, bottom: 20),
                            child: GestureDetector(
                              onTap: () {
                                popup_comfirm(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                padding: EdgeInsets.only(left: 25, right: 25),
                                decoration: BoxDecoration(
                                  color: Color(0xFF079CFD),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(2),
                                    ),
                                    Text(
                                      'ขอลางาน',
                                      style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          color: Colors.white,
                                          fontSize: 26),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
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
