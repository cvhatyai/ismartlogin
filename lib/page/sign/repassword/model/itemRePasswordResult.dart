import 'package:ismart_login/page/sign/repassword/model/itemRePasswordResultDetail.dart';

class ItemsRePasswordMemberResult {
  final String MSG;
  final bool STATUS;
  final List<ItemsRePasswordMemberResultDetail> RESULT;

  ItemsRePasswordMemberResult({
    this.MSG,
    this.STATUS,
    this.RESULT,
  });

  factory ItemsRePasswordMemberResult.fromJson(Map<String, dynamic> json) {
    return ItemsRePasswordMemberResult(
      MSG: json['msg'],
      STATUS: json['status'],
      RESULT: List.from(json['result']
          .map((m) => ItemsRePasswordMemberResultDetail.fromJson(m))),
    );
  }
}
