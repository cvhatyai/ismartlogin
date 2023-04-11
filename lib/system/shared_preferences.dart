import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ismart_login/page/sign/model/memberlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedCashe {
  static saveItemsMemberList({List<dynamic> item}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listString = json.encode(item[0]);

    Map _map = json.decode(listString);
    print(_map);
    List<dynamic> _key = _map.keys.toList();
    List<dynamic> _val = _map.values.toList();
    for (int i = 0; i < _map.keys.length; i++) {
      prefs.setString(_key[i], _val[i] == null ? "" : _val[i]);
    }
    prefs.setString('item', json.encode(item));
  }

  getItemsMemberList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String item = prefs.getString('item');
    return item;
  }

  static getItemsWay({String name}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String item = prefs.getString(name);
    print(item);
    return item;
  }

  static Future<bool> getItemsBoolWay({String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool item = prefs.getBool(key);
    print(item);
    return item;
  }

  static savaItemsString({String key, String valString}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, valString);
    print(prefs.getString(key));
  }

  static savaItemsBool({String key, bool valBool}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, valBool);
    print(prefs.getBool(key));
  }

  static clearShaeredAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = await SharedCashe.getItemsWay(name: 'id');
    var orgSubId = await SharedCashe.getItemsWay(name: 'org_sub_id');
    //unsubscribe
    FirebaseMessaging.instance.unsubscribeFromTopic("org_" + orgSubId);
    FirebaseMessaging.instance.unsubscribeFromTopic("users_" + uid);

    if (Platform.isIOS) {
      FirebaseMessaging.instance
          .unsubscribeFromTopic("com.cityvariety.ismartlogin");
    } else {
      FirebaseMessaging.instance
          .unsubscribeFromTopic("com.cityvariety.ismart_login");
    }
    FirebaseMessaging.instance.unsubscribeFromTopic("news");

    await prefs.clear();
  }

  static clearShaeredForLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var uid = await SharedCashe.getItemsWay(name: 'id');
    var orgSubId = await SharedCashe.getItemsWay(name: 'org_sub_id');

    //unsubscribe
    FirebaseMessaging.instance.unsubscribeFromTopic("org_" + orgSubId);
    FirebaseMessaging.instance.unsubscribeFromTopic("users_" + uid);

    prefs.getKeys();
    for (String key in prefs.getKeys()) {
      if (key != "setProtect" && key != "keyInvite") {
        prefs.remove(key);
      }
    }

    if (Platform.isIOS) {
      FirebaseMessaging.instance
          .unsubscribeFromTopic("com.cityvariety.ismartlogin");
    } else {
      FirebaseMessaging.instance
          .unsubscribeFromTopic("com.cityvariety.ismart_login");
    }
    FirebaseMessaging.instance.unsubscribeFromTopic("news");
  }
}
