class ItemsRePasswordMemberResultDetail {
  final String UID;
  final String USERNAME;
  final String PHONE;
  final String FULLNAME;
  final String NICKNAME;
  final String AVATAR;

  ItemsRePasswordMemberResultDetail({
    this.UID,
    this.USERNAME,
    this.PHONE,
    this.FULLNAME,
    this.NICKNAME,
    this.AVATAR,
  });

  factory ItemsRePasswordMemberResultDetail.fromJson(
      Map<String, dynamic> json) {
    return ItemsRePasswordMemberResultDetail(
      UID: json['uid'],
      USERNAME: json['username'],
      PHONE: json['phone'],
      FULLNAME: json['fullname'],
      NICKNAME: json['nickname'],
      AVATAR: json['avatar'],
    );
  }
}
