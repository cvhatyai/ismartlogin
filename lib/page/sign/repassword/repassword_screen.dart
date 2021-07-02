import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ismart_login/page/profile/future/profile_future.dart';
import 'package:ismart_login/page/profile/model/itemPasswordResult.dart';
import 'package:ismart_login/page/sign/signin_screen.dart';
import 'package:ismart_login/style/develop_blank.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';

class RePasswordChange extends StatefulWidget {
  final String uid;
  RePasswordChange({Key key, @required this.uid}) : super(key: key);
  @override
  _RePasswordChangeState createState() => _RePasswordChangeState();
}

class _RePasswordChangeState extends State<RePasswordChange> {
  final _formKey = GlobalKey<FormState>();
  //Setup

  bool _rePass = false;
  bool _rePass1 = false;
  bool _autoValidate = false;

  ///
  TextEditingController _inputNewPassword = TextEditingController();
  TextEditingController _inputReNewPassword = TextEditingController();

  List<ItemsPasswordMemberResult> _item = [];
  Future<bool> onLoadMemberManage() async {
    EasyLoading.show();
    Map map = {
      "newpassword":
          md5.convert(utf8.encode(_inputReNewPassword.text)).toString(),
      "uid": widget.uid,
    };
    print(map);
    await ProfileFuture().apiUpdatePasswordMemberList(map).then((onValue) {
      if (onValue[0].STATUS) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess("บันทึกแล้ว");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ),
        );
        EasyLoading.showToast("กรุณาเข้าสู่ระบบอีกครั้ง");
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError("ล้มเหลว");
      }
    });
    setState(() {});
    return true;
  }

  _setNewPassword() async {
    String data = await SharedCashe().getItemsMemberList();
    print(data);
    String _pass = await SharedCashe.getItemsWay(name: "password");
    String _passNew =
        md5.convert(utf8.encode(_inputReNewPassword.text)).toString();
    print(_pass + " ==> " + _passNew);

    String _newData = data.replaceAll(_pass, _passNew);

    ///------
    await SharedCashe.savaItemsString(key: "item", valString: _newData);
    await SharedCashe.savaItemsString(
        key: "password",
        valString:
            md5.convert(utf8.encode(_inputReNewPassword.text)).toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.dismiss();
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
            child: Column(
              children: [
                AppBar(
                  centerTitle: true,
                  title: Text(
                    'เปลี่ยนรหัสผ่าน',
                    style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.white.withOpacity(0),
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 20),
                          width: WidhtDevice().widht(context),
                          decoration: StylePage().boxWhite,
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                autovalidate: _autoValidate,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: TextFormField(
                                        obscureText: true,
                                        controller: _inputNewPassword,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'กรุณากรอกรหัสผ่านเดิม';
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            _autoValidate = false;
                                          });
                                        },
                                        style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 24,
                                        ),
                                        decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          hintText: 'รหัสผ่านใหม่',
                                          hintStyle: TextStyle(
                                            fontFamily:
                                                FontStyles().FontThaiSans,
                                            fontSize: 24,
                                          ),
                                          labelText: 'รหัสผ่านใหม่',
                                          labelStyle: TextStyle(
                                            fontFamily:
                                                FontStyles().FontThaiSans,
                                            fontSize: 24,
                                          ),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(
                                                top:
                                                    20), // add padding to adjust icon
                                            child: Icon(
                                              Icons.lock,
                                              size: 26,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            obscureText: true,
                                            controller: _inputReNewPassword,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'กรุณา ยืนยันรหัสผ่านใหม่';
                                              }
                                              return null;
                                            },
                                            onChanged: (val) {
                                              setState(() {
                                                _autoValidate = false;
                                              });
                                              if (val.length > 0) {
                                                setState(() {
                                                  _rePass = true;
                                                });
                                                if (_inputNewPassword.text ==
                                                    val) {
                                                  setState(() {
                                                    _rePass1 = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _rePass1 = false;
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  _rePass = false;
                                                });
                                              }
                                            },
                                            style: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              fontSize: 24,
                                            ),
                                            decoration: InputDecoration(
                                              alignLabelWithHint: true,
                                              hintText: 'ยืนยันรหัสผ่านใหม่',
                                              hintStyle: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontThaiSans,
                                                fontSize: 24,
                                              ),
                                              labelText: 'ยืนยันรหัสผ่านใหม่',
                                              labelStyle: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontThaiSans,
                                                fontSize: 24,
                                              ),
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        20), // add padding to adjust icon
                                                child: Icon(
                                                  Icons.lock,
                                                  size: 26,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: _rePass,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                _rePass1
                                                    ? Text(
                                                        "รหัสผ่านตรงกัน",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                FontStyles()
                                                                    .FontFamily,
                                                            fontSize: 18,
                                                            color:
                                                                Colors.green),
                                                      )
                                                    : Text(
                                                        "รหัสผ่านไม่ตรงกัน",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                FontStyles()
                                                                    .FontFamily,
                                                            fontSize: 18,
                                                            color: Colors.red),
                                                      ),
                                                _rePass1
                                                    ? Icon(
                                                        Icons.done,
                                                        color: Colors.green,
                                                        size: 22,
                                                      )
                                                    : Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                        size: 22,
                                                      ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (_formKey.currentState.validate()) {
                                          print('ถัดไป');
                                          onLoadMemberManage();
                                        } else {
                                          // start auto validate
                                          setState(() {
                                            _autoValidate = true;
                                          });
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        padding: EdgeInsets.only(
                                            left: 25, right: 25),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF079CFD),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Text(
                                          'ตกลง',
                                          style: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              color: Colors.white,
                                              fontSize: 26),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.all(10)),
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
      ),
    );
  }
}
