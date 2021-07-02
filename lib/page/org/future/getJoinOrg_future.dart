import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ismart_login/page/managements/model/itemMemberManage.dart';
import 'package:ismart_login/page/org/model/getorgresult.dart';
import 'package:ismart_login/page/org/model/itemSwitchOrg.dart';
import 'package:ismart_login/page/org/model/newmemberorglist.dart';
import 'package:ismart_login/server/server.dart';

final Map<String, String> header = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": "true",
  "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "*"
};

class GetOrgFuture {
  GetOrgFuture() : super();
  //---
  Future<List<ItemsGetOrgResult>> apiGetOrganization(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().getOrg),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson
          .map((m) => new ItemsGetOrgResult.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  ///-----
  Future<List<ItemsMemberManage>> apiGetMemberOrgList(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
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

  ///-----
  Future<List<ItemsResultUpdateNewMember>> apiUpdateNewMemberOrgList(
      Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().updateNewMemberInOrg),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      print(responseJson);
      return responseJson
          .map((m) => new ItemsResultUpdateNewMember.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  ///-----
  Future<List<ItemsSwitchOrg>> apiUpdateSwitchOrgList(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().updateOrgSwitch),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      print(responseJson);
      return responseJson.map((m) => new ItemsSwitchOrg.fromJson(m)).toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }
}
