import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/managements/future/department_manage_future.dart';
import 'package:ismart_login/page/managements/future/time_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemDepartmentResultManage.dart';
import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultMange.dart';
import 'package:ismart_login/page/managements/org_memberdetail.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';

import 'future/member_manage_future.dart';

class OrgMemberScreen extends StatefulWidget {
  @override
  _OrgMemberScreenState createState() => _OrgMemberScreenState();
}

class _OrgMemberScreenState extends State<OrgMemberScreen> {
  int status = 0;

  ///-----member
  List<ItemsMemberResultManage> _item = [];
  Future<bool> onLoadMemberManage(String _status) async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "status": _status != '0' ? _status : '',
    };
    await MemberManageFuture().apiGetMemberManageList(map).then((onValue) {
      setState(() {
        if (onValue[0].STATUS) {
          _item = onValue[0].RESULT;
        }
      });
    });
    EasyLoading.dismiss();
    setState(() {});
    return true;
  }

  ///------ department
  List<ItemsDepartmentResultManage> _itemDepartment = [];
  Future<bool> onLoadGetAllDepartment() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
    };
    await DepartManageFuture().apiGetDepartmentManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        setState(() {
          _itemDepartment = onValue[0].RESULT;
        });
      }
    });
    return true;
  }

  _getSubjectDepartment(int _num) {
    String subject = '';
    for (int i = 0; i < _itemDepartment.length; i++) {
      if (_itemDepartment[i].ID == _num.toString()) {
        subject = _itemDepartment[i].SUBJECT;
      }
    }
    return subject;
  }

  ///------ time
  List<ItemsTimeResultManage> _itemTime = [];
  Future<bool> onLoadGetAllTime() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
    };
    await TimeManageFuture().apiGetTimeManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        setState(() {
          _itemTime = onValue[0].RESULT;
          print(_itemTime[0].SUBJECT);
        });
      }
    });
    return true;
  }

  _getSubjectTime(int _num) {
    String subject = '';
    for (int i = 0; i < _itemTime.length; i++) {
      if (_itemTime[i].ID == _num.toString()) {
        subject = _itemTime[i].SUBJECT;
      }
    }
    return subject;
  }

  //----
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoadGetAllTime();
    onLoadGetAllDepartment();
    onLoadMemberManage('0');
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
                          PopupMenuButton(
                            icon: FaIcon(FontAwesomeIcons
                                .filter), //don't specify icon if you want 3 dot menu
                            color: Colors.white,
                            itemBuilder: (context) => [
                              PopupMenuItem<int>(
                                value: 0,
                                child: Text(
                                  "ทั้งหมด",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 22),
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 1,
                                child: Text(
                                  "เข้าใช้งานได้",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 22),
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 2,
                                child: Text(
                                  "ระงับการใช้งาน",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 22),
                                ),
                              ),
                            ],
                            onSelected: (item) {
                              setState(() {
                                EasyLoading.show();
                                onLoadMemberManage(item.toString());
                                status = item;
                              });
                            },
                          )
                        ],
                        title: Text(
                          'สมาชิก',
                          style: StylesText.titleAppBar,
                        ),
                        backgroundColor: Colors.white.withOpacity(0),
                        elevation: 0,
                      ),
                      Container(
                        width: WidhtDevice().widht(context),
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                status == 0
                                    ? 'ทั้งหมด'
                                    : status == 1
                                        ? 'ใช้งานปกติ'
                                        : 'ระงับการใช้งาน',
                                style: TextStyle(
                                    fontFamily: FontStyles().FontFamily,
                                    fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    _item.length.toString(),
                                    style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(padding: EdgeInsets.all(2)),
                                  Text(
                                    'คน',
                                    style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: _item.length > 0
                            ? Container(
                                width: WidhtDevice().widht(context),
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: ListView.builder(
                                  itemCount: _item.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        EasyLoading.show();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrgMemberDetailScreen(
                                              title: _item[index].FULLNAME,
                                              id_member:
                                                  _item[index].ID.toString(),
                                              status: _item[index].STATUS == '1'
                                                  ? true
                                                  : false,
                                            ),
                                          ),
                                        ).then((value) {
                                          value
                                              ? onLoadMemberManage('0')
                                              : null;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        width: WidhtDevice().widht(context),
                                        decoration: BoxDecoration(
                                          color: _item[index].STATUS == '1'
                                              ? Colors.green[200]
                                              : Colors.red[200],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(15.0),
                                            bottomLeft: Radius.circular(10.0),
                                            bottomRight: Radius.circular(15.0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(3,
                                                  0), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(padding: EdgeInsets.all(5)),
                                            Expanded(
                                                child: Stack(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(15.0),
                                                      bottomRight:
                                                          Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      _item[index].AVATAR ==
                                                                  null ||
                                                              _item[index]
                                                                      .AVATAR ==
                                                                  ''
                                                          ? Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  new BoxDecoration(
                                                                color: Color(
                                                                    0xFFF2F2F2),
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    spreadRadius:
                                                                        2,
                                                                    blurRadius:
                                                                        5,
                                                                    offset: Offset(
                                                                        0,
                                                                        0), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .white,
                                                                size: 40,
                                                              ),
                                                            )
                                                          : Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  new BoxDecoration(
                                                                color: Color(
                                                                    0xFFF2F2F2),
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(Server
                                                                          .url +
                                                                      _item[index]
                                                                          .AVATAR),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    spreadRadius:
                                                                        2,
                                                                    blurRadius:
                                                                        5,
                                                                    offset: Offset(
                                                                        0,
                                                                        0), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              2)),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              3,
                                                                          right:
                                                                              3),
                                                                      child:
                                                                          Text(
                                                                        _subFullname(
                                                                            _item[index].FULLNAME),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontStyles().FontFamily,
                                                                          fontSize:
                                                                              24,
                                                                          height:
                                                                              1,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              2)),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              2)),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          FaIcon(
                                                                            FontAwesomeIcons.streetView,
                                                                            size:
                                                                                16,
                                                                            color:
                                                                                Colors.grey[400],
                                                                          ),
                                                                          Expanded(
                                                                              child: Container(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              scrollDirection: Axis.horizontal,
                                                                              child: Text(
                                                                                _item[index].ORG_SUB_ID == null || _item[index].ORG_SUB_ID == '' ? ' - ไม่มีข้อมูล -' : _getSubjectDepartment(int.parse(_item[index].ORG_SUB_ID)),
                                                                                style: TextStyle(
                                                                                  fontFamily: FontStyles().FontFamily,
                                                                                  fontSize: 18,
                                                                                  height: 1,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              2)),
                                                                  Container(
                                                                    child: Row(
                                                                      children: [
                                                                        FaIcon(
                                                                          FontAwesomeIcons
                                                                              .businessTime,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              Colors.grey[400],
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            _item[index].TIME_ID == null || _item[index].TIME_ID == ''
                                                                                ? ' - ไม่มีข้อมูล -'
                                                                                : _getSubjectTime(int.parse(_item[index].TIME_ID)),
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: FontStyles().FontFamily,
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
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _item[index]
                                                              .MEMBER_TYPE ==
                                                          'admin'
                                                      ? true
                                                      : false,
                                                  child: Positioned(
                                                    right: 0,
                                                    top: 0,
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 2, right: 2),
                                                      color: Colors.amber,
                                                      child: Text(
                                                        'ADMIN',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FontStyles()
                                                                  .FontFamily,
                                                          fontSize: 14,
                                                          height: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  ' -- ไม่มีข้อมูล -- ',
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 22,
                                      color: Colors.grey),
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

  _subFullname(String fullname) {
    String name = '';
    List list = fullname.split(",");
    name = list[0];
    if (list.length > 1) {
      name += ' ' + list[1];
    }
    return name;
  }
}
