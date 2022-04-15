import 'package:meta/meta.dart';
import 'dart:convert';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  Order({
    @required this.orderId,
    @required this.status,
    @required this.dateFinal,
    @required this.vegetable,
    @required this.od,
  });

  final String orderId;
  final String status;
  final String dateFinal;
  final List<Vegetable> vegetable;
  final Od od;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["order_id"],
        status: json["status"],
        dateFinal: json["date_final"],
        vegetable: List<Vegetable>.from(
            json["vegetable"].map((x) => Vegetable.fromJson(x))),
        od: Od.fromJson(json["od"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "status": status,
        "date_final": dateFinal,
        "vegetable": List<dynamic>.from(vegetable.map((x) => x.toJson())),
        "od": od.toJson(),
      };
}

class Od {
  Od({
    @required this.name,
    @required this.address,
    @required this.phnum,
  });

  final String name;
  final String address;
  final String phnum;

  factory Od.fromJson(Map<String, dynamic> json) => Od(
        name: json["name"],
        address: json["address"],
        phnum: json["phnum"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "phnum": phnum,
      };
}

class Vegetable {
  Vegetable({
    @required this.vId,
    @required this.vName,
    @required this.unitEng,
    @required this.weight,
  });

  final String vId;
  final String vName;
  final String unitEng;
  final int weight;

  factory Vegetable.fromJson(Map<String, dynamic> json) => Vegetable(
        vId: json["v_id"],
        vName: json["v_name"],
        unitEng: json["unit_eng"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "v_id": vId,
        "v_name": vName,
        "unit_eng": unitEng,
        "weight": weight,
      };
}
