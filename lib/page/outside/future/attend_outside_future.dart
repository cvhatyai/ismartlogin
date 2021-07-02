import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_login/page/front/model/attendEnd.dart';
import 'package:ismart_login/page/front/model/attendStart.dart';
import 'package:ismart_login/page/front/model/attendToDay.dart';
import 'package:ismart_login/page/outside/model/attendOutsideEnd.dart';
import 'package:ismart_login/page/outside/model/attendOutsideStart.dart';
import 'package:ismart_login/page/outside/model/attendOutsideToDay.dart';

import 'package:ismart_login/server/server.dart';

class AttandOutsideFuture {
  final Map<String, String> header = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "*"
  };
  AttandOutsideFuture() : super();

  Future<List<ItemsAttandOutsideToDay>> apiGetAttandOutsideCheck(
      Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().getAttandCheckOutside),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson
          .map((m) => new ItemsAttandOutsideToDay.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  ///---
  Future<List<ItemsAttandOutsideStartResult>> apiPostAttandOutsideStart(
      Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().postAttandOutsideStart),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      print(response.body);
      return responseJson
          .map((m) => new ItemsAttandOutsideStartResult.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  Future<List<ItemsAttendOutsideEndResult>> apiPostAttendOutsideEnd(
      Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().postAttandOutsideEnd),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson
          .map((m) => new ItemsAttendOutsideEndResult.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  ///---UPLOAD
  Future<dynamic> uploadAttendOutside(
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
    Response response = await Dio().post(Server().postAttandUploadImages,
        data: formData, onSendProgress: (int bytes, int total) {
      print('progress: $total ($bytes/$total) => ' +
          (bytes / total).toString() +
          '%');
      EasyLoading.showProgress((bytes / total), status: "กำลังอัพโหลด");
      if (bytes / total == 1 || bytes >= total) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('เรียบร้อย');
      }
    });
    print(json.encode(response.data));
  }

  //----------------
}
