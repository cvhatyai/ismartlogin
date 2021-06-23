import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/managements/org_departmentdetail_screen.dart';
import 'package:ismart_login/page/managements/org_timedatail_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:location/location.dart';

class OrgManage extends StatefulWidget {
  @override
  _OrgManageState createState() => _OrgManageState();
}

class _OrgManageState extends State<OrgManage> {
  Location _location = new Location();
  final _formKey = GlobalKey<FormState>();

  ///----
  double latMain = 0.0;
  double logMain = 0.0;
  _getLocation() {
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        latMain = currentLocation.latitude.toDouble();
        logMain = currentLocation.longitude.toDouble();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
  }

  ////----
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                      'จัดการทีม/องค์กร',
                      style: StylesText.titleAppBar,
                    ),
                    backgroundColor: Colors.white.withOpacity(0),
                    elevation: 0,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ข้อมูลทีม/องค์กร',
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      color: Colors.black,
                                      fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 20),
                            width: WidhtDevice().widht(context),
                            decoration: StylePage().boxWhite,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    // controller: _inputSubject,
                                    // focusNode: _focusSubject,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 24),
                                    decoration: InputDecoration(
                                      hintText: 'ชื่อทีม/องค์กร',
                                      hintStyle: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 24),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(
                                            0), // add padding to adjust icon
                                        child: Icon(
                                          Icons.business,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    // controller: _inputDescription,
                                    // focusNode: _focusDescription,
                                    maxLines: 2,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 24),
                                    decoration: InputDecoration(
                                      hintText: 'เกี่ยวกับทีม/องค์กร',
                                      hintStyle: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 24),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(bottom: 30),
                                        child: Icon(
                                          Icons.description_outlined,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // if (_inputLat.text == '' &&
                                          //     _inputLng.text == '') {
                                          //   alert(context,
                                          //       'กรุณาเลือกตำแน่ง/ปักหมุด ตำแหน่งที่ทีม/องค์กร บนแผ่นที่');
                                          // } else if (_inputSubject.text == '') {
                                          //   alert(
                                          //       context, 'กรุณาป้อนข้อมูลให้ครบถ้วน');
                                          // } else {
                                          //   if (_formKey.currentState.validate()) {
                                          //     print('สร้าง');
                                          //     _releaseData();
                                          //   }
                                          // }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 25, right: 25),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF079CFD),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            'บันทึก',
                                            style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                color: Colors.white,
                                                fontSize: 26),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'สาขา/กลุ่มย่อย',
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      color: Colors.black,
                                      fontSize: 24),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print(latMain.toString() +
                                        ' , ' +
                                        logMain.toString());
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         OrgDepartmentDetailManage(
                                    //       lat: latMain,
                                    //       lng: logMain,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: new BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            height: 170,
                            width: WidhtDevice().widht(context),
                            decoration: StylePage().boxWhite,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'แตะ ',
                                    style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 20,
                                        color: Colors.black26),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: new BoxDecoration(
                                      color: Colors.blue[100],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    ' เพื่อเพิ่ม',
                                    style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 20,
                                        color: Colors.black26),
                                  )
                                ],
                              ),
                            ),
                            // child: Scrollbar(
                            //   child: ListView.separated(
                            //     separatorBuilder:
                            //         (BuildContext context, int index) =>
                            //             Divider(),
                            //     itemCount: 10,
                            //     itemBuilder: (BuildContext context, int index) {
                            //       return GestureDetector(
                            //         child: Container(
                            //           child: Column(
                            //             children: [
                            //               Row(
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.center,
                            //                 children: [
                            //                   Padding(
                            //                       padding: EdgeInsets.all(2)),
                            //                   FaIcon(
                            //                     FontAwesomeIcons.briefcase,
                            //                     size: 14,
                            //                     color: Colors.grey,
                            //                   ),
                            //                   Padding(
                            //                       padding: EdgeInsets.all(1)),
                            //                   Expanded(
                            //                     child: Container(
                            //                       padding: EdgeInsets.only(
                            //                           left: 3, right: 3),
                            //                       child: Text(
                            //                         'สำนักงานใหญ่',
                            //                         overflow:
                            //                             TextOverflow.ellipsis,
                            //                         style: TextStyle(
                            //                           fontFamily: FontStyles()
                            //                               .FontFamily,
                            //                           fontSize: 20,
                            //                           height: 1,
                            //                           color: Colors.black,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //               Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.end,
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.end,
                            //                 children: [
                            //                   Icon(
                            //                     Icons.person,
                            //                     size: 16,
                            //                     color: Colors.grey,
                            //                   ),
                            //                   Container(
                            //                     child: Text(
                            //                       '10',
                            //                       style: TextStyle(
                            //                         fontFamily:
                            //                             FontStyles().FontFamily,
                            //                         fontSize: 18,
                            //                         height: 1,
                            //                         color: Colors.grey,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   Padding(
                            //                     padding: EdgeInsets.all(2),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'กะเวลาทำงาน',
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      color: Colors.black,
                                      fontSize: 24),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         OrgTimeDetailManage(
                                    //       org_id: '1',
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: new BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            height: 170,
                            width: WidhtDevice().widht(context),
                            decoration: StylePage().boxWhite,
                            child: Scrollbar(
                              child: ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(),
                                itemCount: 10,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              FaIcon(
                                                FontAwesomeIcons.businessTime,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(1)),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 3, right: 3),
                                                  child: Text(
                                                    '08:30 - 17:30 น.',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
                                                      fontSize: 22,
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
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 5, right: 2),
                                                  child: Text(
                                                    'สำนักงานใหญ่',
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
                                                      fontSize: 18,
                                                      height: 1,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                                                        'จ,อ,พ,พฤ,ศ',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FontStyles()
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
      ),
    );
  }
}
