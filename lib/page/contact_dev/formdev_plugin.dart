import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ismart_login/page/contact_dev/future/contactus_future.dart';
import 'package:ismart_login/page/contact_dev/model/itemContactusResult.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';

class Developer extends StatefulWidget {
  @override
  _DeveloperState createState() => _DeveloperState();
}

class _DeveloperState extends State<Developer> {
  final _formKey = GlobalKey<FormState>();
  //Start-----Text Input
  TextEditingController _inputName = TextEditingController();
  TextEditingController _inputDescription = TextEditingController();
  TextEditingController _inputPhone = TextEditingController();

  TextStyle _styleLable =
      TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 26, height: 1);
  TextStyle _styleInput = TextStyle(
      fontFamily: FontStyles().FontFamily,
      fontSize: 24,
      height: 1,
      color: Colors.black);

  _perData() async {
    String inputName = _inputName.text;
    String inputDescription = _inputDescription.text;
    String inputPhone = _inputPhone.text;
    String platform;

    Platform.isAndroid ? platform = 'android' : platform = 'ios';

    Map map = {
      "topic": 'แจ้งทีมผู้พัฒนา',
      "name": inputName,
      "description": inputDescription,
      "phone": inputPhone,
      "platform": platform,
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    var body = json.encode(map);
    print(body);
    onLoadSuspendOrgManage(map);
    // return map;
    // postContact(http.Client(), body); // Send Data To API(PHP)
  }

  ///-----member
  List<ItemContactusResult> _item = [];
  Future<bool> onLoadSuspendOrgManage(Map map) async {
    print(map);
    await ContactusFuture().apiPostContactus(map).then((onValue) {
      setState(() {
        if (onValue[0].STATUS) {
          _item = onValue;
          EasyLoading.dismiss();
          EasyLoading.showSuccess("ส่งแล้ว");
          _inputName.clear();
          _inputDescription.clear();
          _inputPhone.clear();
        } else {
          EasyLoading.dismiss();
          EasyLoading.showError("ล้มเหลว");
        }
      });
    });
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
        width: WidhtDevice().widht(context),
        decoration: StylePage().boxWhite,
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  child: TextFormField(
                    maxLines: 5,
                    controller: _inputDescription,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    style: _styleInput,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFCECECE))),
                      labelText: "รายละเอียด",
                      labelStyle: _styleLable,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                SizedBox(
                  child: TextFormField(
                    controller: _inputName,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    style: _styleInput,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFCECECE))),
                      labelText: "ชื่อ-สกุล",
                      labelStyle: _styleLable,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                SizedBox(
                  child: TextFormField(
                    controller: _inputPhone,
                    maxLength: 10,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.phone,
                    style: _styleInput,
                    decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCECECE))),
                        labelText: "เบอร์โทรศัพท์",
                        labelStyle: _styleLable),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(padding: EdgeInsets.all(5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                _perData();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              padding: EdgeInsets.only(left: 25, right: 25),
                              decoration: BoxDecoration(
                                color: Color(0xFF079CFD),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                  ),
                                  Text(
                                    'ส่ง',
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
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
