import 'package:meta/meta.dart';
import 'dart:convert';

List<Unit> unitFromJson(String str) =>
    List<Unit>.from(json.decode(str).map((x) => Unit.fromJson(x)));

String unitToJson(List<Unit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Unit {
  Unit({
    @required this.unitId,
    @required this.unitTh,
    @required this.unitEng,
  });

  final String unitId;
  final String unitTh;
  final String unitEng;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        unitId: json["unit_id"],
        unitTh: json["unit_th"],
        unitEng: json["unit_eng"],
      );

  Map<String, dynamic> toJson() => {
        "unit_id": unitId,
        "unit_th": unitTh,
        "unit_eng": unitEng,
      };
}
