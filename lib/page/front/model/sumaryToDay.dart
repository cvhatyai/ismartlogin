import 'package:ismart_login/page/front/model/sumaryToDay_absence.dart';
import 'package:ismart_login/page/front/model/sumaryToDay_late.dart';
import 'package:ismart_login/page/front/model/sumaryToDay_ontime.dart';
import 'package:ismart_login/page/front/model/sumaryToDay_ot.dart';
import 'package:ismart_login/page/front/model/sumaryToDay_outside.dart';

class ItemsSummaryToDay {
  final List<ItemsSummaryToDay_Ontime> ONTIME;
  final List<ItemsSummaryToDay_Late> LATE;
  final List<ItemsSummaryToDay_Absence> ABSENCE;
  final List<ItemsSummaryToDay_Outside> OUTSIDE;
  final List<ItemsSummaryToDay_OT> OT;

  ItemsSummaryToDay({
    this.ONTIME,
    this.LATE,
    this.ABSENCE,
    this.OUTSIDE,
    this.OT,
  });

  factory ItemsSummaryToDay.fromJson(Map<String, dynamic> json) {
    return ItemsSummaryToDay(
      ONTIME: List.from(
          json['ontime'].map((m) => ItemsSummaryToDay_Ontime.fromJson(m))),
      LATE: List.from(
          json['late'].map((m) => ItemsSummaryToDay_Late.fromJson(m))),
      ABSENCE: List.from(
          json['absence'].map((m) => ItemsSummaryToDay_Absence.fromJson(m))),
      OUTSIDE: List.from(
          json['outside'].map((m) => ItemsSummaryToDay_Outside.fromJson(m))),
      OT: List.from(
        json['ot'].map((m) => ItemsSummaryToDay_OT.fromJson(m))),
    );
  }
}
