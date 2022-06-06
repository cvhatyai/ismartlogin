class ItemsAttendHistoryResult {
  final String TIME;
  final String TIME_STATUS;
  final String TIME_ID_NAME;
  final String STATUS;
  final String IMAGES;
  final String LAT;
  final String LNG;
  final String NOTE;
  final String DETAIL;
  final String CID;

  ItemsAttendHistoryResult({
    this.TIME,
    this.TIME_STATUS,
    this.TIME_ID_NAME,
    this.STATUS,
    this.IMAGES,
    this.LAT,
    this.LNG,
    this.NOTE,
    this.DETAIL,
    this.CID,
  });

  factory ItemsAttendHistoryResult.fromJson(Map<String, dynamic> json) {
    return ItemsAttendHistoryResult(
      TIME: json['time'],
      TIME_STATUS: json['time_status'],
      TIME_ID_NAME: json['time_id_name'],
      STATUS: json['status'],
      IMAGES: json['images'],
      LAT: json['lat'],
      LNG: json['lng'],
      NOTE: json['note'],
      DETAIL: json['detail'],
      CID: json['cid'],
    );
  }
}
