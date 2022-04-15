import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegetable_plots/models/vegetable_data.dart';
import '../models/grow.dart';
import 'problemtake_provider.dart';

class Grows with ChangeNotifier {
  List<Grow> _items = [];
  List<VegetableData> _items_v = [];

  List<Grow> get items {
    return _items;
  }

  List<VegetableData> get items_v {
    return _items_v;
  }

  void loadGrow() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(dotenv.env['api_url'] + 'production');

    String token = prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json",
      // // Authorize Header
      "Authorization": "bearer $token",
    };
    try {
      await http
          .get(
        url, //Edit url
        headers: headers,
      )
          .then((response) {
        if (jsonDecode(response.body)['data_body'].length != 0) {
          _items = List<Grow>.from(jsonDecode(response.body)['data_body']
              .map((bk) => Grow.fromJson(bk)));
        } else {
          _items = List<Grow>.from(jsonDecode(response.body)['data_body']
              .map((bk) => Grow.fromJson(bk)));
          EasyLoading.showInfo('ไม่พบข้อมูล');
        }

        _items_v = List<VegetableData>.from(
            jsonDecode(response.body)['vegetable']
                .map((bk) => VegetableData.fromJson(bk)));

        notifyListeners();
      }).catchError((error) {
        EasyLoading.showError('ไม่สามารถดึงข้อมูลได้');
      }).timeout(Duration(seconds: 10), onTimeout: () {
        EasyLoading.showError('หมดเวลา');
        http.Client().close();
      });
    } finally {
      EasyLoading.dismiss();
      http.Client().close();
    }
  }

  void addGrow(String v_id, List<String> area_id, List<String> order_id,
      int number) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = jsonEncode(<String, dynamic>{
      'v_id': v_id,
      'area_id': area_id,
      'order_id': order_id,
      'number': number
    });

    var url = Uri.parse(dotenv.env['api_url'] + 'production');

    String token = prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json",
      // // Authorize Header
      "Authorization": "bearer $token",
    };
    try {
      await http
          .post(
        url, //Edit url
        headers: headers,
        body: data,
      )
          .then((response) {
        if (response.statusCode == 200) {
          //Code for status 200
          EasyLoading.show(status: 'กำลังโหลด...');
          loadGrow();
          EasyLoading.showSuccess(response.body);
        } else {
          EasyLoading.showError('ผิดพลาด');
          throw Exception('Failed');
        }
      });
    } catch (e) {
      http.Client().close();
    }
  }

  void photoGrow(File photo, String id, String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(data);

    var url = Uri.parse(dotenv.env['api_url'] + 'production/ph/' + id);

    String token = prefs.getString('token');
    Map<String, String> headers = {};
    if (photo == null)
      headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-type": "application/json",
        // "Content-type": "multipart/form-data",
        // // Authorize Header
        "Authorization": "bearer $token",
      };
    else
      headers = {
        // "Content-Type": "application/x-www-form-urlencoded",
        // "Content-type": "application/json",
        "Content-type": "multipart/form-data",
        // // Authorize Header
        "Authorization": "bearer $token",
      };

    try {
      var request = http.MultipartRequest('POST', url);

      request.fields['type'] = type;

      if (photo != null) {
        request.files.add(
          http.MultipartFile(
              'file', photo.readAsBytes().asStream(), photo.lengthSync(),
              filename: photo.path.split("/").last),
        );
      }

      request.headers.addAll(headers);

      var response = await request.send();
      if (response.statusCode == 200) {
        ProblemTakes().loadProblemTakes(id);
      }
    } catch (e) {
      http.Client().close();
    }
  }

  void addTake(String date, String fertilizerId, String fertilizerType,
      String unit_id, int number, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    EasyLoading.show(status: 'กำลังโหลด...');
    String data = jsonEncode(<String, dynamic>{
      'fertilizerId': fertilizerId,
      'fertilizerType': fertilizerType,
      'take_volume': number,
      'unit_id': unit_id,
      'take_date': date,
      'fm_id': prefs.getString('username')
    });

    var url = Uri.parse(dotenv.env['api_url'] + 'production/take/' + id);

    String token = prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json",
      // // Authorize Header
      "Authorization": "bearer $token",
    };
    try {
      await http
          .post(
        url, //Edit url
        headers: headers,
        body: data,
      )
          .then((response) {
        if (response.statusCode == 200) {
          //Code for status 200
          EasyLoading.showSuccess(response.body);
        } else {
          EasyLoading.showError('ผิดพลาด');
          throw Exception('Failed');
        }
      });
    } catch (e) {
      http.Client().close();
    }
  }
}
