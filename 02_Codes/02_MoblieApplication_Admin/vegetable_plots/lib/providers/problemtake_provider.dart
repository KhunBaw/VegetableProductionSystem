import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegetable_plots/models/problem_take.dart';

class ProblemTakes with ChangeNotifier {
  List<ProblemTake> _items = [];

  List<ProblemTake> get items {
    return _items;
  }

  void loadProblemTakes(String pd_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(dotenv.env['api_url'] + 'production/pt/' + pd_id);

    String token = prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json",
      // // Authorize Header
      "Authorization": "bearer $token",
    };

    http
        .get(
      url, //Edit url
      headers: headers,
    )
        .then((response) {
      if (response.statusCode == 200) {
        _items = problemTakeFromJson(response.body);

        EasyLoading.dismiss();
        notifyListeners();
      } else {
        EasyLoading.showError('Error');
        throw Exception('Failed to load orders');
      }
    });
  }

  void addProblem(String pd_id, String problem_date, String problems_data,
      String solving_data, String area_id, int number) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = jsonEncode(<String, dynamic>{
      'fm_id': prefs.getString('username'),
      'problem_date': problem_date,
      'problems_data': problems_data,
      'solving_data': solving_data,
      'area_id': area_id,
      'number': number
    });

    var url = Uri.parse(dotenv.env['api_url'] + 'production/problem/' + pd_id);

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
      EasyLoading.showError('ผิดพลาด');
    } finally {
      http.Client().close();
    }
  }

  void updateProblem(String pd_id, String problem_date, String problems_data,
      String solving_data, String area_id, int number, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = jsonEncode(<String, dynamic>{
      'fm_id': prefs.getString('username'),
      'problem_date': problem_date,
      'problems_data': problems_data,
      'solving_data': solving_data,
      'area_id': area_id,
      'number': number
    });

    var url = Uri.parse(dotenv.env['api_url'] +
        'production/problem/' +
        pd_id +
        '?index=' +
        index.toString());

    String token = prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json",
      // // Authorize Header
      "Authorization": "bearer $token",
    };
    try {
      await http
          .put(
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
      EasyLoading.showError('ผิดพลาด');
    } finally {
      http.Client().close();
    }
  }
}
