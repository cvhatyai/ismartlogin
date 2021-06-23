import 'package:ismart_login/page/managements/model/itemTimeResultMange.dart';

class ItemsTimeManage {
  final String MSG;
  final bool STATUS;
  final List<ItemsTimeResultManage> RESULT;

  ItemsTimeManage({
    this.MSG,
    this.STATUS,
    this.RESULT,
  });

  factory ItemsTimeManage.fromJson(Map<String, dynamic> json) {
    return ItemsTimeManage(
      MSG: json['msg'],
      STATUS: json['status'],
      RESULT: List.from(
          json['result'].map((m) => ItemsTimeResultManage.fromJson(m))),
    );
  }
}

class ItemsTimeManagePostUpdate {
  final String MSG;
  final bool STATUS;

  ItemsTimeManagePostUpdate({
    this.MSG,
    this.STATUS,
  });

  factory ItemsTimeManagePostUpdate.fromJson(Map<String, dynamic> json) {
    return ItemsTimeManagePostUpdate(
      MSG: json['msg'],
      STATUS: json['status'],
    );
  }
}
