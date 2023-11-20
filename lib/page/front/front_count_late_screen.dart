import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ismart_login/page/front/model/sumaryToDay_late.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:loading_gifs/loading_gifs.dart';

class FrontCountLateScreen extends StatefulWidget {
  final List<ItemsSummaryToDay_Late> items;
  FrontCountLateScreen({Key key, @required this.items}) : super(key: key);
  @override
  _FrontCountLateScreenState createState() => _FrontCountLateScreenState();
}

class _FrontCountLateScreenState extends State<FrontCountLateScreen> {
  List<ItemsSummaryToDay_Late> _items;
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
                  'สาย',
                  style: TextStyle(
                      fontFamily: FontStyles().FontFamily,
                      fontSize: 30,
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
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.grey,
                    ),
                    Padding(padding: EdgeInsets.all(2)),
                    Expanded(
                      child: Container(
                        child: Text(
                          _subFullname(_items[index].FULLNAME) +
                              (_items[index].NICKNAME != ''
                                  ? ' (' + _items[index].NICKNAME + ')'
                                  : ''),
                          style: TextStyle(
                              fontFamily: FontStyles().FontThaiSans,
                              fontSize: 24,
                              height: 1),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          alert_show_images(context, 1, index);
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Image.network(
                                Server.url + _items[index].START_IMAGE_SMALL,
                                fit: BoxFit.cover,
                                width: WidhtDevice().widht(context) / 2,
                              ),
                              // child: FadeInImage.assetNetwork(
                              //   placeholder: cupertinoActivityIndicatorSmall,
                              //   placeholderScale: 5,
                              //   width: WidhtDevice().widht(context) / 2,
                              //   image: Server.url + _items[index].START_IMAGE_SMALL,
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                            Container(
                              child: Text(
                                _items[index].DESCRIPTION,
                                style: TextStyle(
                                    fontFamily: FontStyles().FontThaiSans,
                                    fontSize: 20,
                                    height: 1),
                              ),
                            ),
                            _items[index].START_NOTE != ''
                                ? Container(
                                    alignment: Alignment.center,
                                    width: WidhtDevice().widht(context) / 3.5,
                                    child: Text(
                                      _items[index].START_NOTE,
                                      style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 18,
                                          height: 1,
                                          color: Colors.red[200]),
                                    ),
                                  )
                                : Container(
                                    height: 0,
                                  ),
                            _items[index].START_LOCATION_STATUS == '1'
                                ? GestureDetector(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: WidhtDevice().widht(context) / 3.5,
                                      child: Text(
                                        'ไม่อยู่ในพื้นที่ : ' +
                                            _items[index]
                                                .START_LOCATION_SUB_STATUS
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily: FontStyles().FontFamily,
                                            fontSize: 18,
                                            height: 1,
                                            color: Colors.red[200]),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 0,
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(2)),
                    Expanded(
                      child: _items[index].END_TIME == ''
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                alert_show_images(context, 2, index);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    // child: FadeInImage.assetNetwork(
                                    //   placeholder: cupertinoActivityIndicatorSmall,
                                    //   placeholderScale: 5,
                                    //   width: WidhtDevice().widht(context) / 2,
                                    //   image: Server.url +
                                    //       _items[index].END_IMAGE_SMALL,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    child: Image.network(
                                      Server.url +
                                          _items[index].END_IMAGE_SMALL,
                                      fit: BoxFit.cover,
                                      width: WidhtDevice().widht(context) / 2,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      _items[index].END_TIME + ' น.',
                                      style: TextStyle(
                                          fontFamily: FontStyles().FontThaiSans,
                                          fontSize: 20),
                                    ),
                                  ),
                                  _items[index].END_STATUS != '0'
                                      ? Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Text(
                                                  _getEndStatus(
                                                      _items[index].END_STATUS),
                                                  style: TextStyle(
                                                      fontFamily: FontStyles()
                                                          .FontFamily,
                                                      fontSize: 18,
                                                      height: 1,
                                                      color: Colors.red[200]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _getStatusLocation(String _status) {
    String _txt = '';
    if (_status != '' && _status != null) {
      List _list = json.decode(_status);
      List _checkboxListTile = ['โปรแกรมระบุตำแหน่งผิดพลาด', 'ทำงานนอกสถานที่'];
      if (_list.length > 0) {
        for (int i = 0; i < _list.length; i++) {
          _txt += _checkboxListTile[int.parse(_list[i])] + ', ';
        }
      }
    }

    return _txt;
  }

  _getEndStatus(String _status) {
    String _txt = '';
    print("getEndStatus : ${int.parse(_status) - 1}");
    if (_status != '' && _status != '0') {
      List _checkboxListTile = ['ออกงานก่อนเวลา','ออกงานก่อนเวลา','ออกงานก่อนเวลา'];
      _txt = _checkboxListTile[int.parse(_status) - 1];
    }
    return _txt;
  }

  alert_show_images(BuildContext context, int _status, int index) async {
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 3),
                  alignment: Alignment.center,
                  child: Image.network(
                    Server.url +
                        (_status == 1
                            ? _items[index].START_IMAGE
                            : _items[index].END_IMAGE),
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      return Center(
                        child: FadeInImage.assetNetwork(
                          placeholder: cupertinoActivityIndicatorSmall,
                          placeholderScale: 5,
                          image: Server.url +
                              (_status == 1
                                  ? _items[index].START_IMAGE
                                  : _items[index].END_IMAGE),
                        ),
                      );
                    },
                  ),
                ),
                _status == 1
                    ? Container(
                        child: Container(
                          child: Text(
                            'วันที่ ' +
                                _items[index].CREATE_DATE_TH +
                                ' เวลา ' +
                                _items[index].START_TIME,
                            style: TextStyle(
                                fontFamily: FontStyles().FontFamily,
                                fontSize: 24,
                                color: Colors.black),
                          ),
                        ),
                      )
                    : Container(
                        child: Container(
                          child: Text(
                            'วันที่ ' +
                                _items[index].CREATE_DATE_TH +
                                ' เวลา ' +
                                _items[index].END_TIME,
                            style: TextStyle(
                              fontFamily: FontStyles().FontFamily,
                              fontSize: 24,
                              color: (_items[index].END_STATUS == '0'
                                  ? Colors.black
                                  : Colors.redAccent),
                            ),
                          ),
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
