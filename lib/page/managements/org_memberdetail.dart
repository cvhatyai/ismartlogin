import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ismart_login/page/managements/future/department_manage_future.dart';
import 'package:ismart_login/page/managements/future/member_manage_future.dart';
import 'package:ismart_login/page/managements/future/time_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemDepartmentResultManage.dart';
import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';
import 'package:ismart_login/page/managements/model/itemMemberStatusManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultMange.dart';
import 'package:ismart_login/page/profile/future/profile_future.dart';
import 'package:ismart_login/page/profile/password_screen.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/develop_blank.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';

class OrgMemberDetailScreen extends StatefulWidget {
  final String title;
  final String id_member;
  final bool status;
  OrgMemberDetailScreen(
      {Key key, @required this.title, this.id_member, this.status})
      : super(key: key);
  @override
  _OrgMemberDetailScreenState createState() => _OrgMemberDetailScreenState();
}

class _OrgMemberDetailScreenState extends State<OrgMemberDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  //Setup
  PickedFile _imageFile;
  dynamic _pickImageError;

  ///
  bool _edit = false;
  String uid = '';
  String uid_my = '';
  String avatar = '';
  bool _switchStatus = false;
  bool _switchStat = false;
  bool _switchAdmin = false;
  List _listTime = [];

  ///
  TextEditingController _inputName = TextEditingController();
  TextEditingController _inputLastname = TextEditingController();
  TextEditingController _inputNickname = TextEditingController();

  ///
  String dropdownValueTime = '0';
  String dropdownValueDepartment = '0';
