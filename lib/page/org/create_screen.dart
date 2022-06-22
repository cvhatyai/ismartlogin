import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ismart_login/page/managements/future/org_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemOrgManage.dart';
import 'package:ismart_login/page/managements/org_manage_screen.dart';
import 'package:ismart_login/page/managements/org_screen.dart';
import 'package:ismart_login/page/org/future/getJoinOrg_future.dart';
import 'package:ismart_login/page/org/model/itemSwitchOrg.dart';
import 'package:ismart_login/page/splashscreen/splashscreen_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

Completer<GoogleMapController> _controller = Completer();

class OrganizationCreateScreen extends StatefulWidget {
  final String type;
  final String title;
  final String id;
  final String invite;
  final bool action;
  OrganizationCreateScreen(
      {Key key,
      @required this.type,
      this.title,
      this.id,
      this.invite,
      this.action})
      : super(key: key);
  _OrganizationCreateScreenState createState() =>
      _OrganizationCreateScreenState();
}

class _OrganizationCreateScreenState extends State<OrganizationCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey globalKey = new GlobalKey();
  String _presetOrgId = "";
  FToast fToast;
  TimeOfDay _timeOfDay = TimeOfDay.now();
  //
  TextEditingController _inputSubject = TextEditingController();
  FocusNode _focusSubject = FocusNode();
