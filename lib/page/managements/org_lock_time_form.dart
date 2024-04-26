import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrgLockTimeFormScreen extends StatefulWidget {
  final String title;
  final String statusBtn;
  const OrgLockTimeFormScreen({Key key, this.title, this.statusBtn})
      : super(key: key);

  @override
  _OrgLockTimeFormScreenState createState() => _OrgLockTimeFormScreenState();
}

class _OrgLockTimeFormScreenState extends State<OrgLockTimeFormScreen> {
  List data = [];
  bool _switchStatus = true;
  TextEditingController _inputSubject = TextEditingController();

  @override
  void initState() {
    onLoadtimeSEManage();
    super.initState();
  }

  onLoadtimeSEManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    var body = json.encode(map);
    final response = await http.Client().post(
      Uri.parse(Server().getOrgSEDetail),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    data = json.decode(response.body);
    print(data);
    print(widget.statusBtn);
    if (data[0]['status'] == "success") {
      if (widget.statusBtn == 'in') {
        _inputSubject.text = data[0]['start_time_login'];
      } else {
        _inputSubject.text = data[0]['end_time_login'];
      }
    }
    setState(() {});
  }

  update() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
      "start_time_login": widget.statusBtn == 'in' ? _inputSubject.text : "",
      "end_time_login": widget.statusBtn == 'out' ? _inputSubject.text : "",
    };
    var body = json.encode(map);
    final response = await http.Client().post(
      Uri.parse(Server().postTimeSTManage),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    var data = json.decode(response.body);
    print(data);
    if (data[0]['status'] == "success") {
      EasyLoading.showSuccess('บันทึกสำเร็จ');
    } else {
      EasyLoading.showError('บันทึกไม่สำเร็จ');
    }
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
                          actions: [],
                          title: Text(
                            widget.title != null
                                ? widget.title
                                : 'ตั้งเวลาปุ่มเข้า-ออกงาน',
                            style: StylesText.titleAppBar,
                          ),
                          backgroundColor: Colors.white.withOpacity(0),
                          elevation: 0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                children: [
                                  TextFormField(
                                    controller: _inputSubject,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'เข้างานได้ก่อนกี่ชั่วโมง',
                                    ),
                                  ),
                                  if (widget.statusBtn == 'in' &&
                                      widget.statusBtn != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10),
                                      child: Text(
                                        "หมายเหตุ: คุณจะสามารถเข้างานก่อนเวลาทำงานของคุณ ตามจำนวนที่ชั่วโมงที่กรอก",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  if (widget.statusBtn == 'out' &&
                                      widget.statusBtn != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10),
                                      child: Text(
                                        "หมายเหตุ: คุณจะไม่สามารถออกงานหลังเวลางานของคุณ ตามจำนวนที่ชั่วโมงที่กรอก",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Container(
                                  //   child: Row(
                                  //     children: [
                                  //       Expanded(
                                  //           child: Container(
                                  //         child: Text(
                                  //           'สถานะ',
                                  //           style: TextStyle(fontSize: 18),
                                  //         ),
                                  //       )),
                                  //       FlutterSwitch(
                                  //         value: _switchStatus ? true : false,
                                  //         width: 80.0,
                                  //         height: 40.0,
                                  //         valueFontSize: 12.0,
                                  //         toggleSize: 35.0,
                                  //         borderRadius: 20.0,
                                  //         padding: 5.0,
                                  //         showOnOff: true,
                                  //         activeText: 'เปิด',
                                  //         activeColor: Colors.green,
                                  //         inactiveText: 'ไม่ปิด',
                                  //         inactiveColor: Colors.grey,
                                  //         onToggle: (state) {
                                  //           setState(() {
                                  //             _switchStatus = state;
                                  //           });
                                  //         },
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: InkWell(
                                      onTap: () {
                                        if (_inputSubject.text == "") {
                                          EasyLoading.showError(
                                              'กรอกจำนวนชั่วโมงเป็นตัวเลข');
                                          return false;
                                        } else {
                                          update();
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF00B9FF),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'บันทึก',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
