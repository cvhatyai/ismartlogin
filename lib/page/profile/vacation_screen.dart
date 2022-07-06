import 'package:flutter/material.dart';
import 'package:ismart_login/page/profile/login.dart';
import 'package:ismart_login/page/profile/register.dart';
import 'package:ismart_login/style/font_style.dart';

import '../main.dart';

class VacationScreen extends StatefulWidget {
  @override
  _VacationScreenState createState() => _VacationScreenState();
}

class _VacationScreenState extends State<VacationScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ลา",
          style: TextStyle(
              fontFamily: FontStyles().FontFamily,
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return RegisterScreen();
                      }
                      ));
                  },
                  icon: Icon(Icons.person),
                  label: Text("สร้างบัญชีผู้ใช้"),
                
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return LoginScreen();
                      }
                      ));
                  },
                  icon: Icon(Icons.login),
                  label: Text("เข้าสู่ระบบ")),
            )
          ],
        ),
      ),
    );
  }
}
