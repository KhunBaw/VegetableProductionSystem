import 'package:meta/meta.dart';
import 'dart:convert';

List<Notificationss> notificationssFromJson(String str) =>
    List<Notificationss>.from(
        json.decode(str).map((x) => Notificationss.fromJson(x)));

String notificationssToJson(List<Notificationss> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notificationss {
  Notificationss({
    @required this.id,
    @required this.title,
    @required this.subtitle,
    @required this.date,
    @required this.time,
  });

  final int id;
  final String title;
  final String subtitle;
  final String date;
  final String time;

  factory Notificationss.fromJson(Map<String, dynamic> json) => Notificationss(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        date: json["date"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "date": date,
        "time": time,
      };
}
