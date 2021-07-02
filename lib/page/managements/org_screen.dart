import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/main.dart';
import 'package:ismart_login/page/managements/future/org_manage_future.dart';
import 'package:ismart_login/page/managements/model/itemOrgManage.dart';
import 'package:ismart_login/page/managements/model/itemOrgResultManage.dart';
import 'package:ismart_login/page/org/create_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:ismart_login/system/widht_device.dart';

class OrgManageScreen extends StatefulWidget {
  @override
  _OrgManageScreenState createState() => _OrgManageScreenState();
}

class _OrgManageScreenState extends State<OrgManageScreen> {
  ///-----member
  List<ItemsOrgResultManage> _item = [];
  Future<bool> onLoadOrgManage() async {
    Map map = {
      "uid": await SharedCashe.getItemsWay(name: 'id'),
    };
    await OrgManageFuture().apiGetOrgManageList(map).then((onValue) {
      setState(() {
        if (onValue[0].STATUS) {
          _item = onValue[0].RESULT;
        }
      });
    });
    setState(() {});
    return true;
  }

  ///-----member
  List<ItemsOrgSuspendManage> _itemSuspend = [];
  Future<bool> onLoadSuspendOrgManage(String org_id) async {
    Map map = {
      "uid": await SharedCashe.getItemsWay(name: 'id'),
      "org_id": org_id,
    };
    print(map);
    await OrgManageFuture().apiUpdateSuspendOrgManageList(map).then((onValue) {
      setState(() {
        if (onValue[0].STATUS) {
          _itemSuspend = onValue;
          EasyLoading.dismiss();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrgManageScreen(),
            ),
          );
          EasyLoading.showSuccess("ลบแล้ว");
        } else {
          EasyLoading.showError("ล้มเหลว");
        }
      });
    });
    setState(() {});
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoadOrgManage();
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(),
                              ),
                            );
                          },
                        ),
                        actions: [
                          // action button
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrganizationCreateScreen(
                                    type: 'insert',
                                    title: 'สร้างทีม/องค์กรใหม่',
                                    id: '0',
                                    invite: "000000000",
                                    action: true,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                        title: Text(
                          'จัดการองค์กร',
                          style: StylesText.titleAppBar,
                        ),
                        backgroundColor: Colors.white.withOpacity(0),
                        elevation: 0,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: ListView.builder(
                            itemCount: _item.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onLongPress: () {
                                  if (!_item[index].ACTIVE) {
                                    alert_null(context, _item[index].SUBJECT,
                                        _item[index].ORG_ID);
                                  }
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrganizationCreateScreen(
                                        type: 'update',
                                        title: _item[index].SUBJECT,
                                        id: _item[index].ORG_ID,
                                        invite: _item[index].INVITE,
                                        action: _item[index].ACTIVE,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10, top: 5),
                                  width: WidhtDevice().widht(context),
                                  decoration: StylePage().boxWhite,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(padding: EdgeInsets.all(2)),
                                          FaIcon(
                                            FontAwesomeIcons.building,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          Padding(padding: EdgeInsets.all(1)),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 3, right: 3),
                                              child: Text(
                                                _item[index].SUBJECT,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontStyles().FontFamily,
                                                  fontSize: 24,
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
                                          _item[index].ACTIVE
                                              ? Container(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.done,
                                                        size: 16,
                                                        color: Colors.green,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          'คุณกำลังใช้งานอยู่',
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
                                                )
                                              : Container(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.done,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          'คุณกำลังใช้งานอยู่',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FontStyles()
                                                                    .FontFamily,
                                                            fontSize: 18,
                                                            height: 1,
                                                            color: Colors.white,
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

  alert_null(BuildContext context, String title, String org_id) async {
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
                  alignment: Alignment.center,
                  height: 100,
                  child: Text(
                    'คุณต้องการระงับทีม/องค์กร "' + title + '" หรือไม่ ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1,
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
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
                            onLoadSuspendOrgManage(org_id);
                            EasyLoading.show();
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
    );
  }
}
