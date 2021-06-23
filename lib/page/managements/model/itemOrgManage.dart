import 'package:ismart_login/page/managements/model/itemOrgResultManage.dart';

class ItemsOrgPostManage {
  final String MSG;
  final bool STATUS;

  ItemsOrgPostManage({
    this.MSG,
    this.STATUS,
  });

  factory ItemsOrgPostManage.fromJson(Map<String, dynamic> json) {
    return ItemsOrgPostManage(
      MSG: json['msg'],
      STATUS: json['status'],
    );
  }
}

class ItemsOrgGetManage {
  final String MSG;
  final bool STATUS;
  final List<ItemsOrgResultManage> RESULT;

  ItemsOrgGetManage({
    this.MSG,
    this.STATUS,
    this.RESULT,
  });

  factory ItemsOrgGetManage.fromJson(Map<String, dynamic> json) {
    return ItemsOrgGetManage(
      MSG: json['msg'],
      STATUS: json['status'],
      RESULT: List.from(
          json['result'].map((m) => ItemsOrgResultManage.fromJson(m))),
    );
  }
}
