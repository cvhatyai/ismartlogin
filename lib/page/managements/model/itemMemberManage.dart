import 'package:ismart_login/page/managements/model/itemMemberResultManage.dart';

class ItemsMemberManage {
  final String MSG;
  final String SICK_LEAVE;
  final String PERSONAL_LEAVE;
  final String OTHER_LEAVE;
  final bool STATUS;
  final List<ItemsMemberResultManage> RESULT;

  ItemsMemberManage({
    this.MSG,
    this.STATUS,
    this.RESULT,
    this.SICK_LEAVE,
    this.PERSONAL_LEAVE,
    this.OTHER_LEAVE,
  });

  factory ItemsMemberManage.fromJson(Map<String, dynamic> json) {
    return ItemsMemberManage(
      MSG: json['msg'],
      STATUS: json['status'],
      SICK_LEAVE: json['sick_leave'],
      PERSONAL_LEAVE: json['personal_leave'],
      OTHER_LEAVE: json['other_leave'],
      RESULT: List.from(
          json['result'].map((m) => ItemsMemberResultManage.fromJson(m))),
    );
  }
}
