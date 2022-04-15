import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_plots/providers/area_provider.dart';
import 'package:vegetable_plots/providers/grow_provider.dart';
import 'package:vegetable_plots/providers/history_provider.dart';
import 'package:vegetable_plots/providers/order_provider.dart';
import 'package:vegetable_plots/providers/problems_provider.dart';
import 'package:vegetable_plots/providers/problemtake_provider.dart';
import 'package:vegetable_plots/screens/area/area_list.dart';
import 'package:vegetable_plots/screens/current_v/current_v_list.dart';
import 'package:vegetable_plots/screens/history/history_list.dart';
import 'package:vegetable_plots/screens/login.dart';
import 'package:vegetable_plots/screens/grow/grow_add.dart';
import 'package:vegetable_plots/screens/notification/notification_list.dart';
import 'package:vegetable_plots/screens/order/order_list.dart';
import 'providers/notification_provider.dart';
import 'screens/grow/grow_list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/subjects.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

// [Android-only] This "Headless Task" is run when the Android app
// is terminated with enableHeadless: true
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    Notifications().addallNotification();
    // print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  // print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  BackgroundFetch.finish(taskId);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight
  // ]);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  await _configureLocalTimeZone();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int id,
            String title,
            String body,
            String payload,
          ) async {
            didReceiveLocalNotificationSubject.add(
              ReceivedNotification(
                id: id,
                title: title,
                body: body,
                payload: payload,
              ),
            );
          });

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await dotenv.load();

  runApp(MyApp());

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 120,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          forceAlarmManager: false,
          startOnBoot: true,
          requiredNetworkType: NetworkType.ANY),
      (String taskId) async {
        // <-- Event handler
        // This is the fetch-event callback.
        // print("[BackgroundFetch] Event received $taskId");
        // print('ทดสอบการดึง ${DateTime.now()}');
        // ignore: await_only_futures
        await Notifications().loadNotification();
        // IMPORTANT:  You must signal completion of your task or the OS can punish your app
        // for taking too long in the background.
        BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        // <-- Task timeout handler.
        // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
        // print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
        BackgroundFetch.finish(taskId);
      },
    );
    // print('[BackgroundFetch] configure success: $status');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(411, 820),
        builder: () => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) {
                  return Grows();
                }),
                ChangeNotifierProvider(
                  create: (context) => Orders(),
                ),
                ChangeNotifierProvider(
                  create: (context) => Areas(),
                ),
                ChangeNotifierProvider(
                  create: (context) => Problems(),
                ),
                ChangeNotifierProvider(
                  create: (context) => ProblemTakes(),
                ),
                ChangeNotifierProvider(
                  create: (context) => Notifications(),
                ),
                ChangeNotifierProvider(
                  create: (context) => Historys(),
                ),
              ],
              child: MaterialApp(
                localizationsDelegates: [GlobalMaterialLocalizations.delegate],
                supportedLocales: [Locale('en', 'US'), Locale('th', 'TH')],
                title: 'การดูแลผัก',
                theme: ThemeData(
                  brightness: Brightness.light,
                  textTheme:
                      GoogleFonts.maliTextTheme(Theme.of(context).textTheme)
                          .copyWith(
                    bodyText2: GoogleFonts.mali(),
                  ),
                  colorScheme: ColorScheme.fromSwatch()
                      .copyWith(secondary: Colors.purple),
                ),
                home: LOGIN(),
                builder: EasyLoading.init(),
                routes: {
                  '/LOGIN': (context) => LOGIN(),
                  '/HOME': (context) => GrowList(),
                  '/HOME/ADD': (context) => MainAdd(),
                  '/Order': (context) => OrderList(),
                  '/Area': (context) => AreaList(),
                  '/Current_v': (context) => Current_v_List(),
                  '/History': (context) => History_List(),
                  '/Notification': (context) => Notification_List(),
                },
              ),
            ));
  }
}
