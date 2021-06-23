class ItemsOTPList {
  final String MSG;
  final String RESULT;

  ItemsOTPList({
    this.MSG,
    this.RESULT,
  });

  factory ItemsOTPList.fromJson(Map<String, dynamic> json) {
    return ItemsOTPList(
      MSG: json['msg'],
      RESULT: json['result'],
    );
  }
}
