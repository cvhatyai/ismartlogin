import 'package:ismart_login/page/managements/model/itemDepartmentResultManage.dart';

class ItemsDepartmentManage {
  final String MSG;
  final bool STATUS;
  final List<ItemsDepartmentResultManage> RESULT;

  ItemsDepartmentManage({
    this.MSG,
    this.STATUS,
    this.RESULT,
  });

  factory ItemsDepartmentManage.fromJson(Map<String, dynamic> json) {
    return ItemsDepartmentManage(
      MSG: json['msg'],
      STATUS: json['status'],
      RESULT: List.from(
          json['result'].map((m) => ItemsDepartmentResultManage.fromJson(m))),
    );
  }
}

class ItemsDepartmentManagePostUpdate {
  final String MSG;
  final bool STATUS;

  ItemsDepartmentManagePostUpdate({
    this.MSG,
    this.STATUS,
  });

  factory ItemsDepartmentManagePostUpdate.fromJson(Map<String, dynamic> json) {
    return ItemsDepartmentManagePostUpdate(
      MSG: json['msg'],
      STATUS: json['status'],
    );
  }
}
