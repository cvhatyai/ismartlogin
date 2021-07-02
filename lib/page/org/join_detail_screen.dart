import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';
import 'package:ismart_login/page/org/future/getJoinOrg_future.dart';
import 'package:ismart_login/page/org/join_member_screen.dart';
import 'package:ismart_login/page/org/model/getorglist.dart';
import 'package:ismart_login/page/org/model/newmemberorglist.dart';
import 'package:ismart_login/page/splashscreen/splashscreen_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';

class OrganizationJoinDetailScreen extends StatefulWidget {
  final ItemsGetOrgList itemsGetOrgList;
  OrganizationJoinDetailScreen({Key key, @required this.itemsGetOrgList})
      : super(key: key);
  @override
  _OrganizationJoinDetailScreenState createState() =>
      _OrganizationJoinDetailScreenState();
}

class _OrganizationJoinDetailScreenState
    extends State<OrganizationJoinDetailScreen> {
  FToast fToast;
  ItemsGetOrgList _itemsGetOrgList;
//-----
  @override
  void initState() {
    EasyLoading.dismiss();
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _itemsGetOrgList = widget.itemsGetOrgList;
    onLoadMemberManage();
  }

  ///-----member
  List<ItemsMemberResultManage> _itemMember = [];
  Future<bool> onLoadMemberManage() async {
    Map map = {
      "org_id": _itemsGetOrgList.ID,
      "status": '1',
    };
    await GetOrgFuture().apiGetMemberOrgList(map).then((onValue) {
      setState(() {
        if (onValue[0].STATUS) {
          _itemMember = onValue[0].RESULT;
        }
      });
    });
    EasyLoading.dismiss();
    setState(() {});
    return true;
  }

  ////  add to Org
  List<ItemsResultUpdateNewMember> _item = [];
  Future<bool> onLoadNewMemberOrg() async {
    Map map = {
      "uid": await SharedCashe.getItemsWay(name: 'id'),
      "org_id": _itemsGetOrgList.ID,
    };
    print(map);
    await GetOrgFuture().apiUpdateNewMemberOrgList(map).then((onValue) {
      setState(() {
        _item = onValue;
      });
      if (_item[0].RESULT == "success") {
        EasyLoading.showSuccess("เข้าร่วมแล้ว");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SplashscreenScreen(),
          ),
        );
      } else {
        EasyLoading.showError("ล้มเหลว");
      }
    });
    setState(() {});
    return true;
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
              padding: EdgeInsets.only(left: 20, right: 20),
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
                      _itemsGetOrgList.SUBJECT,
                      style: TextStyle(
                          fontFamily: FontStyles().FontFamily,
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                    backgroundColor: Colors.white.withOpacity(0),
                    elevation: 0,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 20),
                      width: WidhtDevice().widht(context),
                      decoration: StylePage().boxWhite,
                      child: Column(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 120,
                              height: 120,
                              color: Color(0xFFA6D6F2),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Center(
                                        child: Icon(
                                          Icons.work,
                                          size: 80,
                                          color: Colors.white,
                                        ),
                                        // : Image.file(
                                        //     File(_imageFile.path),
                                        //     fit: BoxFit.cover,
                                        //     width: 300.0,
                                        //     height: 300.0,
                                        //   ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Text(
                                      'รหัสทีม',
                                      style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 28,
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
                                      _itemsGetOrgList.INVITE_CODE
                                              .substring(0, 3) +
                                          " " +
                                          _itemsGetOrgList.INVITE_CODE
                                              .substring(3, 6) +
                                          " " +
                                          _itemsGetOrgList.INVITE_CODE
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
                          Divider(),
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrganizationJoinMemberScreen(
                                      items: _itemMember,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'สมาชิกทั้งหมด (' +
                                        (_itemMember.length > 0
                                            ? _itemMember.length.toString()
                                            : '0') +
                                        ')',
                                    style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 28,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFF0089DC),
                                    size: 28,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                onLoadNewMemberOrg();
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF0093E9),
                                        Color(0xFF36C2CF),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                                child: Text(
                                  'เข้าร่วมทีม',
                                  style: TextStyle(
                                      fontFamily: FontStyles().FontFamily,
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
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
}
