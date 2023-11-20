import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';

import 'leave_types_form.dart';

class LeaveTypesScreen extends StatefulWidget {
  @override
  _LeaveTypesScreenState createState() => _LeaveTypesScreenState();
}

class _LeaveTypesScreenState extends State<LeaveTypesScreen> {
  List data = [];

  void initState() {
    onLoadCateLeaveOrgManage();
    super.initState();
  }

  onLoadCateLeaveOrgManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    var body = json.encode(map);
    final response = await http.Client().post(
      Uri.parse(Server().getCateLeaveOrg),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    data = json.decode(response.body);

    setState(() {
      print('onLoadCateLeaveOrgManage');
      data = data[0]['result'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: StylePage().background,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          actions: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LeaveTypesFormScreen(
                                      title: "เพิ่มประเภทการลา",
                                      onLoadLeaveTypes:
                                          onLoadCateLeaveOrgManage,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 20.0),
                                child: Container(
                                  child: Text(
                                    'เพิ่ม',
                                    style: StylesText.titleAppBar,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          title: Text(
                            'ประเภทการลา',
                            style: StylesText.titleAppBar,
                          ),
                          backgroundColor: Colors.white.withOpacity(0),
                          elevation: 0,
                        ),
                        Expanded(
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            width: MediaQuery.of(context).size.width,
                            child: data != null && data.length > 0
                                ? ListView(
                                    children: [
                                      for (var i = 0; i < data.length; i++)
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LeaveTypesFormScreen(
                                                  id: data[i]['id'].toString(),
                                                  onLoadLeaveTypes:
                                                      onLoadCateLeaveOrgManage,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 60,
                                            margin: EdgeInsets.only(bottom: 8),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15.0),
                                              ),
                                            ),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        data[i]['subject']
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.black,
                                                          size: 18,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LeaveTypesFormScreen(
                                                                id: data[i]
                                                                        ['id']
                                                                    .toString(),
                                                                onLoadLeaveTypes:
                                                                    onLoadCateLeaveOrgManage,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                : Container(),
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
