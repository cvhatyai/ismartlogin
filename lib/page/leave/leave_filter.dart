import 'dart:ui';

import 'package:flutter/material.dart';

class LeaveFilterScreen extends StatefulWidget {
  final List statusDataTmp;
  final List typesDataTmp;
  final Function setDataFilterLeaveData;
  final String dropdownValueStartMonthTmp;
  final String dropdownValueStartYearTmp;
  final String dropdownValueEndMonthTmp;
  final String dropdownValueEndYearTmp;
  const LeaveFilterScreen(
      {Key key,
      this.statusDataTmp,
      this.typesDataTmp,
      this.setDataFilterLeaveData,
      this.dropdownValueStartMonthTmp,
      this.dropdownValueStartYearTmp,
      this.dropdownValueEndMonthTmp,
      this.dropdownValueEndYearTmp})
      : super(key: key);
  @override
  _LeaveFilterScreenState createState() => _LeaveFilterScreenState();
}

class _LeaveFilterScreenState extends State<LeaveFilterScreen> {
  List statusData = [];
  List typesData = [];
  List<String> monthFilter = [
    "เลือกเดือน",
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม"
  ];
  List<String> yearFilter = [
    "เลือกปี",
    "2565",
    "2566",
    "2567",
    "2568",
    "2569",
    "2570",
  ];
  String dropdownValueStartMonth = "เลือกเดือน";
  String dropdownValueStartYear = "เลือกปี";
  String dropdownValueEndMonth = "เลือกเดือน";
  String dropdownValueEndYear = "เลือกปี";
  String month_start = "";
  String year_start = "";
  String month_end = "";
  String year_end = "";

  Color colorActive = Color(0xFF00B9FF);
  Color colorNormal = Color(0xFFFFFFFF);
  Color colorTxtActive = Color(0xFFFFFFFF);
  Color colorTxtNormal = Color(0xFF616161);

  addStatusData(String status) {
    if (statusData.contains(status)) {
      statusData.remove(status);
    } else {
      statusData.add(status);
    }
    setState(() {});
  }

  addTypesData(String cid) {
    if (typesData.contains(cid)) {
      typesData.remove(cid);
    } else {
      typesData.add(cid);
    }
    setState(() {});
  }

