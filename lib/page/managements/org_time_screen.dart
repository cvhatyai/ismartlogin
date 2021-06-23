import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/managements/future/time_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultDayManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultMange.dart';
import 'package:ismart_login/page/managements/org_timedatail_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/widht_device.dart';

class OrgTimeManage extends StatefulWidget {
  final String org_id;
  OrgTimeManage({Key key, @required this.org_id}) : super(key: key);
  @override
  _OrgTimeManageState createState() => _OrgTimeManageState();
}

class _OrgTimeManageState extends State<OrgTimeManage> {
  ///----  / GET -----
  List<ItemsTimeResultManage> _resultItem = [];
  List<ItemsTimeResultDayManage> _resultItemDay = [];
  Future<bool> onLoadGetAllTime() async {
    Map map = {
      "org_id": widget.org_id,
    };
    await TimeManageFuture().apiGetTimeManageList(map).then((onValue) {
      print(onValue[0].STATUS);
      print(onValue[0].MSG);
      if (onValue[0].STATUS == true) {
        setState(() {
          _resultItem = onValue[0].RESULT;
        });
      }
    });
    EasyLoading.dismiss();
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoadGetAllTime();
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
                          // action button
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrgTimeDetailManage(
                                    id: '0',
                                    org_id: widget.org_id,
                                    type: 'insert',
                                  ),
                                ),
                              ).then((value) {
                                value ? onLoadGetAllTime() : null;
                              });
                            },
                          ),
                        ],
                        title: Text(
                          'วันเวลาทำงาน',
                          style: StylesText.titleAppBar,
                        ),
                        backgroundColor: Colors.white.withOpacity(0),
                        elevation: 0,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: WidhtDevice().widht(context),
                          child: ListView.builder(
                            itemCount: _resultItem.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  EasyLoading.show();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrgTimeDetailManage(
                                        id: _resultItem[index].ID,
                                        org_id: _resultItem[index].ORG_ID,
                                        type: 'update',
                                      ),
                                    ),
                                  ).then((value) {
                                    value ? onLoadGetAllTime() : null;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10, top: 5),
                                  width: WidhtDevice().widht(context),
                                  decoration: StylePage().boxWhite,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(padding: EdgeInsets.all(2)),
                                          FaIcon(
                                            FontAwesomeIcons.businessTime,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          Padding(padding: EdgeInsets.all(1)),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 3, right: 3),
                                              child: Text(
                                                _resultItem[index].SUBJECT,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 24,
                                                  height: 1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.all(4)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.event,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                Container(
                                                  child: Text(
                                                    _getDay(_resultItem[index]
                                                        .DESCRIPTION),
                                                    style: TextStyle(
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
                                                      fontSize: 18,
                                                      height: 1,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2),
                                          ),
                                        ],
                                      ),
                                    ],
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
            ],
          ),
        ),
      ),
    );
  }

  _getDay(String _itemDay) {
    _resultItemDay = List.from(
        json.decode(_itemDay).map((m) => ItemsTimeResultDayManage.fromJson(m)));

    String display = '';
    List _day = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
    for (int i = 0; i < _resultItemDay.length; i++) {
      if (i == 0) {
        display = _day[_resultItemDay[i].DAY];
      } else {
        display += ', ' + _day[_resultItemDay[i].DAY];
      }
    }
    return display;
  }
}
