import 'dart:io';

import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/front/front_screen.dart';
import 'package:ismart_login/page/history/history_screen.dart';
import 'package:ismart_login/page/leave/leave_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'leave/leave_free_screen.dart';
import 'managements/future/member_manage_future.dart';
import 'managements/model/itemMemberResultManage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ///--
  int selectedIndex = 1;

  @override
  void initState() {
    onLoadMemberManage();
    super.initState();
  }

  List<ItemsMemberResultManage> _itemMember = [];
  Future<bool> onLoadMemberManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    await MemberManageFuture().apiGetMemberManageList(map).then((onValue) {
      setState(() {
        if (onValue[0].STATUS) {
          _itemMember = onValue[0].RESULT;
          print("main leave : " + _itemMember[0].LEAVE);
        }
      });
    });
    setState(() {});
    return true;
  }

  List _widgetOptions = [
    LeaveScreen(),
    FrontScreen(),
    HistoryScreen(),
  ];
  List _widgetFreeOptions = [
    LeaveFreeScreen(),
    FrontScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: alert_back_system,
      child: Scaffold(
        body: _itemMember.length > 0 && _itemMember[0].LEAVE == "1"
            ? _widgetOptions.elementAt(selectedIndex)
            : _widgetFreeOptions.elementAt(selectedIndex),
        // body: _widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: FFNavigationBar(
          theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.white,
            selectedItemBorderColor: Color(0xFF4EA9FB),
            selectedItemBackgroundColor: Color(0xFF4EA9FB),
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: Color(0xFF4EA9FB),
            unselectedItemIconColor: Color(0xFF4EA9FB),
            unselectedItemLabelColor: Color(0xFF4EA9FB),
            selectedItemTextStyle: TextStyle(fontSize: 14),
            unselectedItemTextStyle: TextStyle(fontSize: 14),
          ),
          selectedIndex: selectedIndex,
          onSelectTab: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            FFNavigationBarItem(
              iconData: FaIcon(FontAwesomeIcons.envelope).icon,
              label: 'ลา',
            ),
            FFNavigationBarItem(
              iconData: FaIcon(FontAwesomeIcons.clock).icon,
              label: 'ลงเวลา',
            ),
            FFNavigationBarItem(
              iconData: FaIcon(FontAwesomeIcons.history).icon,
              label: 'ประวัติ',
            ),
          ],
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
                            if (Platform.isAndroid) {
                              SystemNavigator.pop();
                            } else {
                              exit(0);
                            }
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
}
