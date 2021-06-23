import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ismart_login/page/front/front_count_absence_screen.dart';
import 'package:ismart_login/page/front/front_count_late_screen.dart';
import 'package:ismart_login/page/front/front_count_ontime_screen.dart';
import 'package:ismart_login/page/front/front_count_outside_screen.dart';
import 'package:ismart_login/page/front/future/summary_future.dart';
import 'package:ismart_login/page/front/model/sumaryToDay.dart';
import 'package:ismart_login/page/front/model/sumaryToDay_absence.dart';
import 'package:ismart_login/page/front/model/sumaryToDay_late.dart';
import 'package:ismart_login/page/front/model/sumaryToDay_ontime.dart';
import 'package:ismart_login/page/front/model/sumaryToDay_outside.dart';
import 'package:ismart_login/page/history/future/history_future.dart';
import 'package:ismart_login/page/history/model/itemAllHistory.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';

class HistoryAllScreen extends StatefulWidget {
  @override
  _HistoryAllScreenState createState() => _HistoryAllScreenState();
}

class _HistoryAllScreenState extends State<HistoryAllScreen> {
//---
  TextStyle styleLabel =
      TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 14, height: 1);
  bool isLoading = false; //LoadMore
  // --- Post Data Member

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoadHistoryAll(0);
  }

  int start = 0;
  List<ItemsAllHistory> _result = [];
  Future<bool> onLoadHistoryAll(int _start) async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "start": _start,
    };
    print(map);
    await HistoryFuture().apiGetSummaryAllDay(map).then((onValue) {
      if (start == 0) {
        setState(() {
          _result = onValue;
          print("count : " + _result.length.toString());
        });
      } else {
        setState(() {
          _result.addAll(onValue);
          print("count : " + _result.length.toString());
          isLoading = false;
        });
      }
    });
    setState(() {});
    return true;
  }

  _activeDataShow(
    int _type,
    String _date,
  ) async {
    Map _map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "create_date": _date
    };
    onLoadGetSummaryToDay(_map, _type);
  }

  List<ItemsSummaryToDay> _result_on = [];
  List<ItemsSummaryToDay_Ontime> _result_ontime = [];
  List<ItemsSummaryToDay_Late> _result_late = [];
  List<ItemsSummaryToDay_Absence> _result_absence = [];
  List<ItemsSummaryToDay_Outside> _result_outside = [];
  Future<bool> onLoadGetSummaryToDay(Map map, int _type) async {
    await SummaryFuture().apiGetSummaryToDay(map).then((onValue) {
      _result_on = onValue;
      print(_result.length);
      setState(() {
        switch (_type) {
          case 1:
            _result_absence = _result_on[0].ABSENCE;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FrontCountAbsenceScreen(
                  items: _result_absence,
                ),
              ),
            );
            break;
          case 2:
            _result_ontime = _result_on[0].ONTIME;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FrontCountOntimeScreen(
                  items: _result_ontime,
                ),
              ),
            );
            break;
          case 3:
            _result_late = _result_on[0].LATE;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FrontCountLateScreen(
                  items: _result_late,
                ),
              ),
            );
            break;
          case 4:
            _result_outside = _result_on[0].OUTSIDE;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FrontCountOutsideScreen(
                  items: _result_outside,
                ),
              ),
            );
            break;

          default:
        }
      });
    });
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return _result.length > 0
        ? _display()
        : Center(
            child: Text(
              '-- ไม่มีข้อมูล --',
              style: TextStyle(
                fontFamily: FontStyles().FontFamily,
                fontSize: 24,
                color: Colors.grey[400],
              ),
            ),
          );
  }

  Widget _display() {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[200]),
            margin: EdgeInsets.only(top: 10, bottom: 2),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!isLoading &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          // start loading data

                          setState(() {
                            start = start + 1;
                            onLoadHistoryAll(start);
                            isLoading = true;
                          });
                        }
                      },
                      child: _list(),
                    ),
                  ),
                  Container(
                    height: isLoading ? 50.0 : 0,
                    color: Colors.white70,
                    child: Center(
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _list() {
    return Scrollbar(
      child: ListView.builder(
        // separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: _result.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    _result[index].CREATE_DATE_TH,
                    style: TextStyle(
                        height: 1,
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          EasyLoading.show();
                          _activeDataShow(1, _result[index].CREATE_DATE);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[400],
                                width: 1,
                              ),
                              right: BorderSide(
                                color: Colors.grey[400],
                                width: 1,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 2, right: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              _result[index].ABSENCE > 0
                                                  ? _result[index]
                                                      .ABSENCE
                                                      .toString()
                                                  : '0',
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  fontFamily:
                                                      FontStyles().FontThaiSans,
                                                  height: 0.6),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 20,
                                            height: 3,
                                            color: Color(0xFFFF802C),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Text('คน',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 12)),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xFF18C0FF),
                                            size: 12,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'ยังไม่ลงเวลา',
                                  style: styleLabel,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          EasyLoading.show();
                          _activeDataShow(2, _result[index].CREATE_DATE);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[400],
                                width: 1,
                              ),
                              right: BorderSide(
                                color: Colors.grey[400],
                                width: 1,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 2, right: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              _result[index].ONTIME > 0
                                                  ? _result[index]
                                                      .ONTIME
                                                      .toString()
                                                  : '0',
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  fontFamily:
                                                      FontStyles().FontThaiSans,
                                                  height: 0.6),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 20,
                                            height: 3,
                                            color: Color(0xFFA7D645),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Text('คน',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 12)),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xFF18C0FF),
                                            size: 12,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'ทันเวลา',
                                  style: styleLabel,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          EasyLoading.show();
                          _activeDataShow(4, _result[index].CREATE_DATE);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[400],
                                width: 1,
                              ),
                              right: BorderSide(
                                color: Colors.grey[400],
                                width: 1,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 2, right: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              _result[index].OUTSIDE > 0
                                                  ? _result[index]
                                                      .OUTSIDE
                                                      .toString()
                                                  : '0',
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  fontFamily:
                                                      FontStyles().FontThaiSans,
                                                  height: 0.6),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 20,
                                            height: 3,
                                            color: Color(0xFFB907BD),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Text('งาน',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 12)),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xFF18C0FF),
                                            size: 12,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'นอกสถานที่',
                                  style: styleLabel,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          EasyLoading.show();
                          _activeDataShow(3, _result[index].CREATE_DATE);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[400],
                                width: 1,
                              ),
                              right: BorderSide(
                                color: Colors.grey[400],
                                width: 1,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 2, right: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              _result[index].LATE > 0
                                                  ? _result[index]
                                                      .LATE
                                                      .toString()
                                                  : '0',
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  fontFamily:
                                                      FontStyles().FontThaiSans,
                                                  height: 0.6),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 20,
                                            height: 3,
                                            color: Color(0xFFD40000),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Text('คน',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 12)),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xFF18C0FF),
                                            size: 12,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'สาย',
                                  style: styleLabel,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[400],
                              width: 1,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 2, right: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            '0',
                                            style: TextStyle(
                                                fontSize: 40,
                                                fontFamily:
                                                    FontStyles().FontThaiSans,
                                                height: 0.6),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: 20,
                                          height: 3,
                                          color: Color(0xFFFF802C),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Text('คน',
                                            style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                fontSize: 12)),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xFF18C0FF),
                                          size: 12,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                'ลา',
                                style: styleLabel,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
