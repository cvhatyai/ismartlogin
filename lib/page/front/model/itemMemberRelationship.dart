import 'package:ismart_login/page/front/model/itemMemberResultRelationship.dart';

class ItemsMemberRelationship {
  final String MSG;
  final bool STATUS;
  final List<ItemsMemberResultRelationship> RESULT;

  ItemsMemberRelationship({
    this.MSG,
    this.STATUS,
    this.RESULT,
  });

  factory ItemsMemberRelationship.fromJson(Map<String, dynamic> json) {
    return ItemsMemberRelationship(
      MSG: json['msg'],
      STATUS: json['status'],
      RESULT: List.from(
          json['result'].map((m) => ItemsMemberResultRelationship.fromJson(m))),
    );
  }
}
