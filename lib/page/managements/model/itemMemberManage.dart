import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';

class ItemsMemberManage {
  final String MSG;
  final bool STATUS;
  final List<ItemsMemberResultManage> RESULT;

  ItemsMemberManage({
    this.MSG,
    this.STATUS,
    this.RESULT,
  });

  factory ItemsMemberManage.fromJson(Map<String, dynamic> json) {
    return ItemsMemberManage(
      MSG: json['msg'],
      STATUS: json['status'],
      RESULT: List.from(
          json['result'].map((m) => ItemsMemberResultManage.fromJson(m))),
    );
  }
}
