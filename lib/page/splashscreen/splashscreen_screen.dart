import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ismart_login/page/main.dart';
import 'package:ismart_login/page/org/organization_screen.dart';
import 'package:ismart_login/page/protect/future/protect_future.dart';
import 'package:ismart_login/page/protect/model/protectSwitch.dart';
import 'package:ismart_login/page/sign/future/singin_future.dart';
import 'package:ismart_login/page/sign/model/memberlist.dart';
import 'package:ismart_login/page/sign/model/memberresult.dart';
import 'package:ismart_login/page/sign/signin_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/gps.dart';
import 'package:ismart_login/page/protect/protected.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashscreenScreen extends StatefulWidget {
  @override
  _SplashscreenScreenState createState() => _SplashscreenScreenState();
}

class _SplashscreenScreenState extends State<SplashscreenScreen> {
  bool sent = false;
  bool protect = false;
  bool new_user = false;
  bool protect_switch = false;

  FToast fToast;

  _controllerLoginAuto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("this : _controllerLoginAuto");
    if (prefs.containsKey('item')) {
      List<ItemsMemberList> _items = [];
      String item = prefs.getString('item');
      _items =
          List.from(json.decode(item).map((m) => ItemsMemberList.fromJson(m)));
      //----
      Map _map = {
        "USERNAME": _items[0].USERNAME,
        "PASSWORD": _items[0].PASSWORD,
        "STATUS": "auto",
      };

      print("_controllerLoginAuto : ${_map}");
      //-----
      await new SigninFuture().apiSelectMember(_map).then((onValue) {
        print(onValue[0]['msg']);
        if (onValue[0]['msg'] == 'success') {
          SharedCashe.saveItemsMemberList(item: onValue[0]['result']);
          _showToast();
          if (onValue[0]['result'][0]['org_id'] == '0') {
            setState(() {
              new_user = true;
            });
          } else {
            setState(() {
              new_user = false;
            });
          }
          setState(() {
            sent = true;
          });
        } else if (onValue[0]['msg'] == 'fail') {
          setState(() {
            sent = false;
          });
          alert_non_signin(context, 'ไม่พบ Username');
        } else {
          setState(() {
            sent = false;
          });
          alert_non_signin(context, 'กรุณาป้อน Password ใหม่');
        }
      }, onError: (e) {
        print(e);
        setState(() {
          sent = false;
        });
      });
    } else {
      setState(() {
        sent = false;
      });
    }
    print("sent : ${sent}");
  }

  check_protect() async {
    bool _bool = false;
    _bool = await SharedCashe.getItemsBoolWay(key: 'setProtect');
    if (_bool == null) {
      _bool = false;
    }
    print('vv ' + _bool.toString());
    setState(() {
      protect = _bool;
    });

    if (protect) {
      _controllerLoginAuto();
    }
    // print(protect);
  }

//////////----
  List<ItemsProtectSwitch> _result = [];
  Future<bool> onLoadGetProtectSwith() async {
    Map map = {};
    await ProtectFuture().apiGetProtectSwitch(map).then((onValue) {
      setState(() {
        _result = onValue;
        print("status : ${_result[0].STATUS.toString()}");
        if (_result[0].STATUS) {
          protect_switch = true;
          check_protect();
        } else {
          protect_switch = false;
          _controllerLoginAuto();
        }
      });
    });
    setState(() {});
    return true;
  }

//////////----
  @override
  void initState() {
    // onLoadGetProtectSwith();
    _controllerLoginAuto();
    LocationService.checkService();
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              SplashScreen(
                seconds: 3,
                navigateAfterSeconds: protect
                    ? sent
                        ? new_user
                            ? OrganizationScreen()
                            : MainPage()
                        : SignInScreen()
                    : protect_switch
                        ? ProtectApp()
                        : sent
                            ? new_user
                                ? OrganizationScreen()
                                : MainPage()
                            : SignInScreen(),
                title: new Text(
                  'iSmartLogin',
                  style: new TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontFamily: FontStyles().FontFamily,
                      fontSize: 24.0),
                ),
                image: Image.asset('assets/images/other/logo_app.png'),
                photoSize: 80.0,
                gradientBackground: LinearGradient(
                    colors: [
                      Color(0xFFFFF),
                      Color(0xFF00B1FF).withOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.7, 1.0],
                    tileMode: TileMode.mirror),
                loaderColor: Colors.grey[400],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(bottom: 20),
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text(
                        "Copyright© Powered by CityVariety Corporation.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FontStyles().FontFamily,
                          fontSize: 16,
                          // color: Colors.grey[400],
                          color: Colors.white,
                        ),
                      )),
                ),
              ),
            ],
          )),
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
            'สวัสดี คุณ' + _subFullname(name),
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

  _subFullname(String fullname) {
    String name = '';
    List list = fullname.split(",");
    name = list[0];
    if (list.length > 1) {
      name += ' ' + list[1];
    }
    return name;
  }
}
