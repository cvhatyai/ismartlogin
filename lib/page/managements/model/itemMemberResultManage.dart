class ItemsMemberResultManage {
  final String ID;
  final String FULLNAME;
  final String NICKNAME;
  final String PHONE;
  final String AVATAR;
  final String ORG_ID;
  final String ORG_NAME;
  final String ORG_SUB_ID;
  final String ORG_SUB_NAME;
  final String TIME_ID;
  final String STATUS;
  final String STAT;
  final String MEMBER_TYPE;
  final String HISTORY;
  final String LEAVE;
  final String LEAVE_MEMBER;

  ItemsMemberResultManage({
    this.ID,
    this.FULLNAME,
    this.NICKNAME,
    this.PHONE,
    this.AVATAR,
    this.ORG_ID,
    this.ORG_NAME,
    this.ORG_SUB_ID,
    this.ORG_SUB_NAME,
    this.TIME_ID,
    this.STATUS,
    this.STAT,
    this.MEMBER_TYPE,
    this.HISTORY,
    this.LEAVE,
    this.LEAVE_MEMBER,
  });

  factory ItemsMemberResultManage.fromJson(Map<String, dynamic> json) {
    return ItemsMemberResultManage(
      ID: json['id'],
      FULLNAME: json['fullname'],
      NICKNAME: json['nickname'],
      PHONE: json['phone'],
      AVATAR: json['avatar'],
      ORG_ID: json['org_id'],
      ORG_NAME: json['org_name'],
      ORG_SUB_ID: json['org_sub_id'],
      ORG_SUB_NAME: json['org_sub_name'],
      TIME_ID: json['time_id'],
      MEMBER_TYPE: json['member_type'],
      STATUS: json['status'],
      STAT: json['stat'],
      HISTORY: json['history'],
      LEAVE: json['leave'],
      LEAVE_MEMBER: json['leave_member'],
    );
  }
}
