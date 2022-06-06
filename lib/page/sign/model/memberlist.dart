class ItemsMemberList {
  final String ID;
  final String USERNAME;
  final String PASSWORD;
  final String FULLNAME;
  final String AVATAR;
  final String ORG_ID;
  final String ORG_NAME;
  final String PHONE;
  final String TIME_ID;

  ItemsMemberList({
    this.ID,
    this.USERNAME,
    this.PASSWORD,
    this.FULLNAME,
    this.AVATAR,
    this.ORG_ID,
    this.ORG_NAME,
    this.PHONE,
    this.TIME_ID,
  });

  factory ItemsMemberList.fromJson(Map<String, dynamic> json) {
    return ItemsMemberList(
      ID: json['id'],
      USERNAME: json['username'],
      PASSWORD: json['password'],
      FULLNAME: json['fullname'],
      AVATAR: json['avatar'],
      ORG_ID: json['org_id'],
      ORG_NAME: json['org_name'],
      PHONE: json['phone'],
      TIME_ID: json['time_id'],
    );
  }
}
