import 'package:flutter/material.dart';
import 'package:ismart_login/page/contact_dev/formdev_plugin.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDeveloper extends StatefulWidget {
  @override
  _ContactDeveloperState createState() => _ContactDeveloperState();
}

class _ContactDeveloperState extends State<ContactDeveloper> {
  TextStyle _txt_phone = TextStyle(
      fontFamily: FontStyles().FontFamily,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: StylePage().background,
        child: SafeArea(
          child: SingleChildScrollView(
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
                    "ติดต่อผู้พัฒนา",
                    style: TextStyle(
                        fontFamily: FontStyles().FontFamily,
                        fontSize: 38,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                  backgroundColor: Colors.white.withOpacity(0),
                  elevation: 0,
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Developer(),
                          Padding(padding: EdgeInsets.all(5)),
                          Container(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              width: WidhtDevice().widht(context),
                              decoration: StylePage().boxWhite,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      'บริษัท ซิตี้วาไรตี้ คอร์เปอเรชั่น จำกัด',
                                      style: TextStyle(
                                        fontFamily: FontStyles().FontFamily,
                                        color: Colors.blueAccent,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'โทร ',
                                          style: _txt_phone,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launch("tel:+66864908961");
                                          },
                                          child: Text(
                                            '086-4908961 (คุณมิน)',
                                            style: TextStyle(
                                              fontFamily:
                                                  FontStyles().FontFamily,
                                              fontSize: 20,
                                              color: Colors.grey,
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
                        ],
                      ),
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
