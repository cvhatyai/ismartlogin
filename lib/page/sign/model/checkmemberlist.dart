class ItemsCheckMemberResult {
  final String MSG;
  final String STATUS;

  ItemsCheckMemberResult({
    this.MSG,
    this.STATUS,
  });

  factory ItemsCheckMemberResult.fromJson(Map<String, dynamic> json) {
    return ItemsCheckMemberResult(
      MSG: json['msg'],
      STATUS: json['status'],
    );
  }
}
