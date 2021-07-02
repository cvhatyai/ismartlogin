class ListFaq {
  final String ID;
  final String SUBJECT;
  final String DESCRIPTION;
  final String CREATE_DATE;
  final String UPDATE_DATE;

  ListFaq({
    this.ID,
    this.SUBJECT,
    this.DESCRIPTION,
    this.CREATE_DATE,
    this.UPDATE_DATE,
  });

  factory ListFaq.fromJson(Map<String, dynamic> json) {
    return ListFaq(
      ID: json['id'],
      SUBJECT: json['subject'],
      DESCRIPTION: json['description'],
      CREATE_DATE: json['create_date'],
      UPDATE_DATE: json['update_date'],
    );
  }
}
