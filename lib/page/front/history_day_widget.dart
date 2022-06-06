import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ismart_login/page/front/future/attend_future.dart';
import 'package:ismart_login/page/front/model/attendHistory.dart';
import 'package:ismart_login/page/front/model/attendOutsideDescriptionPop.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/clock.dart';
import 'package:ismart_login/system/shared_preferences.dart';

class HistoryDayWidget extends StatefulWidget {
  @override
  _HistoryDayWidgetState createState() => _HistoryDayWidgetState();
}

class _HistoryDayWidgetState extends State<HistoryDayWidget> {
  List<ItemsAttendHistory> _result = [];
  Future<bool> onLoadAttandHistory() async {
    Map map = {"uid": await SharedCashe.getItemsWay(name: 'id')};
    print(map);
    await AttandFuture().apiGetAttendHistory(map).then((onValue) {
      print(onValue.length);
      if (onValue[0].MSG == 'success') {
        _result = onValue;
      }
    });
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoadAttandHistory();
  }

  @override
  Widget build(BuildContext context) {
    return _result.length > 0
        ? Container(
            padding: EdgeInsets.only(top: 6),
            child: _result[0].MSG == 'success'
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _result[0].RESULT.length,
                    itemBuilder: (BuildContext context, int index) {
                      List<ItemsAttendOutsideDetailPop> _resultItemDetail = [];
                      if (_result[0].RESULT[index].CID == '3') {
                        _resultItemDetail = List.from(json
                            .decode(_result[0].RESULT[index].DETAIL)
                            .map((m) =>
                                ItemsAttendOutsideDetailPop.fromJson(m)));
                      }
                      return Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: _statusColor(
                                      _result[0].RESULT[index].CID != '3'
                                          ? _result[0].RESULT[index].STATUS
                                          : _result[0].RESULT[index].CID),
                                  shape: BoxShape.circle),
                            ),
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            Clock().convertTimeDot(
                                                    time: _result[0]
                                                        .RESULT[index]
                                                        .TIME) +
                                                ' น.  ' +
                                                (_result[0].RESULT[index].CID !=
                                                        '3'
                                                    ? _statusTime(_result[0]
                                                        .RESULT[index]
                                                        .STATUS)
                                                    : _resultItemDetail[0]
                                                        .TOPIC) + _result[0].RESULT[index].TIME_ID_NAME.toString(),
                                            style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                fontSize: 20,
                                                height: 1),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(5)),
                                      Text(
                                        _statusActive(_result[0].RESULT[index].STATUS,_result[0].RESULT[index].TIME_STATUS == '' ? '0': _result[0].RESULT[index].TIME_STATUS),
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 20,
                                            color: Colors.red,
                                            height: 1),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(),
          )
        : Container(
            height: 50,
            child: Center(
              child: Text(
                '--- ไม่มีข้อมูล ---',
                style: TextStyle(
                    fontFamily: FontStyles().FontFamily,
                    color: Colors.grey[400],
                    fontSize: 20),
              ),
            ),
          );
  }

  _statusTime(String n) {
    int _num = int.parse(n);
    switch (_num) {
      case 1:
        return 'เข้างาน';
        break;
      case 2:
        return 'ออกงาน';
        break;
    }
  }

  _statusColor(String n) {
    int _num = int.parse(n);
    switch (_num) {
      case 1:
        return Color(0xFF36C8FF);
        break;
      case 2:
        return Color(0xFFFFAF36);
        break;
      case 3:
        return Color(0xFFB907BD);
        break;
    }
  }

  _statusActive(String onTime, String onTimeStatus) {
    int _num = int.parse(onTime);
    int _numStatus = int.parse(onTimeStatus);
    if (_num == 1) {
      switch (_numStatus) {
        case 1:
          return 'เข้าสาย';
          break;
        case 2:
          return 'ลาไม่เต็มวัน';
          break;
        case 3:
          return 'ลืมลงชื่อเข้างาน';
          break;
        case 4:
          return 'ทำงานนอกสถานที่';
          break;
        default:
          return '';
          break;
      }
    } else if (_num == 2) {
      switch (_numStatus) {
        case 1:
          return 'ลาไม่เต็มวัน';
          break;
        case 2:
          return 'ทำงานนอกสถานที่';
          break;
        default:
          return '';
          break;
      }
    }
  }
}
