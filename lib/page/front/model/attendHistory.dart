import 'package:ismart_login/page/front/model/attendHistoryResult.dart';

class ItemsAttendHistory {
  final String MSG;
  final List<ItemsAttendHistoryResult> RESULT;

  ItemsAttendHistory({
    this.MSG,
    this.RESULT,
  });

  factory ItemsAttendHistory.fromJson(Map<String, dynamic> json) {
    return ItemsAttendHistory(
      MSG: json['msg'],
      RESULT: List.from(
          json['result'].map((m) => ItemsAttendHistoryResult.fromJson(m))),
    );
  }
}
