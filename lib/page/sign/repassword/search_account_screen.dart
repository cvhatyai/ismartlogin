import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ismart_login/page/profile/future/profile_future.dart';
import 'package:ismart_login/page/sign/future/member_future.dart';
import 'package:ismart_login/page/sign/model/otplist.dart';
import 'package:ismart_login/page/sign/repassword/future/repassword_future.dart';
import 'package:ismart_login/page/sign/repassword/model/itemRePasswordResultDetail.dart';
import 'package:ismart_login/page/sign/repassword/otp_repassword_screen.dart';
import 'package:ismart_login/page/sign/signin_screen.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/widht_device.dart';

class SearchAccountScreen extends StatefulWidget {
  @override
  _SearchAccountScreenState createState() => _SearchAccountScreenState();
}

class _SearchAccountScreenState extends State<SearchAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  //Setup
  bool _resultBool = false;

  ///
  TextEditingController _inputPhone = TextEditingController();

  List<ItemsRePasswordMemberResultDetail> _item = [];
  Future<bool> onLoadGetMember() async {
    Map map = {"phone": _inputPhone.text};
    await RepasswordFuture().apiGetMemberList(map).then((onValue) {
      if (onValue[0].STATUS) {
        setState(() {
          _item = onValue[0].RESULT;
          if (_item.length > 0) {
            _resultBool = true;
          } else {
            _resultBool = false;
          }
        });
      } else {
        EasyLoading.showError("ไม่พบ Username");
      }
    });
    setState(() {});
    return true;
  }

  //----
  //--API
  List<ItemsOTPList> _result = [];
  Future<bool> onLoadSendOtp(String phone) async {
    Map map = {"PHONE": phone};
    await new MemberFuture().apiPostOtp(map).then((onValue) {
      _result = onValue;
      print(_result[0].MSG);
      print(onValue.length);
    });
    setState(() {});
    return true;
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
                    'ลืมรหัสผ่าน',
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
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: TextFormField(
                                        controller: _inputPhone,
                                        maxLength: 10,
                                        keyboardType: TextInputType.phone,
                                        style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 24,
                                        ),
                                        decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          hintText: 'เบอร์โทรศัพท์',
                                          hintStyle: TextStyle(
                                            fontFamily:
                                                FontStyles().FontThaiSans,
                                            fontSize: 24,
                                          ),
                                          counterText: "",
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(
                                                top:
                                                    0), // add padding to adjust icon
                                            child: Icon(
                                              Icons.phone_iphone_outlined,
                                              size: 26,
                                            ),
                                          ),
                                        ),
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
                                          onLoadGetMember();
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF079CFD),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.search,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'ค้นหา',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
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
                              Padding(padding: EdgeInsets.all(10)),
                              Visibility(
                                visible: _resultBool,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _item.length == 0
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  width: 70,
                                                  height: 70,
                                                  decoration: new BoxDecoration(
                                                    color: Color(0xFFF2F2F2),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(0,
                                                            0), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 50,
                                                  ),
                                                )
                                              : _item[0].AVATAR == ""
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 70,
                                                      height: 70,
                                                      decoration:
                                                          new BoxDecoration(
                                                        color:
                                                            Color(0xFFF2F2F2),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset: Offset(0,
                                                                0), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                        size: 50,
                                                      ),
                                                    )
                                                  : Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      width: 70,
                                                      height: 70,
                                                      decoration:
                                                          new BoxDecoration(
                                                        color:
                                                            Color(0xFFF2F2F2),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              Server.url +
                                                                  _item[0]
                                                                      .AVATAR),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset: Offset(0,
                                                                0), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                          Padding(padding: EdgeInsets.all(5)),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _item.length > 0
                                                    ? _sunStringFullname(
                                                        _item[0].FULLNAME)
                                                    : "",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  height: 1,
                                                ),
                                              ),
                                              Text(
                                                _item.length > 0
                                                    ? _item[0].NICKNAME
                                                    : "",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  height: 1,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _resultBool = false;
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'ไม่ใช่บัญชีฉัน',
                                                  style: TextStyle(
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
                                                      color: Colors.grey,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                onLoadSendOtp(_item[0].PHONE);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OtpRepasswordScreen(
                                                      map: {
                                                        "PHONE": _item[0].PHONE,
                                                        "UID": _item[0].UID,
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF079CFD),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  'ใช่ นี่บัญชีฉัน',
                                                  style: TextStyle(
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
                                                      color: Colors.white,
                                                      fontSize: 24),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
      ),
    );
  }

  _sunStringFullname(String fullname) {
    List name = fullname.split(",");
    String txt = "";
    txt = name[0];
    if (name.length > 1) {
      txt += " " + name[1];
    }
    return txt;
  }
}
