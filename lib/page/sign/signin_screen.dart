import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/front/front_screen.dart';
import 'package:ismart_login/page/main.dart';
import 'package:ismart_login/page/sign/future/singin_future.dart';
import 'package:ismart_login/page/sign/model/memberlist.dart';
import 'package:ismart_login/page/sign/model/memberresult.dart';
import 'package:ismart_login/page/sign/signup_screen.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _inputPass = TextEditingController();

  bool checkProtect = false;
  final _formKey = GlobalKey<FormState>();

  FToast fToast;

  TextEditingController _inputUsername = TextEditingController();
  TextEditingController _inputPassword = TextEditingController();
  FocusNode _focusUsername = FocusNode();
  FocusNode _focusPassword = FocusNode();
  //--- Map get Value
  _postDataInput() {
    Map _map = {
      "USERNAME": _inputUsername.text,
      "PASSWORD": _inputPassword.text,
      "STATUS": "manual",
    };
    return _map;
  }

  //--API
  List<ItemsMemberResult> _result = [];
  Future<bool> onLoadInsertMember(Map map) async {
    EasyLoading.show();
    await new SigninFuture().apiSelectMember(map).then((onValue) {
      print(onValue[0]['msg']);
      if (onValue[0]['msg'] == 'success') {
        EasyLoading.dismiss();
        SharedCashe.saveItemsMemberList(item: onValue[0]['result']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
        _showToast();
      } else if (onValue[0]['msg'] == 'fail') {
        EasyLoading.dismiss();
        alert_non_signin(context, 'ไม่พบ Username');
      } else {
        EasyLoading.dismiss();
        alert_non_signin(context, 'Password ของคุณไม่ถูกต้อง');
      }
    });
    setState(() {});
    return true;
  }

  Widget formlogin() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _inputUsername,
            focusNode: _focusUsername,
            keyboardType: TextInputType.number,
            style: TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 24),
            decoration: InputDecoration(
              hintText: 'เบอร์โทรศัพท์',
              hintStyle:
                  TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 24),
              prefixIcon: Padding(
                padding: EdgeInsets.all(0), // add padding to adjust icon
                child: Icon(
                  Icons.phone_iphone,
                  size: 26,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณาป้อน เบอร์โทรศัพท์';
              }
            },
          ),
          TextFormField(
            controller: _inputPassword,
            focusNode: _focusPassword,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 24),
            decoration: InputDecoration(
              hintText: 'รหัสผ่าน',
              hintStyle:
                  TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 24),
              prefixIcon: Padding(
                padding: EdgeInsets.all(0), // add padding to adjust icon
                child: Icon(
                  Icons.lock,
                  size: 26,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณาป้อน รหัสผ่าน';
              }
            },
          ),
          Padding(
            padding: EdgeInsets.all(20),
          ),
          GestureDetector(
            onTap: () {
              if (_formKey.currentState.validate()) {
                onLoadInsertMember(_postDataInput());
                SpinKitWave(
                  color: Colors.white,
                  size: 50.0,
                );
                print('เข้าสู่ระบบ');
              }
            },
            child: Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              decoration: BoxDecoration(
                color: Color(0xFF079CFD),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'เข้าสู่ระบบ',
                style: TextStyle(
                    fontFamily: FontStyles().FontFamily,
                    color: Colors.white,
                    fontSize: 36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: alert_back_system,
      child: Scaffold(
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
                    Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 20),
                      width: WidhtDevice().widht(context),
                      decoration: StylePage().boxWhite,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            alignment: Alignment.center,
                            width: 100,
                            height: 100,
                            decoration: new BoxDecoration(
                              color: Color(0xFF18C0FF),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 75,
                            ),
                          ),
                          Text(
                            'เข้าใช้งาน',
                            style: TextStyle(
                                fontFamily: FontStyles().FontFamily,
                                fontSize: 46),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 40, left: 20, right: 20),
                            child: formlogin(),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // GestureDetector(
                                //   child: Text('ลืมรหัสผ่าน',
                                //       style: TextStyle(
                                //           fontFamily: FontStyles().FontFamily,
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 24)),
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.only(left: 10, right: 10),
                                //   child: Text(
                                //     '|',
                                //     style: TextStyle(fontSize: 30),
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpScreen()),
                                    );
                                  },
                                  child: Text('ลงทะเบียน',
                                      style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24)),
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          // Container(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       MaterialButton(
                          //         onPressed: () {
                          //           print('facebook');
                          //         },
                          //         color: Color(0xFF3B5998),
                          //         child: FaIcon(
                          //           FontAwesomeIcons.facebookF,
                          //           color: Colors.white,
                          //           size: 26,
                          //         ),
                          //         padding: EdgeInsets.all(12),
                          //         shape: CircleBorder(),
                          //       ),
                          //       MaterialButton(
                          //         onPressed: () {
                          //           print('line');
                          //         },
                          //         color: Color(0xFF00C300),
                          //         child: Image.asset(
                          //           'assets/images/social/line.png',
                          //           width: 26,
                          //           fit: BoxFit.fill,
                          //         ),
                          //         padding: EdgeInsets.all(12),
                          //         shape: CircleBorder(),
                          //       ),
                          //       MaterialButton(
                          //         onPressed: () {
                          //           print('apple');
                          //         },
                          //         color: Color(0xFFA3AAAE),
                          //         child: FaIcon(
                          //           FontAwesomeIcons.apple,
                          //           color: Colors.white,
                          //           size: 26,
                          //         ),
                          //         padding: EdgeInsets.all(12),
                          //         shape: CircleBorder(),
                          //       )
                          //     ],
                          //   ),
                          // )
                        ],
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

  Future<bool> alert_back_system() {
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
                    'คุณต้องการออกจากแอปพลิเคชัน',
                    style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 24,
                        height: 1),
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
                              ),
                            ),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'ไม่',
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

  alert_non_signin(BuildContext context, String text) async {
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
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 24,
                        height: 1),
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

  _showToast() async {
    // this will be our toast UI
    String name = await SharedCashe.getItemsWay(name: 'fullname');
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(
            'สวัสดีคุณ ' + name,
            style: TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 22),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }
}
