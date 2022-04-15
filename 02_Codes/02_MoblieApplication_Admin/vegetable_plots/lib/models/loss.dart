import 'package:meta/meta.dart';
import 'dart:convert';

Loss lossFromJson(String str) => Loss.fromJson(json.decode(str));

String lossToJson(Loss data) => json.encode(data.toJson());

class Loss {
    Loss({
        @required this.loss,
    });

    final int loss;

    factory Loss.fromJson(Map<String, dynamic> json) => Loss(
        loss: json["loss"] == null ? 0 : json["loss"],
    );

    Map<String, dynamic> toJson() => {
        "loss": loss == null ? 0 : loss,
    };
}