//-----
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    print(widget.id);
    fToast = FToast();
    fToast.init(context);
    if (widget.type == 'update') {
      _inputSubject.text = widget.title;
    }
  }

  _releaseData() async {
    String _subject = _inputSubject.text;

    Map _map = {
      "subject": _subject,
      "type": widget.type == "insert" ? widget.type : "update",
      "id": widget.type == "insert" ? "0" : widget.id,
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    print(_map);
    onLoadPostUpdateOrg(_map);
  }

  //---
  List<ItemsOrgPostManage> _resultOrgPost = [];
  Future<bool> onLoadPostUpdateOrg(Map map) async {
    await OrgManageFuture().apiPostOrgManageList(map).then((onValue) async {
      if (onValue[0].STATUS == true) {
        EasyLoading.showSuccess('สร้างเรียบร้อย');
        if (widget.type == "update") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrgManageScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SplashscreenScreen(),
            ),
          );
        }
      } else {
        EasyLoading.showError('ล้มเหลว');
      }
    });
    return true;
  }

  ///-----
  List<ItemsSwitchOrg> _resultSwitch = [];
  Future<bool> onLoadUpdateSwitchOrg() async {
    Map map = {
      "uid": await SharedCashe.getItemsWay(name: 'id'),
      "org_id": widget.id,
    };
    await GetOrgFuture().apiUpdateSwitchOrgList(map).then((onValue) async {
      if (onValue[0].STATUS == "true") {
        EasyLoading.showSuccess('สลับแล้ว');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SplashscreenScreen(),
          ),
        );
      } else {
        EasyLoading.showError('ล้มเหลว');
      }
    });
    return true;
  }

  _requestPermission() async {
    Map<Permission, dynamic> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print(info);
  }

  ///-----
  Future<void> _captureAndSharePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData>);

    if (byteData != null) {
      final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List(),
          quality: 80,
          name: "invitecode_" + widget.id);
      print(result);
      if (result['filePath'] != "") {
        EasyLoading.showSuccess("บันทึกลง Gallery แล้ว");
      } else {
        EasyLoading.showError("ล้มเหลว");
      }
    }
  }

  Future<void> _captureAndShareOtherPng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData = await (image.toByteData(
          format: ui.ImageByteFormat.png) as FutureOr<ByteData>);

      if (byteData != null) {
        final Uint8List list = byteData.buffer.asUint8List();

        final tempDir = await getTemporaryDirectory();
        final file =
            await new File('${tempDir.path}/invitecode_' + widget.id + '.png')
                .create();
        file.writeAsBytesSync(list);
        String _text = '''
      iSmartLogin ได้เชิญท่านเข้าร่วม ทีม/องค์กร"${widget.title}"\n
      โดยการสแกน QrCode(คิวอาร์โค๊ด) หรือกรอกรหัส ${widget.invite}\n
      ** สำหรับสมาชิกที่ลงทะเบียนใหม่
      ''';
        Share.shareFiles([file.path], text: _text);
      }
    } catch (error) {
      print(error);
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  widget.title,
                  style: TextStyle(
                      fontFamily: FontStyles().FontFamily,
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
                actions: [
                  // action button
                  widget.type == "update_1"
                      ? IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrganizationCreateScreen(
                                  type: 'insert',
                                  title: 'สร้างทีม/องค์กรใหม่',
                                  invite: "000000000",
                                  id: '0',
                                  action: true,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                ],
                backgroundColor: Colors.white.withOpacity(0),
                elevation: 0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
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
                            hintText: 'ชื่อทีม/องค์กร',
                            hintStyle: TextStyle(
                                fontFamily: FontStyles().FontFamily,
                                fontSize: 24),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(
                                  0), // add padding to adjust icon
                              child: Icon(
                                Icons.work,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_inputSubject.text == '') {
                                  alert(context, 'กรุณาป้อนข้อมูลให้ครบถ้วน');
                                } else {
                                  if (_formKey.currentState.validate()) {
                                    print('สร้าง');
                                    if (widget.type == "insert") {
                                      alert_new_org(context,
                                          'คุณต้องการสร้างทีม/องค์กร\n"${_inputSubject.text}"\nใช่หรือไม่ ?');
                                    } else {
                                      _releaseData();
                                    }
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 25),
                                decoration: BoxDecoration(
                                  color: Color(0xFF079CFD),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  widget.type == "insert" ? "สร้าง" : "บันทึก",
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
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
              ),
              Padding(padding: EdgeInsets.all(10)),
              Expanded(
                child: Visibility(
                  visible: widget.type == "insert" ? false : true,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 20),
                      width: WidhtDevice().widht(context),
                      decoration: StylePage().boxWhite,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            margin: EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Text(
                                      'รหัสทีม',
                                      style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 26,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, right: 15, left: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.invite.toString().substring(0, 3) +
                                          " " +
                                          widget.invite
                                              .toString()
                                              .substring(3, 6) +
                                          " " +
                                          widget.invite
                                              .toString()
                                              .substring(6, 9),
                                      style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 26,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                GestureDetector(
                                  onTap: () {
                                    // ClipboardManager.copyToClipBoard(
                                    //         "your text to copy")
                                    //     .then((result) {
                                    //   _showToast();
                                    // });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      child: Icon(Icons.copy_sharp)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 25, right: 25),
                              child: Center(
                                child: RepaintBoundary(
                                  key: globalKey,
                                  child: QrImage(
                                    backgroundColor: Colors.white,
                                    data: "${widget.invite}",
                                    version: QrVersions.auto,
                                    embeddedImage: AssetImage(
                                        'assets/images/other/logo_app.png'),
                                    embeddedImageStyle: QrEmbeddedImageStyle(
                                      size: Size(80, 80),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _captureAndSharePng,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF079CFD),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.save,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "บันทึก",
                                            style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                color: Colors.white,
                                                fontSize: 24),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _captureAndShareOtherPng,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF079CFD),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.share,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "แบ่งปัน",
                                            style: TextStyle(
                                                fontFamily:
                                                    FontStyles().FontFamily,
                                                color: Colors.white,
                                                fontSize: 24),
                                          ),
                                        ],
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
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Visibility(
                visible: widget.type == "insert"
                    ? false
                    : widget.type == 'update' && !widget.action
                        ? true
                        : false,
                child: GestureDetector(
                  onTap: () {
                    onLoadUpdateSwitchOrg();
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 20),
                      width: WidhtDevice().widht(context),
                      decoration: StylePage().boxWhite,
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.retweet,
                                color: Colors.white,
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                              Text(
                                'ใช้งานบน ทีม/องค์กร นี้',
                                style: TextStyle(
                                  fontFamily: FontStyles().FontFamily,
                                  fontSize: 28,
                                  color: Colors.white,
                                  height: 1,
                                ),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showToast() async {
    // this will be our toast UI
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.copy,
            color: Colors.white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            'คัดลอกแล้ว',
            style: TextStyle(
                fontFamily: FontStyles().FontFamily,
                fontSize: 22,
                color: Colors.white),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );
  }

  alert(BuildContext context, String text) async {
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
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 3),
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 24,
                        height: 1),
                    textAlign: TextAlign.center,
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
                                bottomRight: Radius.circular(20.0),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  alert_new_org(BuildContext context, String text) async {
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
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 3),
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 24,
                        height: 1),
                    textAlign: TextAlign.center,
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
                              color: Colors.red[100],
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
                            _releaseData();
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
                              'ใช่/ตกลง',
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
    );
  }
}
