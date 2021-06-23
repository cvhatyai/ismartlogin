import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ismart_login/page/managements/future/org_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemOrgManage.dart';
import 'package:ismart_login/page/managements/org_manage_screen.dart';
import 'package:ismart_login/page/managements/org_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:location/location.dart';

Completer<GoogleMapController> _controller = Completer();

class OrganizationCreateScreen extends StatefulWidget {
  final String type;
  final String title;
  final String id;
  OrganizationCreateScreen({Key key, @required this.type, this.title, this.id})
      : super(key: key);
  _OrganizationCreateScreenState createState() =>
      _OrganizationCreateScreenState();
}

class _OrganizationCreateScreenState extends State<OrganizationCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  FToast fToast;
  TimeOfDay _timeOfDay = TimeOfDay.now();
  //
  TextEditingController _inputSubject = TextEditingController();
  FocusNode _focusSubject = FocusNode();
//-----
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _releaseData() async {
    String _subject = _inputSubject.text;

    Map _map = {
      "subject": _subject,
      "type": widget.type == "insert" ? widget.type : "update",
      "id": widget.type == "insert" ? widget.id : "0",
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    print(_map);
    onLoadPostUpdateOrg(_map);
  }

  //---
  List<ItemsOrgPostManage> _resultOrgPost = [];
  Future<bool> onLoadPostUpdateOrg(Map map) async {
    await OrgManageFuture().apiPostOrgManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        EasyLoading.showSuccess('สร้างเรียบร้อย');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrgManageScreen(),
          ),
        );
      } else {
        EasyLoading.showError('ล้มเหลว');
      }
    });
    return true;
  }

  ///-----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: StylePage().background,
        child: SafeArea(
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  widget.title,
                  style: TextStyle(
                      fontFamily: FontStyles().FontFamily,
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
                actions: [
                  // action button
                  widget.type == "update_1"
                      ? IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrganizationCreateScreen(
                                  type: 'insert',
                                  title: 'สร้างทีม/องค์กรใหม่',
                                  id: '0',
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                ],
                backgroundColor: Colors.white.withOpacity(0),
                elevation: 0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                  width: WidhtDevice().widht(context),
                  decoration: StylePage().boxWhite,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _inputSubject,
                          focusNode: _focusSubject,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontFamily: FontStyles().FontFamily,
                              fontSize: 24),
                          decoration: InputDecoration(
                            hintText: 'ชื่อทีม/องค์กร',
                            hintStyle: TextStyle(
                                fontFamily: FontStyles().FontFamily,
                                fontSize: 24),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(
                                  0), // add padding to adjust icon
                              child: Icon(
                                Icons.work,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_inputSubject.text == '') {
                                  alert(context, 'กรุณาป้อนข้อมูลให้ครบถ้วน');
                                } else {
                                  if (_formKey.currentState.validate()) {
                                    print('สร้าง');
                                    _releaseData();
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 25),
                                decoration: BoxDecoration(
                                  color: Color(0xFF079CFD),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  widget.type == "insert" ? "สร้าง" : "บันทึก",
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      color: Colors.white,
                                      fontSize: 26),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Visibility(
                visible: widget.type == "insert"
                    ? false
                    : widget.type == 'update'
                        ? true
                        : false,
                child: Container(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 20),
                      width: WidhtDevice().widht(context),
                      decoration: StylePage().boxWhite,
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.retweet,
                                color: Colors.white,
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                              Text(
                                'ใช้งานบน "' + widget.title + '"',
                                style: TextStyle(
                                  fontFamily: FontStyles().FontFamily,
                                  fontSize: 28,
                                  color: Colors.white,
                                  height: 1,
                                ),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showToast() async {
    // this will be our toast UI
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.copy,
            color: Colors.white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            'คัดลอกแล้ว',
            style: TextStyle(
                fontFamily: FontStyles().FontFamily,
                fontSize: 22,
                color: Colors.white),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );
  }

  alert(BuildContext context, String text) async {
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
}
