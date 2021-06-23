class ItemsSummaryAllDay {
  final String CID;
  final String CREATE_DATE;
  final String CREATE_DATE_TH;
  final String ONTIME;
  final String LATE;
  final String ABSENCE;
  final String LEAVE;

  ItemsSummaryAllDay({
    this.CID,
    this.CREATE_DATE,
    this.CREATE_DATE_TH,
    this.ONTIME,
    this.LATE,
    this.ABSENCE,
    this.LEAVE,
  });

  factory ItemsSummaryAllDay.fromJson(Map<String, dynamic> json) {
    return ItemsSummaryAllDay(
      CID: json['cid'],
      CREATE_DATE: json['create_date'],
      CREATE_DATE_TH: json['create_date_th'],
      ONTIME: json['ontime'],
      LATE: json['late'],
      ABSENCE: json['absence'],
      LEAVE: json['leave'],
    );
  }
}
