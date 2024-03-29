import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ismart_login/page/sign/signin_screen.dart';
import 'package:ismart_login/page/sign/signout_popup.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class UserDeleteView extends StatefulWidget {
  const UserDeleteView({Key key}) : super(key: key);

  @override
  State<UserDeleteView> createState() => _UserDeleteViewState();
}

class _UserDeleteViewState extends State<UserDeleteView> {
  // User user = User();
  bool acceptAgreement = false;
  String uid = '';

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  _getMyUid() async {
    uid = await SharedCashe.getItemsWay(name: 'id');
  }

  getUsers() async {
    EasyLoading.show(status: 'loading...');
    // await user.init();
    _getMyUid();
    EasyLoading.dismiss();
  }

  Future<void> submitDelete() async {
    if (!acceptAgreement) {
      return;
    }
    var result = await userDetete();
    if (result['status'] == 'success') {
      SharedCashe.clearShaeredForLogout();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    }
    Toast.show(result['msg'], context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  Future<Map<String, dynamic>> userDetete() async {
    final http.Response response = await http.post(
      Uri.parse(Server().userDelete),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, String>{
        'uid': uid,
      }),
    );

    if (response.statusCode != 200) {
      return {'status': 'failed', 'msg': 'ไม่สามารถดำเนินการได้'};
    }

    final data = json.decode(response.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ลบบัญชี',
            style: TextStyle(
                fontFamily: FontStyles().FontFamily,
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Image(
                    image: AssetImage("assets/images/other/alert-yellow.png"),
                    width: 44,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'หากลบบัญชี จะทำให้\nข้อมูลทั้งหมดถูกลบอย่างถาวร\nข้อมูลที่ถูกลบจะไม่สามารถกู้คืนได้',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
                  child: Divider(thickness: 1),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: acceptAgreement,
                      activeColor: Colors.blue,
                      onChanged: (bool value) {
                        setState(() {
                          acceptAgreement = value;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'ฉันรับทราบว่าข้อมูลทั้งหมดของฉันจะถูกลบ อย่างถาวร',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: submitDelete,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: acceptAgreement ? Colors.blue : Color(0xFFD3D7E2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text('ยืนยัน',
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                acceptAgreement ? Colors.white : Colors.black,
                          )),
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

class UserDeleteDialog extends StatelessWidget {
  const UserDeleteDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 70, 20, 20),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: const Text(
                'ลบบัญชี',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 24, 12, 24),
              child: Text(
                'หากลบบัญชี\nคุณจะไม่สามารถเข้าสู่ระบบได้อีกต่อไป\nต้องการดำเนินการต่อหรือไม่',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFFFD60A)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'ยกเลิก',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    'ยืนยัน',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
