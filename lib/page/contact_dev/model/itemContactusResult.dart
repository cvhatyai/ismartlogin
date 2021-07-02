class ItemContactusResult {
  final String MSG;
  final bool STATUS;

  ItemContactusResult({
    this.MSG,
    this.STATUS,
  });

  factory ItemContactusResult.fromJson(Map<String, dynamic> json) {
    return ItemContactusResult(
      MSG: json['msg'],
      STATUS: json['status'],
    );
  }
}
