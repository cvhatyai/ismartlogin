class ItemsAttendOutsideEndResult {
  final String ID;
  final String UID;
  final String UPLOADKEY;
  final String STATUS;
  final String MSG;

  ItemsAttendOutsideEndResult(
      {this.ID, this.UID, this.UPLOADKEY, this.STATUS, this.MSG});

  factory ItemsAttendOutsideEndResult.fromJson(Map<String, dynamic> json) {
    return ItemsAttendOutsideEndResult(
      ID: json['id'],
      UID: json['uid'],
      UPLOADKEY: json['uploadKey'],
      STATUS: json['status'],
      MSG: json['msg'],
    );
  }
}
