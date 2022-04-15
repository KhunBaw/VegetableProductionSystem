import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegetable_plots/main.dart';
import '../models/notification.dart';

class Notifications with ChangeNotifier {
  List<Notificationss> _items = [];

  List<Notificationss> get items {
    return _items;
  }

  void loadNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(dotenv.env['api_url'] + 'notification');

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
        _items = notificationssFromJson(response.body);
        EasyLoading.dismiss();
        notifyListeners();
        addallNotification();
      } else {
        // EasyLoading.showError('Error');
      }
    });
  }

  Future<void> addallNotification() async {
    _showNotification();
    Future.delayed(Duration(seconds: 0), () {
      List<Notificationss> notifications = items;
      if (notifications.isEmpty) flutterLocalNotificationsPlugin.cancelAll();
      if (notifications.isNotEmpty) {
        notifications.forEach((element) {
          addNotification(element.id, element.title, element.subtitle,
              element.date, element.time);
        });
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      showNo();
    });
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Fetch', 'ดึงข้อมูล',
            importance: Importance.min,
            priority: Priority.min,
            ticker: 'ticker');

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        99, 'ดึงข้อมูล', 'ทดสอบดึงข้อมูล', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> showNo() async {
    List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    pendingNotificationRequests.forEach((element) {
      print(
          '${element.id} ${element.title} ${element.body} ${element.payload}');
    });
  }

  tz.TZDateTime _instanceOfTenAM(date, time) {
    var inputFormat = DateFormat('yyyy-MM-dd hh:mm');
    var now = inputFormat.parse('$date $time');
    var now2 = DateTime.now();

    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.getLocation('Asia/Bangkok'),
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now2.second,
        now2.millisecond,
        now2.microsecond);

    // if (scheduledDate.isBefore(now)) {
    //   scheduledDate = scheduledDate.add(const Duration(seconds: 15));
    // }
    // print(scheduledDate);
    return scheduledDate;
  }

  Future<void> addNotification(id, title, subtitle, date, time) async {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var now = inputFormat.parse('${date}');
    var now2 = inputFormat.parse('${DateTime.now()}');
    var now3 = inputFormat.parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day + 1}');

    if (now == now2 || now == now3) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          subtitle,
          _instanceOfTenAM(date, time),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'General',
              'แจ้งเตือนทั่วไป',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    }
  }
}
