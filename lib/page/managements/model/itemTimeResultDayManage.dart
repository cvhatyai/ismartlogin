class ItemsTimeResultDayManage {
  final int DAY;
  final String TIME_START;
  final String TIME_END;

  ItemsTimeResultDayManage({
    this.DAY,
    this.TIME_START,
    this.TIME_END,
  });

  factory ItemsTimeResultDayManage.fromJson(Map<String, dynamic> json) {
    return ItemsTimeResultDayManage(
      DAY: json['day'],
      TIME_START: json['time_start'],
      TIME_END: json['time_end'],
    );
  }
}
