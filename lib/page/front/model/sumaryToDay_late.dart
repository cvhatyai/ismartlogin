class ItemsSummaryToDay_Late {
  final String ID;
  final String CID;
  final String FULLNAME;
  final String NICKNAME;
  final String CREATE_DATE_TH;
  final String SUBJECT;
  final String DESCRIPTION;
  final String CREATE_DATE;
  final String START_DATE;
  final String START_TIME;
  final String START_IMAGE;
  final String START_IMAGE_SMALL;
  final String START_NOTE;
  final String START_LOCATION_NOTE;
  final String START_LOCATION_STATUS;
  final String START_LOCATION_SUB_STATUS;
  final String END_DATE;
  final String END_TIME;
  final String END_IMAGE;
  final String END_IMAGE_SMALL;
  final String END_NOTE;
  final String END_LOCATION_NOT;
  final String END_STATUS;

  ItemsSummaryToDay_Late({
    this.ID,
    this.CID,
    this.FULLNAME,
    this.NICKNAME,
    this.CREATE_DATE_TH,
    this.SUBJECT,
    this.DESCRIPTION,
    this.CREATE_DATE,
    this.START_DATE,
    this.START_TIME,
    this.START_IMAGE,
    this.START_IMAGE_SMALL,
    this.START_NOTE,
    this.START_LOCATION_NOTE,
    this.START_LOCATION_STATUS,
    this.START_LOCATION_SUB_STATUS,
    this.END_DATE,
    this.END_TIME,
    this.END_IMAGE,
    this.END_IMAGE_SMALL,
    this.END_NOTE,
    this.END_LOCATION_NOT,
    this.END_STATUS,
  });

  factory ItemsSummaryToDay_Late.fromJson(Map<String, dynamic> json) {
    return ItemsSummaryToDay_Late(
      ID: json['id'],
      CID: json['cid'],
      FULLNAME: json['fullname'],
      NICKNAME: json['nickname'],
      CREATE_DATE_TH: json['create_date_th'],
      SUBJECT: json['subject'],
      DESCRIPTION: json['description'],
      CREATE_DATE: json['create_date'],
      START_DATE: json['start_date'],
      START_TIME: json['start_time'],
      START_IMAGE: json['start_image'],
      START_IMAGE_SMALL: json['start_image_small'],
      START_NOTE: json['start_note'],
      START_LOCATION_NOTE: json['start_location_note'],
      START_LOCATION_STATUS: json['start_location_status'],
      START_LOCATION_SUB_STATUS: json['start_location_sub_status'],
      END_DATE: json['end_date'],
      END_TIME: json['end_time'],
      END_IMAGE: json['end_image'],
      END_IMAGE_SMALL: json['end_image_small'],
      END_NOTE: json['end_note'],
      END_LOCATION_NOT: json['end_location_note'],
      END_STATUS: json['end_status'],
    );
  }
}
