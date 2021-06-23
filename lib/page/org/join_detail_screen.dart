import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/widht_device.dart';

class OrganizationJoinDetailScreen extends StatefulWidget {
  @override
  _OrganizationJoinDetailScreenState createState() =>
      _OrganizationJoinDetailScreenState();
}

class _OrganizationJoinDetailScreenState
    extends State<OrganizationJoinDetailScreen> {
  FToast fToast;
//-----
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
                      '',
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
                                        top: 5, bottom: 5, right: 20, left: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '128 556 555',
                                      style: TextStyle(
                                          fontFamily: FontStyles().FontFamily,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
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
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue[100],
                                    ),
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, top: 5, bottom: 5),
                                    child: Text(
                                      'คัดลอก',
                                      style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        fontSize: 26,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          Container(
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'สมาชิกทั้งหมด (50)',
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
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         OrganizationJoinDetailScreen(),
                                //   ),
                                // );
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