  void initState() {
    if (widget.statusDataTmp != null && widget.statusDataTmp.length > 0) {
      statusData = widget.statusDataTmp;
    }
    if (widget.typesDataTmp != null && widget.typesDataTmp.length > 0) {
      typesData = widget.typesDataTmp;
    }
    if (widget.dropdownValueStartMonthTmp != null) {
      dropdownValueStartMonth = widget.dropdownValueStartMonthTmp.toString();
    }
    if (widget.dropdownValueStartYearTmp != null) {
      dropdownValueStartYear = widget.dropdownValueStartYearTmp.toString();
    }
    if (widget.dropdownValueEndMonthTmp != null) {
      dropdownValueEndMonth = widget.dropdownValueEndMonthTmp.toString();
    }
    if (widget.dropdownValueEndYearTmp != null) {
      dropdownValueEndYear = widget.dropdownValueEndYearTmp.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(26),
          topLeft: Radius.circular(26),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: new ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                children: [
                  Icon(Icons.tune_outlined, color: Color(0xFF616161)),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "ตัวกรอง",
                      style: TextStyle(color: Color(0xFF616161), fontSize: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (statusData.length == 0 && typesData.length == 0) {
                        statusData.clear();
                        typesData.clear();
                        widget.setDataFilterLeaveData(statusData, typesData,
                            month_start, year_start, month_end, year_end);
                      } else {
                        if (dropdownValueStartMonth == "เลือกเดือน" ||
                            dropdownValueStartYear == "เลือกปี" ||
                            dropdownValueEndMonth == "เลือกเดือน" ||
                            dropdownValueEndYear == "เลือกปี") {
                          month_start = "";
                          year_start = "";
                          month_end = "";
                          year_end = "";
                          widget.setDataFilterLeaveData(statusData, typesData,
                              month_start, year_start, month_end, year_end);
                        }
                      }
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      color: Color(0xFF616161),
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                "สถานะการลา",
                style: TextStyle(color: Color(0xFF616161), fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              height: 45,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        addStatusData("1");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: statusData.contains("1")
                                ? colorActive
                                : colorNormal,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: Color(0xFFC7C7C7)),
                          ),
                          child: Center(
                            child: Text(
                              "รออนุมัติ",
                              style: TextStyle(
                                  color: statusData.contains("1")
                                      ? colorTxtActive
                                      : colorTxtNormal,
                                  fontSize: 16,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        addStatusData("2");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: statusData.contains("2")
                                ? colorActive
                                : colorNormal,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: Color(0xFFC7C7C7)),
                          ),
                          child: Center(
                            child: Text(
                              "อนุมัติ",
                              style: TextStyle(
                                  color: statusData.contains("2")
                                      ? colorTxtActive
                                      : colorTxtNormal,
                                  fontSize: 16,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        addStatusData("3");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: statusData.contains("3")
                                ? colorActive
                                : colorNormal,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: Color(0xFFC7C7C7)),
                          ),
                          child: Center(
                            child: Text(
                              "ไม่อนุมัติ",
                              style: TextStyle(
                                  color: statusData.contains("3")
                                      ? colorTxtActive
                                      : colorTxtNormal,
                                  fontSize: 16,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        addStatusData("4");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: statusData.contains("4")
                                ? colorActive
                                : colorNormal,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: Color(0xFFC7C7C7)),
                          ),
                          child: Center(
                            child: Text(
                              "ยกเลิก",
                              style: TextStyle(
                                  color: statusData.contains("4")
                                      ? colorTxtActive
                                      : colorTxtNormal,
                                  fontSize: 16,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                "ประเภทการลา",
                style: TextStyle(color: Color(0xFF616161), fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              height: 45,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        addTypesData("1");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: typesData.contains("1")
                                ? colorActive
                                : colorNormal,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: Color(0xFFC7C7C7)),
                          ),
                          child: Center(
                            child: Text(
                              "ลาป่วย",
                              style: TextStyle(
                                  color: typesData.contains("1")
                                      ? colorTxtActive
                                      : colorTxtNormal,
                                  fontSize: 16,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        addTypesData("2");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: typesData.contains("2")
                                ? colorActive
                                : colorNormal,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: Color(0xFFC7C7C7)),
                          ),
                          child: Center(
                            child: Text(
                              "ลากิจ",
                              style: TextStyle(
                                  color: typesData.contains("2")
                                      ? colorTxtActive
                                      : colorTxtNormal,
                                  fontSize: 16,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        addTypesData("3");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: typesData.contains("3")
                                ? colorActive
                                : colorNormal,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: Color(0xFFC7C7C7)),
                          ),
                          child: Center(
                            child: Text(
                              "ลาอื่นๆ",
                              style: TextStyle(
                                  color: typesData.contains("3")
                                      ? colorTxtActive
                                      : colorTxtNormal,
                                  fontSize: 16,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                "ตั้งแต่เดือน",
                style: TextStyle(color: Color(0xFF616161), fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 4.0),
                    color: Color(0xFFECF2F3),
                    child: DropdownButton<String>(
                      value: dropdownValueStartMonth,
                      underline: SizedBox(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValueStartMonth = newValue;
                          if (dropdownValueStartMonth != "เลือกเดือน") {
                            month_start = dropdownValueStartMonth;
                          } else {
                            month_start = "";
                          }
                        });
                      },
                      items: monthFilter
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    color: Color(0xFFECF2F3),
                    child: DropdownButton<String>(
                      value: dropdownValueStartYear,
                      underline: SizedBox(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValueStartYear = newValue;
                          if (dropdownValueStartYear != "เลือกปี") {
                            year_start = dropdownValueStartYear;
                          } else {
                            year_start = "";
                          }
                        });
                      },
                      items: yearFilter
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Text(
                      "ถึง",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 4.0),
                    color: Color(0xFFECF2F3),
                    child: DropdownButton<String>(
                      value: dropdownValueEndMonth,
                      underline: SizedBox(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValueEndMonth = newValue;
                          if (dropdownValueEndMonth != "เลือกเดือน") {
                            month_end = dropdownValueEndMonth;
                          } else {
                            month_end = "";
                          }
                        });
                      },
                      items: monthFilter
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    color: Color(0xFFECF2F3),
                    child: DropdownButton<String>(
                      value: dropdownValueEndYear,
                      underline: SizedBox(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValueEndYear = newValue;
                          if (dropdownValueEndYear != "เลือกปี") {
                            year_end = dropdownValueEndYear;
                          } else {
                            year_end = "";
                          }
                        });
                      },
                      items: yearFilter
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  bottom: 6.0, top: 6.0, left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        statusData.clear();
                        typesData.clear();
                        month_start = "";
                        year_start = "";
                        month_end = "";
                        year_end = "";
                        widget.setDataFilterLeaveData(statusData, typesData,
                            month_start, year_start, month_end, year_end);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFECF2F3),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'ตั้งค่าใหม่',
                              style: TextStyle(
                                  color: Color(0xFF8F8C8C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.setDataFilterLeaveData(statusData, typesData,
                            month_start, year_start, month_end, year_end);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF00B9FF),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'ค้นหา',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
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
  }
}
