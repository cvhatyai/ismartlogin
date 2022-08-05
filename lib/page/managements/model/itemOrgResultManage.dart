class ItemsOrgResultManage {
  final String ID;
  final String ORG_ID;
  final String SUBJECT;
  final String CREATE_BY;
  final bool ACTIVE;
  final String ORG_CREATE;
  final String INVITE;
  final String HISTORY;

  ItemsOrgResultManage({
    this.ID,
    this.ORG_ID,
    this.SUBJECT,
    this.CREATE_BY,
    this.ACTIVE,
    this.ORG_CREATE,
    this.INVITE,
    this.HISTORY,
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
    );
  }
}
