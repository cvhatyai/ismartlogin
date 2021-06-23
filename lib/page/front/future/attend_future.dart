import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_login/page/front/model/attendEnd.dart';
import 'package:ismart_login/page/front/model/attendHistory.dart';
import 'package:ismart_login/page/front/model/attendStart.dart';
import 'package:ismart_login/page/front/model/attendToDay.dart';
import 'package:ismart_login/page/front/model/attendUpdateStart.dart';

import 'package:ismart_login/server/server.dart';

class AttandFuture {
  final Map<String, String> header = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "*"
  };
  AttandFuture() : super();

  Future<List<ItemsAttandToDay>> apiGetAttandCheck(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().getAttandCheck),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((m) => new ItemsAttandToDay.fromJson(m)).toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  ///---
  Future<List<ItemsAttandStartResult>> apiPostAttandStart(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().postAttandStart),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      print(response.body);
      return responseJson
          .map((m) => new ItemsAttandStartResult.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  Future<List<ItemsUpdateAttandStartResult>> apiUpdateAttandStart(
      Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().updateAttandStart),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson
          .map((m) => new ItemsUpdateAttandStartResult.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  Future<List<ItemsAttendEndResult>> apiPostAttendEnd(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().postAttandEnd),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson
          .map((m) => new ItemsAttendEndResult.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  ///---UPLOAD
  Future<dynamic> uploadAttend(
      {File file,
      String uploadKey,
      String uid,
      String cmd,
      String attact_type}) async {
    String fileName = file.path.split('/').last;
    var formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
      "uploadKey": uploadKey,
      "uid": uid,
      "cmd": cmd,
      "attact_type": attact_type,
    });
    Response response =
        await Dio().post(Server().postAttandUploadImages, data: formData);
    print(json.encode(response.data));
  }

  //----------------
  //-----------------
  Future<List<ItemsAttendHistory>> apiGetAttendHistory(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().getAttandHistory),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson
          .map((m) => new ItemsAttendHistory.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }
}
