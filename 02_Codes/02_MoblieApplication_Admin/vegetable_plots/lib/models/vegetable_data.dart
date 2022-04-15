import 'package:meta/meta.dart';
import 'dart:convert';

VegetableData vegetableDataFromJson(String str) =>
    VegetableData.fromJson(json.decode(str));

String vegetableDataToJson(VegetableData data) => json.encode(data.toJson());

class VegetableData {
  VegetableData({
    @required this.vId,
    @required this.vNfv,
    @required this.vD3,
    @required this.vD1,
    @required this.vWide,
    @required this.vPhoto,
    @required this.vName,
    @required this.vLong,
    @required this.vFertilizer,
    @required this.vD2,
  });

  final String vId;
  final double vNfv;
  final int vD3;
  final int vD1;
  final double vWide;
  final String vPhoto;
  final String vName;
  final double vLong;
  final List<VFertilizer> vFertilizer;
  final int vD2;

  factory VegetableData.fromJson(Map<String, dynamic> json) => VegetableData(
        vId: json["v_id"] == null ? null : json["v_id"],
        vNfv: json["v_nfv"] == null ? null : json["v_nfv"].toDouble(),
        vD3: json["v_d3"] == null ? null : json["v_d3"],
        vD1: json["v_d1"] == null ? null : json["v_d1"],
        vWide: json["v_wide"] == null ? null : json["v_wide"].toDouble(),
        vPhoto: json["v_photo"] == null ? null : json["v_photo"],
        vName: json["v_name"] == null ? null : json["v_name"],
        vLong: json["v_long"] == null ? null : json["v_long"].toDouble(),
        vFertilizer: json["v_fertilizer"] == null
            ? null
            : List<VFertilizer>.from(
                json["v_fertilizer"].map((x) => VFertilizer.fromJson(x))),
        vD2: json["v_d2"] == null ? null : json["v_d2"],
      );

  Map<String, dynamic> toJson() => {
        "v_id": vId == null ? null : vId,
        "v_nfv": vNfv == null ? null : vNfv,
        "v_d3": vD3 == null ? null : vD3,
        "v_d1": vD1 == null ? null : vD1,
        "v_wide": vWide == null ? null : vWide,
        "v_photo": vPhoto == null ? null : vPhoto,
        "v_name": vName == null ? null : vName,
        "v_long": vLong == null ? null : vLong,
        "v_fertilizer": vFertilizer == null
            ? null
            : List<dynamic>.from(vFertilizer.map((x) => x.toJson())),
        "v_d2": vD2 == null ? null : vD2,
      };
}

class VFertilizer {
  VFertilizer({
    @required this.fertilizerType,
    @required this.numFirst,
    @required this.fertilizerId,
    @required this.numPick,
    @required this.fertilizerAt,
    @required this.dayTimes,
  });

  final String fertilizerType;
  final int numFirst;
  final String fertilizerId;
  final int numPick;
  final List<FertilizerAt> fertilizerAt;
  final int dayTimes;

  factory VFertilizer.fromJson(Map<String, dynamic> json) => VFertilizer(
        fertilizerType:
            json["fertilizer_type"] == null ? null : json["fertilizer_type"],
        numFirst: json["num_first"] == null ? null : json["num_first"],
        fertilizerId:
            json["fertilizer_id"] == null ? null : json["fertilizer_id"],
        numPick: json["num_pick"] == null ? null : json["num_pick"],
        fertilizerAt: json["fertilizer_at"] == null
            ? null
            : List<FertilizerAt>.from(
                json["fertilizer_at"].map((x) => FertilizerAt.fromJson(x))),
        dayTimes: json["day_times"] == null ? null : json["day_times"],
      );

  Map<String, dynamic> toJson() => {
        "fertilizer_type": fertilizerType == null ? null : fertilizerType,
        "num_first": numFirst == null ? null : numFirst,
        "fertilizer_id": fertilizerId == null ? null : fertilizerId,
        "num_pick": numPick == null ? null : numPick,
        "fertilizer_at": fertilizerAt == null
            ? null
            : List<dynamic>.from(fertilizerAt.map((x) => x.toJson())),
        "day_times": dayTimes == null ? null : dayTimes,
      };
}

class FertilizerAt {
  FertilizerAt({
    @required this.unitId,
    @required this.time,
    @required this.fertilizerAmount,
  });

  final String unitId;
  final String time;
  final int fertilizerAmount;

  factory FertilizerAt.fromJson(Map<String, dynamic> json) => FertilizerAt(
        unitId: json["unit_id"] == null ? null : json["unit_id"],
        time: json["time"] == null ? null : json["time"],
        fertilizerAmount: json["fertilizer_amount"] == null
            ? null
            : json["fertilizer_amount"],
      );

  Map<String, dynamic> toJson() => {
        "unit_id": unitId == null ? null : unitId,
        "time": time == null ? null : time,
        "fertilizer_amount": fertilizerAmount == null ? null : fertilizerAmount,
      };
}
