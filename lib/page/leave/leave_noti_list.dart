import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ismart_login/page/managements/future/member_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';

import '../main.dart';
import 'leave_detail.dart';

class LeaveNotiListScreen extends StatefulWidget {
  @override
  _LeaveNotiListScreenState createState() => _LeaveNotiListScreenState();
}

class _LeaveNotiListScreenState extends State<LeaveNotiListScreen> {
  List data = [];
  String len = '0';
  List<ItemsMemberResultManage> _itemMember = [];

  void initState() {
    onLoadListNotiLeaveManage();
    onLoadMemberManage();
    super.initState();
  }

  onLoadListNotiLeaveManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    var body = json.encode(map);
    print('onLoadListNotiLeaveManage : ${body}');
    final response = await http.Client().post(
      Uri.parse(Server().getListNotiLeave),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    data = json.decode(response.body);
    print("onLoadListNotiLeaveManage : ${data}");
    if (data[0]['status'] == true) {
      len = data[0]['result'].length.toString();
    } else {
      len = data[0]['result'].length.toString();
    }
    setState(() {});
  }

  Future<bool> onLoadMemberManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
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
    List rs = [];
    if (data.length > 0) {
      rs = data[0]['result'];
    }
    return Scaffold(
      body: Container(
        decoration: StylePage().background,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Color(0xFF00B1FF),
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 26,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        },
                      ),
                      title: Text(
                        'แจ้งเตือน',
                        style: TextStyle(
                            fontFamily: FontStyles().FontFamily,
                            fontSize: 28,
                            color: Colors.white,
                            // height: 1,
                            fontWeight: FontWeight.bold),
                      ),
                      elevation: 0,
                    ),
                    Expanded(
                      child: data.length > 0 && len != "0"
                          ? Container(
                              child: ListView.builder(
                                  padding: EdgeInsets.all(8),
                                  itemCount: rs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LeaveDetailScreen(
                                              id: rs[index]['topic_id']
                                                  .toString(),
                                              loadData:
                                                  onLoadListNotiLeaveManage,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: rs[index]['status_noti'] == "0"
                                              ? Color(0xFFF5FDFD)
                                              : Colors.white,
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color(0xFFEBEBEBC4),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        height: 80,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    child: Center(
                                                      child: Text(
                                                        "●",
                                                        style: TextStyle(
                                                          height: 1.5,
                                                          color: rs[index][
                                                                      'status_leave'] ==
                                                                  "1" && rs[index]['status_noti'] == "0"
                                                              ? Color(
                                                                  0xFFFF7700)
                                                              : rs[index]['status_leave'] ==
                                                                      "2" && rs[index]['status_noti'] == "0"
                                                                  ? Color(
                                                                      0xFF01BB50)
                                                                  : rs[index]['status_leave'] ==
                                                                          "3" && rs[index]['status_noti'] == "0"
                                                                      ? Color(
                                                                          0xFFFF0000)
                                                                      : Color(
                                                                          0xFF616161),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      rs[index]['subject']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF616161),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 35,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                child: Text(
                                                  rs[index]['create_date']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xFF0A85BB)),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    height: 120,
                                    child: Image.asset(
                                      'assets/images/other/ic-send.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  "ไม่มีการแจ้งเตือนขณะนี้",
                                  style: TextStyle(fontSize: 24),
                                )
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
}
