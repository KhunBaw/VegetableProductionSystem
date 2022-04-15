import 'package:meta/meta.dart';
import 'dart:convert';

List<ProblemTake> problemTakeFromJson(String str) => List<ProblemTake>.from(
    json.decode(str).map((x) => ProblemTake.fromJson(x)));

String problemTakeToJson(List<ProblemTake> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProblemTake {
  ProblemTake({
    @required this.data,
    @required this.date,
    @required this.type,
    @required this.photo,
    @required this.areaId,
    @required this.fmId,
    @required this.number,
    @required this.problemsData,
    @required this.solvingData,
    @required this.index,
    @required this.fertilizer,
    @required this.fertilizerId,
    @required this.fertilizerType,
    @required this.time,
    @required this.amount,
    @required this.unitId,
    @required this.unitEng,
  });

  final String data;
  final String date;
  final String type;
  final String photo;
  final dynamic areaId;
  final String fmId;
  final int number;
  final String problemsData;
  final String solvingData;
  final int index;
  final Fertilizer fertilizer;
  final String fertilizerId;
  final String fertilizerType;
  final String time;
  final int amount;
  final String unitId;
  final String unitEng;

  factory ProblemTake.fromJson(Map<String, dynamic> json) => ProblemTake(
        data: json["data"] == null ? null : json["data"],
        date: json["date"],
        type: json["type"],
        photo: json["photo"] == null ? null : json["photo"],
        areaId: json["area_id"],
        fmId: json["fm_id"] == null ? null : json["fm_id"],
        number: json["number"] == null ? null : json["number"],
        problemsData:
            json["problems_data"] == null ? null : json["problems_data"],
        solvingData: json["solving_data"] == null ? null : json["solving_data"],
        index: json["index"] == null ? null : json["index"],
        fertilizer: json["fertilizer"] == null
            ? null
            : Fertilizer.fromJson(json["fertilizer"]),
        fertilizerId:
            json["fertilizer_id"] == null ? null : json["fertilizer_id"],
        fertilizerType:
            json["fertilizer_type"] == null ? null : json["fertilizer_type"],
        time: json["time"] == null ? null : json["time"],
        amount: json["amount"] == null ? null : json["amount"],
        unitId: json["unit_id"] == null ? null : json["unit_id"],
        unitEng: json["unit_eng"] == null ? null : json["unit_eng"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data,
        "date": date,
        "type": type,
        "photo": photo == null ? null : photo,
        "area_id": areaId,
        "fm_id": fmId == null ? null : fmId,
        "number": number == null ? null : number,
        "problems_data": problemsData == null ? null : problemsData,
        "solving_data": solvingData == null ? null : solvingData,
        "index": index == null ? null : index,
        "fertilizer": fertilizer == null ? null : fertilizer.toJson(),
        "fertilizer_id": fertilizerId == null ? null : fertilizerId,
        "fertilizer_type": fertilizerType == null ? null : fertilizerType,
        "time": time == null ? null : time,
        "amount": amount == null ? null : amount,
        "unit_id": unitId == null ? null : unitId,
        "unit_eng": unitEng == null ? null : unitEng,
      };
}

class Fertilizer {
  Fertilizer({
    @required this.fertilizerId,
    @required this.fertilizerType,
    @required this.takeVolume,
    @required this.unitId,
    @required this.unitEng,
  });

  final String fertilizerId;
  final String fertilizerType;
  final int takeVolume;
  final String unitId;
  final String unitEng;

  factory Fertilizer.fromJson(Map<String, dynamic> json) => Fertilizer(
        fertilizerId: json["fertilizer_id"],
        fertilizerType: json["fertilizer_type"],
        takeVolume: json["take_volume"],
        unitId: json["unit_id"],
        unitEng: json["unit_eng"],
      );

  Map<String, dynamic> toJson() => {
        "fertilizer_id": fertilizerId,
        "fertilizer_type": fertilizerType,
        "take_volume": takeVolume,
        "unit_id": unitId,
        "unit_eng": unitEng,
      };
}
