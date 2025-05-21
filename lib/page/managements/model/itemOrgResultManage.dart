class ItemsOrgResultManage {
  final String ID;
  final String ORG_ID;
  final String SUBJECT;
  final String CREATE_BY;
  final bool ACTIVE;
  final String ORG_CREATE;
  final String INVITE;
  final String HISTORY;
  final String NOTI;
  final String OT;
  final String LOGUT_STATUS;
  final String TIME_STATUS;
  final String LEAVE_CANCEL_STATUS;

  ItemsOrgResultManage({
    this.ID,
    this.ORG_ID,
    this.SUBJECT,
    this.CREATE_BY,
    this.ACTIVE,
    this.ORG_CREATE,
    this.INVITE,
    this.HISTORY,
    this.NOTI,
    this.OT,
    this.LOGUT_STATUS,
    this.TIME_STATUS,
    this.LEAVE_CANCEL_STATUS
  });

  factory ItemsOrgResultManage.fromJson(Map<String, dynamic> json) {
    return ItemsOrgResultManage(
      ID: json['id'],
      ORG_ID: json['org_id'],
      SUBJECT: json['subject'],
      CREATE_BY: json['create_by'],
      ACTIVE: json['active_org'],
      ORG_CREATE: json['org_create'],
      INVITE: json['invite'],
      HISTORY: json['history'],
      NOTI: json['noti'],
      OT: json['ot'],
      LOGUT_STATUS: json['logout'],
      TIME_STATUS: json['time_status'],
      LEAVE_CANCEL_STATUS: json['leave_cancel_status']
    );
  }
}
