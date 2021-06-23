class ItemsAttendOutsideDetailPop {
  final String TOPIC;
  final String DESCRIPTION;

  ItemsAttendOutsideDetailPop({
    this.TOPIC,
    this.DESCRIPTION,
  });

  factory ItemsAttendOutsideDetailPop.fromJson(Map<String, dynamic> json) {
    return ItemsAttendOutsideDetailPop(
      TOPIC: json['topic'],
      DESCRIPTION: json['description'],
    );
  }
}
