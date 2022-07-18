import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ismart_login/page/front/future/attend_future.dart';
import 'package:ismart_login/page/front/model/attendStart.dart';
import 'package:ismart_login/page/front/outside_popup.dart';
import 'package:ismart_login/page/main.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/clock.dart';
import 'package:ismart_login/system/widht_device.dart';

Completer<GoogleMapController> _controller = Completer();
final currentTime = DateTime.now();

class InsiteDialog extends StatefulWidget {
  final String uid;
  final String timeId;
  final String pathImage;
  final String lat;
  final String long;
  final String time;
  final double myLat;
  final double myLng;
  final double radius;
  final bool holiday;
  final String ot_note;
  InsiteDialog({
    Key key,
    @required this.uid,
    this.pathImage,
    this.lat,
    this.long,
    this.time,
    this.myLat,
    this.myLng,
    this.radius,
    this.timeId,
    this.holiday,
    this.ot_note,

  }) : super(key: key);
  @override
  _InsiteDialogState createState() => _InsiteDialogState();
  
}

class _InsiteDialogState extends State<InsiteDialog> {
  double myLat = 0.0;
  double myLong = 0.0;
  double setLat = 0.0;
  double setLong = 0.0;
  double totalDistance = 0;
  List sortTimeOthers = [
    'สาย',
    'ลาไม่เต็มวัน',
    'ลืมลงชื่อเข้างาน',
    'ทำงานนอกสถานที่'
  ];
  int currentIndex = 0;
  TextEditingController _inputNote = TextEditingController();
  //----
  @override
  void initState() {
    super.initState();
    (widget.holiday == true)
        ? print("holiday, ${widget.holiday}")
        : print("NOT holiday, ${widget.holiday}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  distanc() {
    setState(() {
      totalDistance = Geolocator.distanceBetween(double.parse(widget.lat),
          double.parse(widget.long), widget.myLat, widget.myLng);
    });
    print('คุณอยู่ห่างจากองค์กร ' + totalDistance.toString() + ' เมตร');
    if (totalDistance <= widget.radius) {
      return true;
    } else {
      return false;
    }
  }

// --- Time

  checkTimr(String time) {
    print(time);
    if (time == null || time == "") {
      return true;
    }
    var now = new DateTime.now();
    // var insite = DateFormat("HH:mm").format(DateTime.parse(time + ':00'));
    DateTime timeInsite = DateFormat("HH:mm").parse(time);
    String insiteNow = DateFormat("HH:mm").format(now);
    DateTime timeNow = DateFormat("HH:mm").parse(insiteNow);
    if (timeNow.isBefore(timeInsite)) {
      return true;
    } else {
      return false;
    }
  }

  checkHoliday(bool holiday) {
    print(holiday);
    if (holiday == true) {
      return true;
    } else {
      return false;
    }
  }

  //---
  /// ---- Servere---
  List<ItemsAttandStartResult> _resultAttand = [];
  Future<bool> onLoadAttandStart(Map map) async {
    await AttandFuture().apiPostAttandStart(map).then((onValue) {
      print(onValue[0].STATUS);
      print(onValue[0].MSG);
      if (onValue[0].STATUS == 'success') {
        _resultAttand = onValue;
        onUploadFiles();
      }
    });
    return true;
  }

  Future<dynamic> onUploadFiles() async {
    await AttandFuture().uploadAttend(
      file: File(widget.pathImage),
      cmd: 'attend',
      uid: widget.uid,
      uploadKey: _resultAttand[0].UPLOADKEY,
      attact_type: 'i_start',
    );
    return true;
  }
  //---

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      content: SingleChildScrollView(
        child: Container(
          width: WidhtDevice().widht(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                height: 150,
                child: Image.file(
                  File(widget.pathImage),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      Clock().getTime(),
                      style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        height: 1,
                        fontSize: 40,
                        color: Color(0xFF757575),
                      ),
                    )
                  ],
                ),
              ),
              distanc()
                  ? Container()
                  : Container(
                      child: Text(
                        'คุณไม่ได้อยู่ในพื้นที่',
                        style: TextStyle(
                            fontFamily: FontStyles().FontFamily,
                            fontSize: 18,
                            color: Colors.red),
                      ),
                    ),
              Container(
                child: Column(
                  children: [
                    Text(
                      checkTimr(widget.time) ? '' : 'คุณเข้างานสาย',
                      style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        height: 1,
                        fontSize: 26,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
              checkHoliday(widget.holiday)
                  ? Container()
                  : checkTimr(widget.time)
                      ? Container()
                      : _radioButton(),
              checkHoliday(widget.holiday)
                  ? Container()
                  : checkTimr(widget.time)
                      ? Container()
                      : _causeNote(),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Map _map = {
                            "uid": widget.uid,
                            "time": Clock().onTime(),
                            "image": widget.pathImage,
                            "latitude": widget.myLat.toString(),
                            "longitude": widget.myLng.toString(),
                            "start_status": checkHoliday(widget.holiday)
                                ? '5'
                                : checkTimr(widget.time)
                                    ? '0'
                                    : (currentIndex + 1),
                            "start_note": checkHoliday(widget.holiday) ? widget.ot_note : _inputNote.text,
                            "start_location_status": distanc() ? '0' : '1',
                            "log": 'timeid_${widget.timeId}',
                          };
                          print("LOGIN : " + _map.toString());
                          onLoadAttandStart(_map);

                          ///---
                          setState(() {});
                          if (!distanc()) {
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) {
                                  return OutsideDialog(
                                      status: 1,
                                      uid: widget.uid,
                                      mainLat: widget.lat.toString(),
                                      mainLng: widget.long.toString(),
                                      lat: widget.myLat.toString(),
                                      long: widget.myLng.toString(),
                                      time: widget.time);
                                });
                          } else {
                            Navigator.pop(context);
                            EasyLoading.show();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage()),
                            );
                            EasyLoading.dismiss();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
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
      ),
    );
  }

  _causeNote() {
    return 
    Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            'สาเหตุ',
            style: TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 22),
          ),
          Expanded(
            child: TextFormField(
              controller: _inputNote,
              keyboardType: TextInputType.text,
              style:
                  TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 22),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(0), // add padding to adjust icon
                  child: Icon(
                    Icons.edit,
                    size: 22,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _radioButton() {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 0.0),
        shrinkWrap: true,
        itemCount: sortTimeOthers.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 35.0,
            alignment: Alignment.topCenter,
            child: RadioListTile(
              value: index,
              activeColor: Color(0xFF84ACFB),
              groupValue: currentIndex,
              title: Text(
                sortTimeOthers[index],
                style: TextStyle(
                    fontFamily: FontStyles().FontFamily,
                    fontSize: 22,
                    height: 1),
              ),
              onChanged: (val) {
                _select(val);
                print(val);
              },
            ),
          );
        },
      ),
    );
  }

  _select(int val) {
    setState(() {
      currentIndex = val;
    });
  }
}
