import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ismart_login/page/front/model/itemMemberRelationship.dart';
import 'package:ismart_login/server/server.dart';

final Map<String, String> header = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": "true",
  "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "*"
};

class MemberRelationshipFuture {
  MemberRelationshipFuture() : super();
  //---
  Future<List<ItemsMemberRelationship>> apiGetMemberRelationshipList(
      Map jsonMap) async {
    //encode Map to JSON
    var body = json.encode(jsonMap);
    final response = await http.post(
      Uri.parse(Server().getMemberRelationship),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      print(responseJson);
      return responseJson
          .map((m) => new ItemsMemberRelationship.fromJson(m))
          .toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }
}
