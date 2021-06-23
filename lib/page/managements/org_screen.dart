import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/managements/future/org_manage_future.dart';
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
                          onPressed: () => Navigator.of(context).pop(),
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrganizationCreateScreen(
                                        type: 'update',
                                        title: _item[index].SUBJECT,
                                        id: _item[index].ID,
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
}