//---
  _getMyUid() async {
    uid_my = await SharedCashe.getItemsWay(name: 'id');
  }

  ///------ Time
  ///----  / GET -----
  List<ItemsTimeResultManage> _itemTime = [];
  Future<bool> onLoadGetAllTime() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
    };
    await TimeManageFuture().apiGetTimeManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        setState(() {
          _itemTime = onValue[0].RESULT;
          dropdownValueTime = _itemTime[0].ID;
        });
      }
    });
    return true;
  }

  List<ItemsDepartmentResultManage> _resultDepartment = [];
  Future<bool> onLoadGetAllDepartment() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
    };
    await DepartManageFuture().apiGetDepartmentManageList(map).then((onValue) {
      if (onValue[0].STATUS == true) {
        setState(() {
          _resultDepartment = onValue[0].RESULT;
          dropdownValueDepartment = _resultDepartment[0].ID;
        });
      }
    });
    EasyLoading.dismiss();
    return true;
  }

  ///-----
  ///
  ///  ///-----member
  List<ItemsMemberResultManage> _item = [];
  Future<bool> onLoadMemberManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": widget.id_member,
    };
    await MemberManageFuture().apiGetMemberManageList(map).then((onValue) {
      setState(() {
        if (onValue[0].STATUS) {
          _item = onValue[0].RESULT;
          print("status : " + _item[0].STATUS.toString());
          if (_item.length > 0) {
            if (_item[0].ORG_SUB_ID.toString() != '') {
              setState(() {
                dropdownValueDepartment = _item[0].ORG_SUB_ID;
              });
            }
            if (_item[0].TIME_ID.toString() != '') {
              setState(() {
                dropdownValueTime = _item[0].TIME_ID;
              });
            }
          }

          _getData();
        }
      });
    });
    EasyLoading.dismiss();
    setState(() {});

    return true;
  }

  List<ItemsMemberStatusManage> _itemStatus = [];
  Future<bool> onLoadMemberStatusManage(Map map) async {
    await MemberManageFuture()
        .apiGetMemberStatusManageList(map)
        .then((onValue) {
      setState(() {
        if (onValue[0].STATUS == false) {
          EasyLoading.showError('Error Save');
        }
      });
    });
    setState(() {});
    return true;
  }

  _getData() async {
    String fullname = _item[0].FULLNAME;
    String _uid = widget.id_member;
    String _nickname = _item[0].NICKNAME;
    String _avatar = _item[0].AVATAR == null ? '' : _item[0].AVATAR;
    setState(() {
      List name = fullname.split(",");
      _inputName.text = name[0];
      if (name.length > 1) {
        _inputLastname.text = name[1];
      }
      _inputNickname.text = _nickname;
      uid = _uid;
      avatar = _avatar;
      _switchStatus = _item[0].STATUS == '1' ? true : false;
      _switchStat = _item[0].STAT == '1' ? true : false;
      _switchAdmin = _item[0].MEMBER_TYPE == 'admin' ? true : false;
    });
  }

  Future<dynamic> onUpdateProfile() async {
    await ProfileFuture().updateProfile(
      file: _imageFile != null ? _imageFile.path : '',
      uid: widget.id_member,
      name: _inputName.text,
      lastname: _inputLastname.text,
      nickname: _inputNickname.text,
      department: dropdownValueDepartment,
      time: dropdownValueTime,
      org_id: await SharedCashe.getItemsWay(name: 'org_id'),
    );
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMyUid();
    onLoadGetAllTime();
    onLoadGetAllDepartment();
    onLoadMemberManage();
    // _switch = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: StylePage().background,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
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
                  title: Text(
                    widget.title,
                    style: StylesText.titleAppBar,
                  ),
                  backgroundColor: Colors.white.withOpacity(0),
                  elevation: 0,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 20),
                          width: WidhtDevice().widht(context),
                          decoration: StylePage().boxWhite,
                          child: Column(
                            children: [
                              Visibility(
                                visible: !_edit ? true : false,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: WidhtDevice().widht(context),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!_edit) {
                                        setState(() {
                                          _edit = true;
                                        });
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.userEdit,
                                          size: 18,
                                        ),
                                        Padding(padding: EdgeInsets.all(3)),
                                        Text(
                                          'แก้ไข',
                                          style: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              fontSize: 22),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (_edit) {
                                          _handleClickFiles();
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Center(
                                          child: Container(
                                            child: ClipOval(
                                              child: Container(
                                                width: 150,
                                                height: 150,
                                                color: Color(0xFFA6D6F2),
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        child: Center(
                                                          child: avatar != ''
                                                              ? Image.network(
                                                                  Server.url +
                                                                      avatar,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 300.0,
                                                                  height: 300.0,
                                                                )
                                                              : _imageFile ==
                                                                      null
                                                                  ? Icon(
                                                                      Icons
                                                                          .person,
                                                                      size: 140,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : Image.file(
                                                                      File(_imageFile
                                                                          .path),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width:
                                                                          300.0,
                                                                      height:
                                                                          300.0,
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
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(10)),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            child: TextFormField(
                                              enabled: _edit,
                                              controller: _inputName,
                                              keyboardType: TextInputType.name,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'กรุณากรอกข้อมูล';
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                fontSize: 24,
                                              ),
                                              decoration: InputDecoration(
                                                alignLabelWithHint: true,
                                                hintText: 'ชื่อ',
                                                hintStyle: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontThaiSans,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: TextFormField(
                                              enabled: _edit,
                                              keyboardType: TextInputType.name,
                                              controller: _inputLastname,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                fontSize: 24,
                                              ),
                                              decoration: InputDecoration(
                                                  alignLabelWithHint: true,
                                                  hintText: 'นามสกุล',
                                                  hintStyle: TextStyle(
                                                    fontFamily: FontStyles()
                                                        .FontThaiSans,
                                                    fontSize: 24,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(2)),
                                    SizedBox(
                                      child: TextFormField(
                                        enabled: _edit,
                                        keyboardType: TextInputType.name,
                                        controller: _inputNickname,
                                        style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 24,
                                        ),
                                        decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            hintText: 'ชื่อเรียกในองค์กร',
                                            hintStyle: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontThaiSans,
                                              fontSize: 24,
                                            )),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(2)),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: Text(
                                              'สาขา',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 22),
                                            ))),
                                        Expanded(
                                          flex: 2,
                                          child: _edit
                                              ? Container(
                                                  child: DropdownButton<String>(
                                                    value:
                                                        dropdownValueDepartment,
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.grey,
                                                    ),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: FontStyles()
                                                            .FontFamily),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.blue,
                                                    ),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        dropdownValueDepartment =
                                                            newValue;
                                                      });
                                                    },
                                                    items: _resultDepartment
                                                                .length ==
                                                            0
                                                        ? <String>['0'].map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                            return DropdownMenuItem(
                                                              child: Text(
                                                                  '- เลือก -'),
                                                              value: value,
                                                            );
                                                          }).toList()
                                                        : _resultDepartment
                                                            .map((map) {
                                                            return DropdownMenuItem(
                                                              child: Text(
                                                                  map.SUBJECT),
                                                              value: map.ID,
                                                            );
                                                          }).toList(),
                                                  ),
                                                )
                                              : IgnorePointer(
                                                  child: Container(
                                                  child: DropdownButton<String>(
                                                    value:
                                                        dropdownValueDepartment,
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.grey,
                                                    ),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: FontStyles()
                                                            .FontFamily),
                                                    underline: Container(
                                                      height: 1,
                                                      color: Colors.grey[400],
                                                    ),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        dropdownValueDepartment =
                                                            newValue;
                                                      });
                                                    },
                                                    items: _resultDepartment
                                                                .length ==
                                                            0
                                                        ? <String>['0'].map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                            return DropdownMenuItem(
                                                              child: Text(
                                                                  '- เลือก -'),
                                                              value: value,
                                                            );
                                                          }).toList()
                                                        : _resultDepartment
                                                            .map((map) {
                                                            return DropdownMenuItem(
                                                              child: Text(
                                                                  map.SUBJECT),
                                                              value: map.ID,
                                                            );
                                                          }).toList(),
                                                  ),
                                                )),
                                        )
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(1)),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                child: Text(
                                              'เวลาทำงาน',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 22),
                                            ))),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: _edit
                                                ? DropdownButton(
                                                    value: dropdownValueTime,
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.grey,
                                                    ),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: FontStyles()
                                                            .FontFamily),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.blue,
                                                    ),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        dropdownValueTime =
                                                            newValue;
                                                      });
                                                    },
                                                    items: _itemTime.length == 0
                                                        ? <String>['0'].map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                            return DropdownMenuItem(
                                                              child: Text(
                                                                  '- เลือก -'),
                                                              value: value,
                                                            );
                                                          }).toList()
                                                        : _itemTime.map((map) {
                                                            return DropdownMenuItem(
                                                              child: Text(
                                                                  map.SUBJECT),
                                                              value: map.ID,
                                                            );
                                                          }).toList(),
                                                  )
                                                : IgnorePointer(
                                                    child: DropdownButton(
                                                      value: dropdownValueTime,
                                                      icon: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.grey,
                                                      ),
                                                      iconSize: 24,
                                                      elevation: 16,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily:
                                                              FontStyles()
                                                                  .FontFamily),
                                                      underline: Container(
                                                        height: 1,
                                                        color: Colors.grey[400],
                                                      ),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          dropdownValueTime =
                                                              newValue;
                                                        });
                                                      },
                                                      items: _itemTime.length ==
                                                              0
                                                          ? <String>['0'].map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                              return DropdownMenuItem(
                                                                child: Text(
                                                                    '- เลือก -'),
                                                                value: value,
                                                              );
                                                            }).toList()
                                                          : _itemTime
                                                              .map((map) {
                                                              return DropdownMenuItem(
                                                                child: Text(map
                                                                    .SUBJECT),
                                                                value: map.ID,
                                                              );
                                                            }).toList(),
                                                    ),
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(10)),
                                    Visibility(
                                      visible: _edit,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (_edit) {
                                                setState(() {
                                                  _edit = false;
                                                });
                                              }
                                              print('ยกเลิก');
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              padding: EdgeInsets.only(
                                                  left: 25, right: 25),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFC8C8C8),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Text(
                                                'ยกเลิก',
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontStyles().FontFamily,
                                                    color: Colors.black,
                                                    fontSize: 26),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                print('ถัดไป');
                                                EasyLoading.show();
                                                onUpdateProfile();
                                                if (_edit) {
                                                  setState(() {
                                                    _edit = false;
                                                  });
                                                }
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              padding: EdgeInsets.only(
                                                  left: 25, right: 25),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF079CFD),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Text(
                                                'ตกลง',
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
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          width: WidhtDevice().widht(context),
                          decoration: StylePage().boxWhite,
                          child: Column(
                            children: [
                              Visibility(
                                visible:
                                    widget.id_member == uid_my ? false : true,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              child: Text(
                                                'บทบาทในองค์กร',
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontStyles().FontFamily,
                                                    fontSize: 22),
                                              ),
                                            )),
                                            FlutterSwitch(
                                              value:
                                                  _switchAdmin ? true : false,
                                              width: 100.0,
                                              height: 40.0,
                                              valueFontSize: 12.0,
                                              toggleSize: 30.0,
                                              borderRadius: 20.0,
                                              padding: 5.0,
                                              showOnOff: true,
                                              activeText: 'ADMIN',
                                              activeColor: Colors.amber,
                                              inactiveText: 'MEMBER',
                                              inactiveColor: Colors.grey,
                                              onToggle: (state) {
                                                setState(() {
                                                  _switchAdmin = state;
                                                  Map _map = {
                                                    "uid": widget.id_member,
                                                    "key": "type",
                                                    "value":
                                                        _switchAdmin.toString(),
                                                  };
                                                  print(_map);
                                                  onLoadMemberStatusManage(
                                                      _map);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(2)),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      child: Text(
                                        'รายงานประจำวันในประวัติ',
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 22),
                                      ),
                                    )),
                                    FlutterSwitch(
                                      value: _switchStat ? true : false,
                                      width: 100.0,
                                      height: 40.0,
                                      valueFontSize: 16.0,
                                      toggleSize: 30.0,
                                      borderRadius: 20.0,
                                      padding: 5.0,
                                      showOnOff: true,
                                      activeText: 'ปกติ',
                                      activeColor: Colors.green,
                                      inactiveText: 'ไม่',
                                      inactiveColor: Colors.red,
                                      onToggle: (state) {
                                        setState(() {
                                          _switchStat = state;
                                          Map _map = {
                                            "uid": widget.id_member,
                                            "key": "stat",
                                            "value": _switchStat.toString(),
                                          };
                                          print(_map);
                                          onLoadMemberStatusManage(_map);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                              Visibility(
                                visible:
                                    widget.id_member == uid_my ? false : true,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        child: Text(
                                          'สถานะสมาชิก',
                                          style: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              fontSize: 22),
                                        ),
                                      )),
                                      FlutterSwitch(
                                        value: _switchStatus ? true : false,
                                        width: 100.0,
                                        height: 40.0,
                                        valueFontSize: 16.0,
                                        toggleSize: 30.0,
                                        borderRadius: 20.0,
                                        padding: 5.0,
                                        showOnOff: true,
                                        activeText: 'ใช้งาน',
                                        activeColor: Colors.green,
                                        inactiveText: 'ระงับ',
                                        inactiveColor: Colors.red,
                                        onToggle: (state) {
                                          setState(() {
                                            _switchStatus = state;
                                            Map _map = {
                                              "uid": widget.id_member,
                                              "key": "status",
                                              "value": _switchStatus.toString(),
                                            };
                                            print(_map);
                                            onLoadMemberStatusManage(_map);
                                          });
                                        },
                                      ),
                                    ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleClickFiles() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('อัพโหลดรูป',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                'รูปภาพ',
                textScaleFactor: 1.0,
              ),
              onPressed: () {
                // _openFileImagesExplorer();
                _imgFromGallery();
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'กล้อง',
                textScaleFactor: 1.0,
              ),
              onPressed: () {
                // _openCameraExplorer(ImageSource.camera, context: context);
                _imgFromCamera();
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text('ยกเลิก',
                textScaleFactor: 1.0, style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  _imgFromCamera() async {
    try {
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
        print(_pickImageError.toString());
      });
    }
  }

  _imgFromGallery() async {
    try {
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
        print(_pickImageError.toString());
      });
    }
  }
}
