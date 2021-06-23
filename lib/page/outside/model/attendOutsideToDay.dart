class ItemsAttandOutsideToDay {
  final String CID;
  final String STATUS;
  final String CREATE_DATE;
  final String START_TIME;
  final String START_NOTE;
  final String START_IMAGES;
  final String START_STATUS;
  final String END_TIME;
  final String END_NOTE;
  final String END_IMAGES;
  final String END_STATUS;

  ItemsAttandOutsideToDay({
    this.CID,
    this.STATUS,
    this.CREATE_DATE,
    this.START_TIME,
    this.START_NOTE,
    this.START_IMAGES,
    this.START_STATUS,
    this.END_TIME,
    this.END_NOTE,
    this.END_IMAGES,
    this.END_STATUS,
  });

  factory ItemsAttandOutsideToDay.fromJson(Map<String, dynamic> json) {
    return ItemsAttandOutsideToDay(
      CID: json['cid'],
      STATUS: json['status'],
      CREATE_DATE: json['create_date'],
      START_TIME: json['start_time'],
      START_NOTE: json['start_note'],
      START_IMAGES: json['start_images'],
      START_STATUS: json['start_status'],
      END_TIME: json['end_time'],
      END_NOTE: json['end_note'],
      END_IMAGES: json['end_images'],
      END_STATUS: json['end_status'],
    );
  }
}
