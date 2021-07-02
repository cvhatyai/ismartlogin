class ItemsPasswordMemberResult {
  final String MSG;
  final bool STATUS;

  ItemsPasswordMemberResult({
    this.MSG,
    this.STATUS,
  });

  factory ItemsPasswordMemberResult.fromJson(Map<String, dynamic> json) {
    return ItemsPasswordMemberResult(
      MSG: json['msg'],
      STATUS: json['status'],
    );
  }
}
