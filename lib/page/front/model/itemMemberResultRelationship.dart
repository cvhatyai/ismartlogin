class ItemsMemberResultRelationship {
  final String ID;
  final String UID;
  final String AVATAR;
  final String ORG_ID;
  final String ORG_SUB_ID;
  final String TIME_ID;
  final String TYPE;

  ItemsMemberResultRelationship({
    this.ID,
    this.UID,
    this.AVATAR,
    this.ORG_ID,
    this.ORG_SUB_ID,
    this.TIME_ID,
    this.TYPE,
  });

  factory ItemsMemberResultRelationship.fromJson(Map<String, dynamic> json) {
    return ItemsMemberResultRelationship(
      ID: json['id'],
      UID: json['uid'],
      ORG_ID: json['org_id'],
      ORG_SUB_ID: json['org_sub_id'],
      TIME_ID: json['time_id'],
      TYPE: json['type'],
    );
  }
}
