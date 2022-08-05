import 'package:flutter/material.dart';
import 'package:ismart_login/page/history/history_all_screen.dart';
import 'package:ismart_login/page/history/history_me_screen.dart';
import 'package:ismart_login/page/managements/future/member_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    onLoadMemberManage();
    super.initState();
  }

  List<ItemsMemberResultManage> _itemMember = [];
  Future<bool> onLoadMemberManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    print("apiGetMemberManageList : ${map}");
    await MemberManageFuture().apiGetMemberManageList(map).then((onValue) {
      setState(() {
        if (onValue[0].STATUS) {
          _itemMember = onValue[0].RESULT;
        }
      });
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
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          width: WidhtDevice().widht(context),
                          decoration: StylePage().boxWhite,
                          child: DefaultTabController(
                              length: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_itemMember != null)
                                    if (_itemMember.length > 0)
                                      if (_itemMember[0].MEMBER_TYPE == 'admin')
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFF53B1FF)),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.white),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TabBar(
                                              unselectedLabelColor:
                                                  Color(0xFF707070),
                                              unselectedLabelStyle: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 22),
                                              labelStyle: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 22),
                                              indicator: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Color(0xFF53B1FF)),
                                              tabs: [
                                                Tab(text: "เฉพาะคุณ"),
                                                Tab(text: "ทุกคน"),
                                              ]),
                                        ),
                                  if (_itemMember.length > 0 &&
                                      _itemMember[0].HISTORY == "1" &&
                                      _itemMember[0].MEMBER_TYPE == 'member')
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFF53B1FF)),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white),
                                      width: MediaQuery.of(context).size.width,
                                      child: TabBar(
                                          unselectedLabelColor:
                                              Color(0xFF707070),
                                          unselectedLabelStyle: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              fontSize: 22),
                                          labelStyle: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              fontSize: 22),
                                          indicator: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Color(0xFF53B1FF)),
                                          tabs: [
                                            Tab(text: "เฉพาะคุณ"),
                                            Tab(text: "ทุกคน"),
                                          ]),
                                    ),
                                  Expanded(
                                    child: Container(
                                      child: TabBarView(children: [
                                        HistoryMeScreen(),
                                        HistoryAllScreen(),
                                      ]),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
