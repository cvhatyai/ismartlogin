import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ismart_login/page/front/model/sumaryToDay_absence.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/widht_device.dart';

class FrontCountAbsenceScreen extends StatefulWidget {
  final List<ItemsSummaryToDay_Absence> items;
  FrontCountAbsenceScreen({Key key, @required this.items}) : super(key: key);
  @override
  _FrontCountAbsenceScreenState createState() =>
      _FrontCountAbsenceScreenState();
}

class _FrontCountAbsenceScreenState extends State<FrontCountAbsenceScreen> {
  List<ItemsSummaryToDay_Absence> _items;
  @override
  void initState() {
    EasyLoading.dismiss();
    _items = widget.items;
    super.initState();
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
              AppBar(
                centerTitle: true,
                title: Text(
                  'ยังไม่ลงเวลา',
                  style: TextStyle(
                      fontFamily: FontStyles().FontFamily,
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.white.withOpacity(0),
                elevation: 0,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  width: WidhtDevice().widht(context),
                  decoration: StylePage().boxWhite,
                  child: _items.length > 0
                      ? _list()
                      : Center(
                          child: Text(
                            '-- ไม่มีข้อมูล --',
                            style: TextStyle(
                                fontFamily: FontStyles().FontFamily,
                                fontSize: 24,
                                color: Colors.grey[400]),
                          ),
                        ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list() {
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        padding: EdgeInsets.all(8),
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _items[index].AVATAR != ''
                      ? Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          decoration: new BoxDecoration(
                            color: Color(0xFFF2F2F2),
                            image: DecorationImage(
                              image: NetworkImage(
                                  Server.url + _items[index].AVATAR),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          decoration: new BoxDecoration(
                            color: Color(0xFFF2F2F2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      _subFullname(_items[index].FULLNAME) +
                          (_items[index].NICKNAME != ''
                              ? ' (' + _items[index].NICKNAME + ')'
                              : ''),
                      style: TextStyle(
                          fontFamily: FontStyles().FontThaiSans, fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
