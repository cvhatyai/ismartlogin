class ItemsMemberResultList {
  final String MSG;
  final String RESULT;

  ItemsMemberResultList({
    this.MSG,
    this.RESULT,
  });

  factory ItemsMemberResultList.fromJson(Map<String, dynamic> json) {
    return ItemsMemberResultList(
      MSG: json['msg'],
      RESULT: json['result'],
    );
  }
}
