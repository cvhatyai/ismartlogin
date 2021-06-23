class ItemsMemberStatusManage {
  final String MSG;
  final bool STATUS;
  final String RESULT;

  ItemsMemberStatusManage({
    this.MSG,
    this.STATUS,
    this.RESULT,
  });

  factory ItemsMemberStatusManage.fromJson(Map<String, dynamic> json) {
    return ItemsMemberStatusManage(
      MSG: json['msg'],
      STATUS: json['status'],
      RESULT: json['result'],
    );
  }
}
