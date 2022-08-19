import 'package:flutter/material.dart';
import 'package:ismart_login/style/develop_blank.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/widht_device.dart';

class LeaveFreeScreen extends StatefulWidget {
  @override
  _LeaveFreeScreenState createState() => _LeaveFreeScreenState();
}

class _LeaveFreeScreenState extends State<LeaveFreeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      decoration: StylePage().background,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 20),
                  width: WidhtDevice().widht(context),
                  decoration: StylePage().boxWhite,
                  child: DevelopBlank.show(),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}