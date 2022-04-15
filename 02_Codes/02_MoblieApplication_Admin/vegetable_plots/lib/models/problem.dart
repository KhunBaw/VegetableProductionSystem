import 'package:meta/meta.dart';
import 'dart:convert';

List<Problem> problemFromJson(String str) =>
    List<Problem>.from(json.decode(str).map((x) => Problem.fromJson(x)));

String problemToJson(List<Problem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Problem {
  Problem({
    @required this.problemsId,
    @required this.problemsName,
    @required this.solving,
    @required this.id,
  });

  final String problemsId;
  final String problemsName;
  final List<Solving> solving;
  final int id;

  factory Problem.fromJson(Map<String, dynamic> json) => Problem(
        problemsId: json["problems_id"] == null ? null : json["problems_id"],
        problemsName:
            json["problems_name"] == null ? null : json["problems_name"],
        solving: json["solving"] == null
            ? null
            : List<Solving>.from(
                json["solving"].map((x) => Solving.fromJson(x))),
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "problems_id": problemsId == null ? null : problemsId,
        "problems_name": problemsName == null ? null : problemsName,
        "solving": solving == null
            ? null
            : List<dynamic>.from(solving.map((x) => x.toJson())),
        "id": id == null ? null : id,
      };
}

class Solving {
  Solving({
    @required this.name,
    @required this.unitId,
    @required this.amount,
  });

  final String name;
  final String unitId;
  final dynamic amount;

  factory Solving.fromJson(Map<String, dynamic> json) => Solving(
        name: json["name"] == null ? null : json["name"],
        unitId: json["unit_id"] == null ? null : json["unit_id"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "unit_id": unitId == null ? null : unitId,
        "amount": amount,
      };
}
