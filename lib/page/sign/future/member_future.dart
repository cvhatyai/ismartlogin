import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:ismart_login/page/sign/model/checkmemberlist.dart';
import 'package:ismart_login/page/sign/model/for_post.dart';
import 'package:ismart_login/page/sign/model/memberlist.dart';
import 'package:ismart_login/page/sign/model/otplist.dart';
import 'package:ismart_login/server/server.dart';

final Map<String, String> header = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": "true",
  "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "*"
};

class MemberFuture {
  MemberFuture() : super();
//-----
  Future<List<ItemsCheckMemberResult>> apiGetCheckMember(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().getCheckMember),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson
          .map((m) => new ItemsCheckMemberResult.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  Future<List<ItemsMemberResultList>> apiInsertMember(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().postMember),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson
          .map((m) => new ItemsMemberResultList.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  //-----
  //----OTP
  Future<List<ItemsOTPList>> apiPostOtp(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().postOtp),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((m) => new ItemsOTPList.fromJson(m)).toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  Future<List<ItemsOTPList>> apiGetCheckOtp(Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().getCheckOtp),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((m) => new ItemsOTPList.fromJson(m)).toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  Future<dynamic> uploadAvatarProfile({
    String file,
    String uploadKey,
  }) async {
    String fileName = file.split('/').last;
    var formData = FormData.fromMap({
      "file": file != ''
          ? await MultipartFile.fromFile(file, filename: fileName)
          : '',
      "uploadKey": uploadKey,
    });
    Response response = await Dio().post(Server().postAvatarMember,
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
    if (response.statusCode == 200) {
      print(json.encode(response.data));
      var list = json.decode(response.data);
      print("ผลการอัพโหลดรูป : " + list[0]['result']);
    }
  }
}
