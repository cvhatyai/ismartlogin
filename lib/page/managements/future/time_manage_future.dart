import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ismart_login/page/managements/model/itemMemberManage.dart';
import 'package:ismart_login/page/managements/model/itemTimeManage.dart';
import 'package:ismart_login/server/server.dart';

final Map<String, String> header = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": "true",
  "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "*"
};

class TimeManageFuture {
  TimeManageFuture() : super();
  //---
  Future<List<ItemsTimeManage>> apiGetTimeManageList(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().getTimeManage),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((m) => new ItemsTimeManage.fromJson(m)).toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  //---
  Future<List<ItemsTimeManage>> apiGetTypesManageList(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().getCateLeave),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((m) => new ItemsTimeManage.fromJson(m)).toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  Future<List<ItemsTimeManagePostUpdate>> apiPostTimeManageList(
      Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().postTimeManage),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);

      return responseJson
          .map((m) => new ItemsTimeManagePostUpdate.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }
}
