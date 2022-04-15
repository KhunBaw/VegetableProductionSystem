import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grow.dart';

class Historys with ChangeNotifier {
  List<Grow> _items = [];

  List<Grow> get items {
    return _items;
  }

  void loadHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(dotenv.env['api_url'] + 'productionH');

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
        if (jsonDecode(response.body).length != 0) {
          _items = growFromJson(response.body);
        } else {
          _items = growFromJson(response.body);
          EasyLoading.showInfo('ไม่พบข้อมูล');
        }

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
}
