class ItemsAllHistory {
  final String CID;
  final String CREATE_DATE;
  final String CREATE_DATE_TH;
  final int ONTIME;
  final int LATE;
  final int OUTSIDE;
  final int ABSENCE;
  final int LEAVE;

  ItemsAllHistory({
    this.CID,
    this.CREATE_DATE,
    this.CREATE_DATE_TH,
    this.ONTIME,
    this.LATE,
    this.OUTSIDE,
    this.ABSENCE,
    this.LEAVE,
  });

  factory ItemsAllHistory.fromJson(Map<String, dynamic> json) {
    return ItemsAllHistory(
      CID: json['cid'],
      CREATE_DATE: json['create_date'],
      CREATE_DATE_TH: json['create_date_th'],
      ONTIME: json['ontime'],
      LATE: json['late'],
      OUTSIDE: json['outside'],
      ABSENCE: json['absence'],
      LEAVE: json['leave'],
    );
  }
}
