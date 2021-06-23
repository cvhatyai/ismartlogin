import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/protect/future/protect_future.dart';
import 'package:ismart_login/page/protect/model/protectList.dart';
import 'package:ismart_login/page/sign/signin_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:url_launcher/url_launcher.dart';

class ProtectApp extends StatefulWidget {
  @override
  _ProtectAppState createState() => _ProtectAppState();
}

class _ProtectAppState extends State<ProtectApp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _inputPass = TextEditingController();
  bool _display = false;
  bool _no_invite = false;

  List<ItemsProtect> _result = [];
  Future<bool> onLoadGetSummaryToDay(Map map) async {
    await ProtectFuture().apiGetProtect(map).then((onValue) {
      _result = onValue;
      print(_result.length);
      setState(() {
        _result = onValue;
      });
    });
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onWillPop();
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: StylePage().background,
          child: SafeArea(
            child: Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'iSmartLogin',
                      style: TextStyle(
                          fontFamily: FontStyles().FontFamily,
                          fontSize: 46,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            width: WidhtDevice().widht(context),
                            decoration: StylePage().boxWhite,
                            child: Column(
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _inputPass,
                                        onChanged: (val) {
                                          if (val.length > 0) {
                                            setState(() {
                                              _display = true;
                                              _no_invite = false;
                                            });
                                          } else {
                                            setState(() {
                                              _display = false;
                                            });
                                          }
                                        },
                                        obscureText: false,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 24),
                                        decoration: InputDecoration(
                                          hintText: 'รหัสเข้าร่วมใช้งาน',
                                          hintStyle: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              fontSize: 24),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.all(
                                                0), // add padding to adjust icon
                                            child: Icon(
                                              Icons.lock,
                                              size: 26,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Visibility(
                                        visible: _display,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _setValue();
                                            }
                                          },
                                          child: Container(
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
                                                  fontSize: 28),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(1),
                                      ),
                                      Visibility(
                                        visible: _no_invite,
                                        child: Container(
                                          child: Text(
                                            'รหัสเข้าร่วมของคุณไม่ถูกต้อง !',
                                            style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                fontSize: 22,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'หากสนใจใช้งานฟรี ',
                                              style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                fontSize: 20,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2),
                                            ),
                                            FaIcon(
                                              FontAwesomeIcons.phoneAlt,
                                              color: Colors.grey,
                                              size: 12,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                launch("tel:0864908961");
                                              },
                                              child: Text(
                                                '086-4908961 (คุณมิน)',
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 20,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
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
                  ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height / 4,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _setValue() async {
    EasyLoading.show();
    Map _map = {"key": _inputPass.text};
    onLoadGetSummaryToDay(_map);
    if (_result.length > 0) {
      bool _bool = _result[0].STATUS == 'true' ? true : false;
      await SharedCashe.savaItemsBool(key: 'setProtect', valBool: _bool);
      await SharedCashe.savaItemsString(
          key: 'keyInvite', valString: _result[0].KEYINVITE);
      if (_bool) {
        _inputPass.text = '';
        setState(() {
          _display = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
        EasyLoading.dismiss();
      } else {
        _inputPass.text = '';
        setState(() {
          _no_invite = true;
          _display = false;
        });
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  Future<bool> _onWillPop() async {
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
                  padding: EdgeInsets.all(10),
                  child: Text('คุณต้องการออกจากแอปพลิเคชันหรือไม่ ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 24,
                      )),
                ),
                Padding(padding: EdgeInsets.all(10)),
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
                            Platform.isAndroid
                                ? SystemNavigator.pop()
                                : exit(0);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red[100],
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
    );
  }
}
