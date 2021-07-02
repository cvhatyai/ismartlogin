class ItemsMemberResultList {
  final String MSG;
  final String UPLOADKEY;
  final String RESULT;

  ItemsMemberResultList({
    this.MSG,
    this.UPLOADKEY,
    this.RESULT,
  });

  factory ItemsMemberResultList.fromJson(Map<String, dynamic> json) {
    return ItemsMemberResultList(
      MSG: json['msg'],
      UPLOADKEY: json['uploadKey'],
      RESULT: json['result'],
    );
  }
}
