class ItemsAttandOutsideStartResult {
  final String UID;
  final String UPLOADKEY;
  final String STATUS;
  final String MSG;

  ItemsAttandOutsideStartResult(
      {this.UID, this.UPLOADKEY, this.STATUS, this.MSG});

  factory ItemsAttandOutsideStartResult.fromJson(Map<String, dynamic> json) {
    return ItemsAttandOutsideStartResult(
      UID: json['uid'],
      UPLOADKEY: json['uploadKey'],
      STATUS: json['status'],
      MSG: json['msg'],
    );
  }
}
