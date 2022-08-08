import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ismart_login/page/managements/model/itemMemberManage.dart';
import 'package:ismart_login/page/managements/model/itemMemberStatusManage.dart';
import 'package:ismart_login/server/server.dart';

final Map<String, String> header = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": "true",
  "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "*"
};

class MemberManageFuture {
  MemberManageFuture() : super();
  //---
  Future<List<ItemsMemberManage>> apiGetMemberManageList(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    print("body ${body}");
    final response = await http.post(
      Uri.parse(Server().getMemberManage),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      print(responseJson);
      return responseJson
          .map((m) => new ItemsMemberManage.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  Future<List<ItemsMemberStatusManage>> apiGetMemberStatusManageList(
      Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().updateMemberStatusManage),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      print(responseJson);
      return responseJson
          .map((m) => new ItemsMemberStatusManage.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  Future<List<ItemsMemberStatusManage>> insertInfoLeave(
      Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().insertInfoLeave),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      print(responseJson);
      return responseJson
          .map((m) => new ItemsMemberStatusManage.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }
}
