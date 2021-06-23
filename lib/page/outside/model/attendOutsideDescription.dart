class ItemsAttendOutsideDetail {
  final String TOPIC;
  final String DESCRIPTION;

  ItemsAttendOutsideDetail({
    this.TOPIC,
    this.DESCRIPTION,
  });

  factory ItemsAttendOutsideDetail.fromJson(Map<String, dynamic> json) {
    return ItemsAttendOutsideDetail(
      TOPIC: json['topic'],
      DESCRIPTION: json['description'],
    );
  }
}
