class ItemsResultUpdateNewMember {
  final String MSG;
  final String RESULT;

  ItemsResultUpdateNewMember({
    this.MSG,
    this.RESULT,
  });

  factory ItemsResultUpdateNewMember.fromJson(Map<String, dynamic> json) {
    return ItemsResultUpdateNewMember(
      MSG: json['msg'],
      RESULT: json['result'],
    );
  }
}
