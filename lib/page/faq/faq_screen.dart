import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ismart_login/page/faq/future/faq_future.dart';
import 'package:ismart_login/page/faq/model/listFaq.dart';
import 'package:ismart_login/page/faq/model/listFaqResult.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';
import 'package:ismart_login/system/widht_device.dart';

class Faq extends StatefulWidget {
  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  @override
  void initState() {
    super.initState();
    onLoadGetFaq();
  }

  List<ListFaq> _result = [];
  Future<bool> onLoadGetFaq() async {
    Map map = {};
    await FaqFuture().apiGetFaqList(map).then((onValue) {
      if (onValue[0].STATUS) {
        setState(() {
          _result = onValue[0].RESULT;
        });
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
                          onPressed: () => Navigator.pop(context, true),
                        ),
                        title: Text(
                          'คำถามที่พบบ่อย',
                          style: StylesText.titleAppBar,
                        ),
                        backgroundColor: Colors.white.withOpacity(0),
                        elevation: 0,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            width: WidhtDevice().widht(context),
                            decoration: StylePage().boxWhite,
                            child: _result.length > 0
                                ? ListView.builder(
                                    padding: EdgeInsets.all(8),
                                    itemCount: _result.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // color: listColor[index % 3],
                                          border: Border.all(
                                            color: Color(0xFFC4C4C4),
                                          ),
                                        ),
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: ExpansionTile(
                                          title: Row(
                                            children: [
                                              Container(
                                                width: 13,
                                                height: 13,
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.blue,
                                                        width: 3.0),
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    _result[index].SUBJECT,
                                                    style: TextStyle(
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: <Widget>[
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Html(
                                                            data: '' +
                                                                _result[index]
                                                                    .DESCRIPTION +
                                                                ''),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "สร้างเมื่อ " +
                                                            _result[index]
                                                                .CREATE_DATE,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FontStyles()
                                                                  .FontFamily,
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        "แก้ไขเมื่อ " +
                                                            _result[index]
                                                                .UPDATE_DATE,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FontStyles()
                                                                  .FontFamily,
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      " -- ไม่มีข้อมูล --",
                                      style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 22,
                                        color: Colors.grey,
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
            ],
          ),
        ),
      ),
    );
  }
}
