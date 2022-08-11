import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/clock.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class ConfirmDialog extends StatefulWidget {
  final String cause;
  final String cidSub;
  final String fullName;
  final String FirstDate;
  final String LastDate;
  final String numDate;
  final String phoneNum;
  final String firstTime;
  final String lastTime;
  final String selectFulltime;
  final bool select1;
  final bool select2;
  final bool select3;

  const ConfirmDialog(
      {Key key,
      this.onConfirmTap,
      this.cause,
      this.fullName,
      this.select1,
      this.select2,
      this.select3,
      this.FirstDate,
      this.LastDate,
      this.numDate,
      this.phoneNum,
      this.selectFulltime,
      this.firstTime,
      this.lastTime,
      this.cidSub})
      : super(key: key);

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
  final Function(String) onConfirmTap;
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  TextEditingController _inputNote = TextEditingController();
  String typeLeave;
  String cidLeave;
  final _formKey = GlobalKey<FormState>();
  void initState() {
    if (widget.select1) {
      setState(() {
        typeLeave = "ลาป่วย";
        cidLeave = "1";
      });
    }
    if (widget.select2) {
      setState(() {
        typeLeave = "ลากิจ";
        cidLeave = "2";
      });
    }
    if (widget.select3) {
      setState(() {
        typeLeave = "ลาอื่นๆ";
        cidLeave = "3";
      });
    }
  }

  Future<bool> insertInfoLeave() async {
    Map map = {
      "uid": await SharedCashe.getItemsWay(name: 'id'),
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      'cause': widget.cause,
      'firstdate': widget.FirstDate,
      'lastdate': widget.LastDate,
      'phoneNum': widget.phoneNum,
      'numDate': widget.numDate,
      'selectFultime': widget.selectFulltime,
      'firstTime': widget.firstTime,
      'lastTime': widget.lastTime,
      'selectFulltime': widget.selectFulltime,
      'cid': widget.cidSub != null && widget.cidSub != ''
          ? widget.cidSub
          : cidLeave,
    };
    var body = json.encode(map);
    print(body);
    // return false;
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
    print(response);
    final data = json.decode(response.body);
    print(data);
    if (data['msg'] == 'success') {
      Navigator.pop(context);
      alert_end(context, "บันทึกข้อมูลใบลาเรียบร้อยแล้ว");
    } else {
      Navigator.pop(context);
      alert_end(context, "ไม่สามารถบันทึกข้อมูลใบลา กรุณาติดต่อเจ้าหน้าที่");
    }
  }

  alert_end(BuildContext context, String text) async {
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
                      EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 3),
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
                            EasyLoading.show();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage()),
                            );
                            EasyLoading.dismiss();
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
                              'รับทราบ',
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      content: SingleChildScrollView(
        child: Container(
          width: WidhtDevice().widht(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  // width: 30,
                  height: 120,
                  child: Image.asset(
                    'assets/images/other/ic-send.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    'ส่งใบลา',
                    style: TextStyle(
                      fontFamily: FontStyles().FontFamily,
                      // height: 1,
                      fontSize: 26,
                      color: Colors.blue.shade300,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      child: Text(
                        widget.fullName.toString() +
                            " เนื่องจาก " +
                            widget.cause.toString() +
                            ' ขอ' +
                            typeLeave,
                        style: TextStyle(
                          fontFamily: FontStyles().FontFamily,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 5),
                    child: Text(
                      "ตั้งแต่วันที่" +
                          " " +
                          widget.FirstDate +
                          " ถึง " +
                          widget.LastDate,
                      style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        // height: 1,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.only(left: 5),
                    child: Text(
                      widget.selectFulltime == "1"
                          ? widget.numDate + " วัน"
                          : widget.numDate + " ชม.",
                      style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        // height: 1,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 10, bottom: 10),
                    child: Text(
                      "เบอร์ติดต่อได้ขณะลา" + " " + widget.phoneNum,
                      style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        // height: 1,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
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
                          insertInfoLeave();
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
                            'ยืนยัน',
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
      ),
    );
  }

  _causeNote() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            'สาเหตุ',
            style: TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 22),
          ),
          Expanded(
            child: TextFormField(
              controller: _inputNote,
              keyboardType: TextInputType.text,
              style:
                  TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 22),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(0), // add padding to adjust icon
                  child: Icon(
                    Icons.edit,
                    size: 22,
                  ),
                ),
              ),
              validator: (value) {
                print("valueOT $value");
                if (value == null || value.isEmpty) {
                  return 'กรุณาป้อนข้อมูล';
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }
}
