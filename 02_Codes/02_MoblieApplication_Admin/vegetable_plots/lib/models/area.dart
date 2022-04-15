import 'package:meta/meta.dart';
import 'dart:convert';

List<Area> areaFromJson(String str) =>
    List<Area>.from(json.decode(str).map((x) => Area.fromJson(x)));

String areaToJson(List<Area> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Area {
  Area({
    @required this.areaId,
    @required this.areaName,
    @required this.areaLv,
    @required this.areaVName,
    @required this.areaLong,
    @required this.areaWide,
    @required this.areaPhoto,
    @required this.status,
    @required this.areaDetail,
  });

  final String areaId;
  final String areaName;
  final String areaLv;
  final String areaVName;
  final int areaLong;
  final double areaWide;
  final String areaPhoto;
  final bool status;
  final String areaDetail;

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        areaId: json["area_id"],
        areaName: json["area_name"],
        areaLv: json["area_lv"],
        areaVName: json["area_v_name"],
        areaLong: json["area_long"],
        areaWide: json["area_wide"].toDouble(),
        areaPhoto: json["area_photo"],
        status: json["status"],
        areaDetail: json["area_detail"],
      );

  Map<String, dynamic> toJson() => {
        "area_id": areaId,
        "area_name": areaName,
        "area_lv": areaLv,
        "area_v_name": areaVName,
        "area_long": areaLong,
        "area_wide": areaWide,
        "area_photo": areaPhoto,
        "status": status,
        "area_detail": areaDetail,
      };
}
