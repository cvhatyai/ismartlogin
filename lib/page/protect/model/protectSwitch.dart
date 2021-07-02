class ItemsProtectSwitch {
  final String ID;
  final bool STATUS;
  final String CREATE_DATE;

  ItemsProtectSwitch({this.ID, this.STATUS, this.CREATE_DATE});

  factory ItemsProtectSwitch.fromJson(Map<String, dynamic> json) {
    return ItemsProtectSwitch(
      ID: json['id'],
      STATUS: json['status'],
      CREATE_DATE: json['create_date'],
    );
  }
}
