import 'package:ismart_login/page/faq/model/listFaq.dart';

class ListFaqResult {
  final String MSG;
  final bool STATUS;
  final List<ListFaq> RESULT;

  ListFaqResult({this.MSG, this.STATUS, this.RESULT});

  factory ListFaqResult.fromJson(Map<String, dynamic> json) {
    return ListFaqResult(
      MSG: json['msg'],
      STATUS: json['status'],
      RESULT: List.from(json['result'].map((m) => ListFaq.fromJson(m))),
    );
  }
}
