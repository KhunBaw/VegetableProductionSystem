import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/area.dart';

class Areas with ChangeNotifier {
  List<Area> _items = [];

  List<Area> get items {
    return _items;
  }

  loadArea() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(dotenv.env['api_url'] + 'area');

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
        //Code for status 200
        _items = areaFromJson(response.body);
        // EasyLoading.dismiss();
        notifyListeners();
      } else {
        EasyLoading.showError('Error');
        throw Exception('Failed to load areas');
      }
    });
  }
}
