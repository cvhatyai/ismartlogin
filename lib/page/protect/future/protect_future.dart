import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_login/page/front/model/attendEnd.dart';
import 'package:ismart_login/page/front/model/attendHistory.dart';
import 'package:ismart_login/page/front/model/attendStart.dart';
import 'package:ismart_login/page/front/model/attendToDay.dart';
import 'package:ismart_login/page/protect/model/protectList.dart';

import 'package:ismart_login/server/server.dart';

class ProtectFuture {
  final Map<String, String> header = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "*"
  };
  ProtectFuture() : super();

  Future<List<ItemsProtect>> apiGetProtect(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().getKeyInvite),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((m) => new ItemsProtect.fromJson(m)).toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }
}
