import 'package:ismart_login/page/managements/model/itemTimeResultDayManage.dart';

class ItemsTimeResultManage {
  final String ID;
  final String ORG_ID;
  final String SUBJECT;
  final String DESCRIPTION;
  final String CREATE_DATE;
  final String STATUS;

  ItemsTimeResultManage({
    this.ID,
    this.ORG_ID,
    this.SUBJECT,
    this.DESCRIPTION,
    this.CREATE_DATE,
    this.STATUS,
  });

  factory ItemsTimeResultManage.fromJson(Map<String, dynamic> json) {
    return ItemsTimeResultManage(
      ID: json['id'],
      ORG_ID: json['org_id'],
      SUBJECT: json['subject'],
      DESCRIPTION: json['description'],
      CREATE_DATE: json['create_date'],
      STATUS: json['status'],
    );
  }
}
