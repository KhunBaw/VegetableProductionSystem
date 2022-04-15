import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];
  bool _status = true;

  bool get status {
    return _status;
  }

  List<Order> get items {
    return _items;
  }

  void loadOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print('ดึงคำสั่งซื้อ');

    var url = Uri.parse(dotenv.env['api_url'] + 'vegetable_order');

    String token = prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json",
      // Authorize Header
      "Authorization": "bearer $token",
    };

    http
        .get(
      url, //Edit url
      headers: headers,
    )
        .then((response) {
      if (response.statusCode == 200) {
        //Code for status 200
        _items = orderFromJson(response.body);
        notifyListeners();
        _status = false;
      } else {
        EasyLoading.showError('Error ${response.statusCode}');
        throw Exception('Failed to load orders');
      }
    }).catchError((error) {
      EasyLoading.showError('Error ${error.statusCode}');
      throw Exception('Failed to load orders');
    });
  }
}
