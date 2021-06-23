class ItemsMyHistory {
  final String ID;
  final String CID;
  final String UID;
  final String CREATE_DATE_TH;
  final String START_TIME;
  final String START_IMAGE;
  final String START_IMAGE_SMALL;
  final String START_NOTE;
  final String START_STATUS;
  final String START_LATITUDE;
  final String START_LONGITUDE;
  final String START_LOCATION_STATUS;
  final String START_LOCATION_SUB_STATUS;
  final String END_TIME;
  final String END_IMAGE;
  final String END_IMAGE_SMALL;
  final String END_NOTE;
  final String END_STATUS;

  ItemsMyHistory(
      {this.ID,
      this.CID,
      this.UID,
      this.CREATE_DATE_TH,
      this.START_TIME,
      this.START_IMAGE,
      this.START_IMAGE_SMALL,
      this.START_NOTE,
      this.START_STATUS,
      this.START_LATITUDE,
      this.START_LONGITUDE,
      this.START_LOCATION_STATUS,
      this.START_LOCATION_SUB_STATUS,
      this.END_TIME,
      this.END_IMAGE,
      this.END_IMAGE_SMALL,
      this.END_NOTE,
      this.END_STATUS});

  factory ItemsMyHistory.fromJson(Map<String, dynamic> json) {
    return ItemsMyHistory(
      ID: json['id'],
      CID: json['cid'],
      UID: json['uid'],
      CREATE_DATE_TH: json['create_date_th'],
      START_TIME: json['start_time'],
      START_IMAGE: json['start_image'],
      START_IMAGE_SMALL: json['start_image_small'],
      START_NOTE: json['start_note'],
      START_STATUS: json['start_status'],
      START_LATITUDE: json['start_latitude'],
      START_LONGITUDE: json['start_longitude'],
      START_LOCATION_STATUS: json['start_location_status'],
      START_LOCATION_SUB_STATUS: json['start_location_sub_status'],
      END_TIME: json['end_time'],
      END_IMAGE: json['end_image'],
      END_IMAGE_SMALL: json['end_image_small'],
      END_NOTE: json['end_note'],
      END_STATUS: json['end_status'],
    );
  }
}
