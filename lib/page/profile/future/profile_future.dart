import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ismart_login/server/server.dart';
import 'package:ismart_login/system/shared_preferences.dart';

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
    Response response = await Dio().post(Server().updateMember, data: formData);
    if (response.statusCode == 200) {
      print(json.encode(response.data));
      var list = json.decode(response.data);
      print(list[0]['path']);
      if (list[0]['path'] != '') {
        await SharedCashe.savaItemsString(
            key: 'avatar', valString: list[0]['path']);
      }
      EasyLoading.dismiss();
      EasyLoading.showSuccess('บันทึกเรียบร้อย');
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError('Error : ' + response.statusCode.toString());
    }
  }
}
