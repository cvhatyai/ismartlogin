import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ismart_login/page/managements/future/time_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemTimeManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultDayManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultMange.dart';
import 'package:ismart_login/page/managements/org_time_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';

class OrgTimeDetailManage extends StatefulWidget {
  final String id;
  final String org_id;
  final String type;
  OrgTimeDetailManage({Key key, @required this.id, this.org_id, this.type})
      : super(key: key);
  @override
  _OrgTimeDetailManageState createState() => _OrgTimeDetailManageState();
}

class _OrgTimeDetailManageState extends State<OrgTimeDetailManage> {
  final _formKey = GlobalKey<FormState>();
  TextStyle _txtDay =
      TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 20, height: 1);

  ///----
  List<TextEditingController> _inputTimeIn = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List<TextEditingController> _inputTimeOut = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  FocusNode _focusDegree = FocusNode();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  TextEditingController _inputSubject = TextEditingController();
  FocusNode _focusSubject = FocusNode();

  ///-----
  List<bool> _groupDay = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> _groupDayName = [
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์',
  ];
  List<int> _daySelect = [];

  ///-----
  _setDetailDayToJson() async {
    EasyLoading.show();
    _daySelect.sort();
    List time = [];
    for (int i = 0; i < _daySelect.length; i++) {
      time.add({
        "day": _daySelect[i],
        "time_start": _inputTimeIn[_daySelect[i]].text,
        "time_end": _inputTimeOut[_daySelect[i]].text
      });
    }

    Map map = {
      "subject": _inputSubject.text,
      "org_id": widget.org_id != ''
          ? widget.org_id
          : await SharedCashe.getItemsWay(name: 'org_id'),
      "description": json.encode(time),
      "status": "1",
      "id": widget.id,
      "type": widget.type,
    };
    print(json.encode(map).toString());
    // EasyLoading.showError('ล้มเหลว');
    onLoadPostTime(map);
  }

  ///---- INSER/UPDATE -----
  List<ItemsTimeManagePostUpdate> _result = [];
  Future<bool> onLoadPostTime(Map map) async {
    await TimeManageFuture().apiPostTimeManageList(map).then((onValue) {
      print(onValue[0].STATUS);
      print(onValue[0].MSG);
      if (onValue[0].STATUS == true) {
        EasyLoading.showSuccess('บันทึกแล้ว');
      } else {
        EasyLoading.showError('ล้มเหลว');
      }
    });
    return true;
  }

  ///----  / GET -----
  List<ItemsTimeResultManage> _resultItem = [];
  List<ItemsTimeResultDayManage> _resultItemDay = [];
  Future<bool> onLoadGetTime() async {
    _resultItemDay.clear();
    Map map = {"org_id": widget.org_id, "id": widget.id};
    print(map);
    await TimeManageFuture().apiGetTimeManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        _resultItem = onValue[0].RESULT;
        print(_resultItem.length);
        _resultItemDay = List.from(json
            .decode(_resultItem[0].DESCRIPTION)
            .map((m) => ItemsTimeResultDayManage.fromJson(m)));
      }
    });
    _setShowValue();
    EasyLoading.dismiss();
    return true;
  }

  _setShowValue() {
    _inputSubject.text = _resultItem[0].SUBJECT;
    for (int i = 0; i < _resultItemDay.length; i++) {
      setState(() {
        _inputTimeIn[_resultItemDay[i].DAY].text = _resultItemDay[i].TIME_START;
        _inputTimeOut[_resultItemDay[i].DAY].text = _resultItemDay[i].TIME_END;
        _groupDay[_resultItemDay[i].DAY] = true;
        _daySelect.add(_resultItemDay[i].DAY);
      });
    }
  }

  ///----------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.dismiss();
    print(widget.type);
    if (widget.type == 'update') {
      onLoadGetTime();
    }
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
          child: SingleChildScrollView(
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
                      onPressed: () => Navigator.pop(context, true),
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
                          );
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
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 20),
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
                                  hintText: 'ชื่อเวลา',
                                  hintStyle: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 24),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(
                                        0), // add padding to adjust icon
                                    child: Icon(
                                      Icons.access_time_outlined,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Container(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _groupDay.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      // child: Text(index.toString()),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (_groupDay[index]) {
                                                    _groupDay[index] = false;
                                                    _inputTimeIn[index].text =
                                                        '';
                                                    _inputTimeOut[index].text =
                                                        '';
                                                  } else {
                                                    _groupDay[index] = true;
                                                  }
                                                });
                                                _selectDay(
                                                    index, _groupDay[index]);
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: 25,
                                                    width: 25,
                                                    child: Icon(
                                                      Icons.done,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: _groupDay[index]
                                                          ? Colors.blue
                                                          : Colors.white,
                                                      border: Border.all(
                                                          color: Colors.blue,
                                                          width: 3),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      ' ' +
                                                          _groupDayName[index],
                                                      style: _txtDay,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (_groupDay[index]) {
                                                  alert_time(context, 1, index);
                                                }
                                              },
                                              child: TextFormField(
                                                controller: _inputTimeIn[index],
                                                enabled: false,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontStyles().FontFamily,
                                                    fontSize: 24),
                                                decoration: InputDecoration(
                                                  hintText: 'เข้า',
                                                  hintStyle: TextStyle(
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text('-'),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (_groupDay[index]) {
                                                  alert_time(context, 2, index);
                                                }
                                              },
                                              child: TextFormField(
                                                controller:
                                                    _inputTimeOut[index],
                                                enabled: false,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontStyles().FontFamily,
                                                    fontSize: 24),
                                                decoration: InputDecoration(
                                                  hintText: 'ออก',
                                                  hintStyle: TextStyle(
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Visibility(
                                visible: _daySelect.length > 0 ? true : false,
                                child: GestureDetector(
                                  onTap: () {
                                    _setDetailDayToJson();
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 25, right: 25),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF079CFD),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      'บันทึก',
                                      style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          color: Colors.white,
                                          fontSize: 26),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _selectDay(int _numday, bool _status) {
    setState(() {
      if (_status) {
        _daySelect.add(_numday);
        _inputTimeIn[_numday].text = _inputTimeIn[_daySelect[0]].text;
        _inputTimeOut[_numday].text = _inputTimeOut[_daySelect[0]].text;
      } else {
        _daySelect.remove(_numday);
      }
    });
    print(_daySelect);
  }

  alert_time(BuildContext context, int _status, int _day) async {
    String _time = '0000-00-00 00:00:00';
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
                  height: MediaQuery.of(context).size.height / 3,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime:
                        DateTime(_timeOfDay.hour, _timeOfDay.minute),
                    onDateTimeChanged: (DateTime newDateTime) {
                      var newTod = TimeOfDay.fromDateTime(newDateTime);
                      final now = new DateTime.now();
                      print(DateTime(now.year, now.month, now.day, newTod.hour,
                          newTod.minute));
                      _time = DateTime(now.year, now.month, now.day,
                              newTod.hour, newTod.minute)
                          .toString();
                    },
                    use24hFormat: true,
                    minuteInterval: 1,
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
                              'ปิด',
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
                            Navigator.pop(context, _time);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[100],
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
    ).then((value) {
      if (value != null) {
        print(value.toString());
        setState(() {
          if (_status == 1) {
            _inputTimeIn[_day].text = value.toString().substring(11, 19);
          } else {
            _inputTimeOut[_day].text = value.toString().substring(11, 19);
          }
        });
      }
    });
  }
}
