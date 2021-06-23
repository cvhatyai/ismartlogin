import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ismart_login/page/managements/future/department_manage_future.dart';
import 'package:ismart_login/page/managements/future/member_manage_future.dart';
import 'package:ismart_login/page/managements/future/time_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemDepartmentResultManage.dart';
import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeResultMange.dart';
import 'package:ismart_login/page/profile/future/profile_future.dart';
import 'package:ismart_login/page/profile/password_screen.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/develop_blank.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  //Setup
  PickedFile _imageFile;
  dynamic _pickImageError;

  ///
  bool _edit = false;
  String uid = '';
  String avatar = '';

  ///
  TextEditingController _inputName = TextEditingController();
  TextEditingController _inputLastname = TextEditingController();
  TextEditingController _inputNickname = TextEditingController();

  ///
  ///
  String dropdownValueTime = '0';
  String dropdownValueDepartment = '0';

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
  ///-----member
  List<ItemsMemberResultManage> _item = [];
  Future<bool> onLoadMemberManage() async {
    Map map = {
      "org_id": await SharedCashe.getItemsWay(name: 'org_id'),
      "uid": await SharedCashe.getItemsWay(name: 'id'),
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

  _getData() async {
    String fullname = _item[0].FULLNAME;
    String _nickname = _item[0].NICKNAME;
    String _uid = await SharedCashe.getItemsWay(name: 'id');
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
    });
  }

  Future<dynamic> onUpdateProfile() async {
    await ProfileFuture().updateProfile(
      file: _imageFile != null ? _imageFile.path : '',
      uid: uid,
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

    onLoadGetAllTime();
    onLoadGetAllDepartment();
    onLoadMemberManage();
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
            child: Container(
              child: Column(
                children: [
                  AppBar(
                    centerTitle: true,
                    title: Text(
                      'ข้อมูลส่วนตัว',
                      style: TextStyle(
                          fontFamily: FontStyles().FontFamily,
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.white.withOpacity(0),
                    elevation: 0,
                  ),
                  SingleChildScrollView(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                                    width:
                                                                        300.0,
                                                                    height:
                                                                        300.0,
                                                                  )
                                                                : _imageFile ==
                                                                        null
                                                                    ? Icon(
                                                                        Icons
                                                                            .person,
                                                                        size:
                                                                            140,
                                                                        color: Colors
                                                                            .white,
                                                                      )
                                                                    : Image
                                                                        .file(
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
                                                      _edit
                                                          ? Container(
                                                              height: 33.0,
                                                              width: double
                                                                  .infinity,
                                                              color: Color(
                                                                  0xFF7B7B7B),
                                                              child: Center(
                                                                child:
                                                                    Container(
                                                                  child: Text(
                                                                      'แก้ไขรูปภาพ',
                                                                      textScaleFactor:
                                                                          1.0,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              18.0,
                                                                          fontFamily: FontStyles()
                                                                              .FontFamily),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
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
                                                keyboardType:
                                                    TextInputType.name,
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
                                                    fontFamily: FontStyles()
                                                        .FontThaiSans,
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
                                                keyboardType:
                                                    TextInputType.name,
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
                                                    child:
                                                        DropdownButton<String>(
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
                                                          fontFamily:
                                                              FontStyles()
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
                                                          print('สาขา' +
                                                              dropdownValueDepartment);
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
                                                                child: Text(map
                                                                    .SUBJECT),
                                                                value: map.ID,
                                                              );
                                                            }).toList(),
                                                    ),
                                                  )
                                                : IgnorePointer(
                                                    child: Container(
                                                    child:
                                                        DropdownButton<String>(
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
                                                          fontFamily:
                                                              FontStyles()
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
                                                                child: Text(map
                                                                    .SUBJECT),
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
                                                        value:
                                                            dropdownValueTime,
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
                                                          height: 2,
                                                          color: Colors.blue,
                                                        ),
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            dropdownValueTime =
                                                                newValue;
                                                          });
                                                          print('เวลา' +
                                                              dropdownValueTime);
                                                        },
                                                        items: _itemTime
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
                                                            : _itemTime
                                                                .map((map) {
                                                                return DropdownMenuItem(
                                                                  child: Text(map
                                                                      .SUBJECT),
                                                                  value: map.ID,
                                                                );
                                                              }).toList(),
                                                      )
                                                    : IgnorePointer(
                                                        child: DropdownButton(
                                                          value:
                                                              dropdownValueTime,
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: Colors.grey,
                                                          ),
                                                          iconSize: 24,
                                                          elevation: 16,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  FontStyles()
                                                                      .FontFamily),
                                                          underline: Container(
                                                            height: 1,
                                                            color: Colors
                                                                .grey[400],
                                                          ),
                                                          onChanged:
                                                              (newValue) {
                                                            setState(() {
                                                              dropdownValueTime =
                                                                  newValue;
                                                            });
                                                          },
                                                          items: _itemTime
                                                                      .length ==
                                                                  0
                                                              ? <String>[
                                                                  '0'
                                                                ].map<
                                                                  DropdownMenuItem<
                                                                      String>>((String
                                                                  value) {
                                                                  return DropdownMenuItem(
                                                                    child: Text(
                                                                        '- เลือก -'),
                                                                    value:
                                                                        value,
                                                                  );
                                                                }).toList()
                                                              : _itemTime
                                                                  .map((map) {
                                                                  return DropdownMenuItem(
                                                                    child: Text(
                                                                        map.SUBJECT),
                                                                    value:
                                                                        map.ID,
                                                                  );
                                                                }).toList(),
                                                        ),
                                                      )),
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
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
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
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
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
                                Divider(),
                                Padding(padding: EdgeInsets.all(10)),
                                // GestureDetector(
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => PasswordChange(),
                                //       ),
                                //     );
                                //   },
                                //   child: Text(
                                //     'เปลี่ยนรหัสผ่าน',
                                //     style: TextStyle(
                                //       fontFamily: FontStyles().FontFamily,
                                //       fontSize: 24,
                                //       color: Colors.blue,
                                //       fontWeight: FontWeight.bold,
                                //       decoration: TextDecoration.underline,
                                //     ),
                                //   ),
                                // ),
                                Padding(padding: EdgeInsets.all(10)),
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
