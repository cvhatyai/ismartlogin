import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ismart_login/page/profile/model/itemPasswordResult.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/system/shared_preferences.dart';

final Map<String, String> header = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": "true",
  "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "*"
};

class ProfileFuture {
  Future<dynamic> updateProfile({
    String file,
    String uid,
    String name,
    String lastname,
    String nickname,
    String department,
    String time,
    String org_id,
  }) async {
    String fileName = file.split('/').last;
    var formData = FormData.fromMap({
      "file": file != ''
          ? await MultipartFile.fromFile(file, filename: fileName)
          : '',
      "name": name,
      "lastname": lastname,
      "nickname": nickname,
      "uid": uid,
      "department": department,
      "time": time,
      "org_id": org_id,
    });
    Response response = await Dio().post(Server().updateMember, data: formData,
        onSendProgress: (int bytes, int total) {
      print('progress: $total ($bytes/$total) => ' +
          (bytes / total).toString() +
          '%');
      EasyLoading.showProgress((bytes / total), status: "กำลังอัพโหลด");
      if (bytes / total == 1 || bytes >= total) {
        EasyLoading.dismiss();
      }
    });
    if (response.statusCode == 200) {
      print(json.encode(response.data));
      var list = json.decode(response.data);
      print(list[0]['path']);
      if (list[0]['path'] != '') {
        await SharedCashe.savaItemsString(
            key: 'avatar', valString: list[0]['path']);
      }
      if(time != ""){
        await SharedCashe.savaItemsString(
            key: 'time_id', valString: time);
      }
      EasyLoading.dismiss();
      EasyLoading.showSuccess('บันทึกเรียบร้อย');
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError('Error : ' + response.statusCode.toString());
    }
  }

  Future<List<ItemsPasswordMemberResult>> apiUpdatePasswordMemberList(
      Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().updateMemberPassword),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson
          .map((m) => new ItemsPasswordMemberResult.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }
}
