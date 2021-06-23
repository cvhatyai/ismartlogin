class ItemsUpdateAttandStartResult {
  final String ID;
  final String STATUS;
  final String MSG;

  ItemsUpdateAttandStartResult({this.ID, this.STATUS, this.MSG});

  factory ItemsUpdateAttandStartResult.fromJson(Map<String, dynamic> json) {
    return ItemsUpdateAttandStartResult(
      ID: json['id'],
      STATUS: json['status'],
      MSG: json['msg'],
    );
  }
}
