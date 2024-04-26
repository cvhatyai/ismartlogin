import 'package:flutter/material.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/style/text_style.dart';

import 'org_lock_time_form.dart';

class OrgLockTimeScreen extends StatefulWidget {
  @override
  _OrgLockTimeScreenState createState() => _OrgLockTimeScreenState();
}

class _OrgLockTimeScreenState extends State<OrgLockTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: StylePage().background,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
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
                          actions: [],
                          title: Text(
                            'ตั้งเวลาปุ่มเข้า-ออกงาน',
                            style: StylesText.titleAppBar,
                          ),
                          backgroundColor: Colors.white.withOpacity(0),
                          elevation: 0,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrgLockTimeFormScreen(
                                          title: "ตั้งเวลาปุ่มเข้างาน",
                                          statusBtn: "in",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "ปุ่มเข้างาน",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.black,
                                                  size: 18,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrgLockTimeFormScreen(
                                                        title:
                                                            "ตั้งเวลาปุ่มเข้างาน",
                                                        statusBtn: "in",
                                                      ),
                                                    ),
                                                  );
                                                  // Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrgLockTimeFormScreen(
                                          title: "ตั้งเวลาปุ่มออกงาน",
                                          statusBtn: "out",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "ปุ่มออกงาน",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.black,
                                                  size: 18,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrgLockTimeFormScreen(
                                                        title:
                                                            "ตั้งเวลาปุ่มออกงาน",
                                                        statusBtn: "out",
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
                                ),
                              ],
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
      ),
    );
  }
}
