import 'package:meta/meta.dart';
import 'dart:convert';

List<Grow> growFromJson(String str) =>
    List<Grow>.from(json.decode(str).map((x) => Grow.fromJson(x)));

String growToJson(List<Grow> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Grow {
  Grow({
    @required this.pdId,
    @required this.orderId,
    @required this.pdD,
    @required this.pdD1,
    @required this.cD3,
    @required this.vName,
    @required this.number,
    @required this.weight,
    @required this.areaId,
    @required this.area,
  });

  final String pdId;
  final List<String> orderId;
  final int pdD;
  final String pdD1;
  final String cD3;
  final String vName;
  final int number;
  final double weight;
  final List<String> areaId;
  final List<AreaIN> area;

  factory Grow.fromJson(Map<String, dynamic> json) => Grow(
        pdId: json["pd_id"] == null ? null : json["pd_id"],
        orderId: json["order_id"] == null
            ? null
            : List<String>.from(json["order_id"].map((x) => x)),
        pdD: json["pd_d"] == null ? null : json["pd_d"],
        pdD1: json["pd_d1"] == null ? null : json["pd_d1"],
        cD3: json["c_d3"] == null ? null : json["c_d3"],
        vName: json["v_name"] == null ? null : json["v_name"],
        number: json["number"] == null ? null : json["number"],
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
        areaId: json["area_id"] == null
            ? null
            : List<String>.from(json["area_id"].map((x) => x)),
        area: json["area"] == null
            ? null
            : List<AreaIN>.from(json["area"].map((x) => AreaIN.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pd_id": pdId == null ? null : pdId,
        "order_id":
            orderId == null ? null : List<dynamic>.from(orderId.map((x) => x)),
        "pd_d": pdD == null ? null : pdD,
        "pd_d1": pdD1 == null ? null : pdD1,
        "c_d3": cD3 == null ? null : cD3,
        "v_name": vName == null ? null : vName,
        "number": number == null ? null : number,
        "weight": weight == null ? null : weight,
        "area_id":
            areaId == null ? null : List<dynamic>.from(areaId.map((x) => x)),
        "area": area == null
            ? null
            : List<dynamic>.from(area.map((x) => x.toJson())),
      };
}

class AreaIN {
  AreaIN({
    @required this.areaId,
    @required this.areaName,
    @required this.areaDetail,
  });

  final String areaId;
  final String areaName;
  final String areaDetail;

  factory AreaIN.fromJson(Map<String, dynamic> json) => AreaIN(
        areaId: json["area_id"] == null ? null : json["area_id"],
        areaName: json["area_name"] == null ? null : json["area_name"],
        areaDetail: json["area_detail"] == null ? null : json["area_detail"],
      );

  Map<String, dynamic> toJson() => {
        "area_id": areaId == null ? null : areaId,
        "area_name": areaName == null ? null : areaName,
        "area_detail": areaDetail == null ? null : areaDetail,
      };
}
