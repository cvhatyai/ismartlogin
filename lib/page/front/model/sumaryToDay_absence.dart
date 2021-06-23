class ItemsSummaryToDay_Absence {
  final String ID;
  final String FULLNAME;
  final String NICKNAME;
  final String CREATE_DATE_TH;
  final String SUBJECT;
  final String DESCRIPTION;
  final String AVATAR;

  ItemsSummaryToDay_Absence({
    this.ID,
    this.FULLNAME,
    this.NICKNAME,
    this.CREATE_DATE_TH,
    this.SUBJECT,
    this.DESCRIPTION,
    this.AVATAR,
  });

  factory ItemsSummaryToDay_Absence.fromJson(Map<String, dynamic> json) {
    return ItemsSummaryToDay_Absence(
      ID: json['id'],
      FULLNAME: json['fullname'],
      NICKNAME: json['nickname'],
      CREATE_DATE_TH: json['create_date_th'],
      SUBJECT: json['subject'],
      DESCRIPTION: json['description'],
      AVATAR: json['avatar'],
    );
  }
}
