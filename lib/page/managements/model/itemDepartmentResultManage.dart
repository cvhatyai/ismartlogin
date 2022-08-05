class ItemsDepartmentResultManage {
  final String ID;
  final String PARENT_ID;
  final String INVITE_CODE;
  final String SUBJECT;
  final String LATITUDE;
  final String LONGTITUDE;
  final String RADIUS;
  final String CREATE_DATE;
  final String UPDATE_DATE;
  final String STATUS;
  final String SEQ;

  ItemsDepartmentResultManage({
    this.ID,
    this.PARENT_ID,
    this.INVITE_CODE,
    this.SUBJECT,
    this.LATITUDE,
    this.LONGTITUDE,
    this.RADIUS,
    this.CREATE_DATE,
    this.UPDATE_DATE,
    this.STATUS,
    this.SEQ,
  });

  factory ItemsDepartmentResultManage.fromJson(Map<String, dynamic> json) {
    return ItemsDepartmentResultManage(
      ID: json['id'],
      PARENT_ID: json['parent_id'],
      INVITE_CODE: json['invite_code'],
      SUBJECT: json['subject'],
      LATITUDE: json['latitude'],
      LONGTITUDE: json['longitude'],
      RADIUS: json['radius'],
      CREATE_DATE: json['create_date'],
      UPDATE_DATE: json['update_date'],
      STATUS: json['status'],
      SEQ: json['seq'],
    );
  }
}
