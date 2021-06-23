class ItemsAttandToDay {
  final String STATUS;
  final String START_TIME;
  final String START_NOTE;
  final String START_STATUS;
  final String END_TIME;
  final String END_NOTE;
  final String END_STATUS;

  ItemsAttandToDay({
    this.STATUS,
    this.START_TIME,
    this.START_NOTE,
    this.START_STATUS,
    this.END_TIME,
    this.END_NOTE,
    this.END_STATUS,
  });

  factory ItemsAttandToDay.fromJson(Map<String, dynamic> json) {
    return ItemsAttandToDay(
      STATUS: json['status'],
      START_TIME: json['start_time'],
      START_NOTE: json['start_note'],
      START_STATUS: json['start_status'],
      END_TIME: json['end_time'],
      END_NOTE: json['end_note'],
      END_STATUS: json['end_status'],
    );
  }
}
