import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fafte/application.dart';
import 'package:fafte/env/env.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String serverKey =
    'AAAAVVExI54:APA91bHyc-67Z2wwA6BXjjvLc9o5Sc_mgVqGe8UAlT4eEAPGeA8Nl3ZAnqsQwJoyRunTT4T747ujcGnm_V8KvDBnAGBhdZbIFn377J-dfEYPne-0ylErhM6OU30Ksi-e-XGuf9V-mu6J';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
late FirebaseMessaging messaging;

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

// void notificationTapBackground(NotificationResponse notificationResponse) {
//   print('notification(${notificationResponse.id}) action tapped: '
//       '${notificationResponse.actionId} with'
//       ' payload: ${notificationResponse.payload}');
//   if (notificationResponse.input?.isNotEmpty ?? false) {
//     print(
//         'notification action tapped with input: ${notificationResponse.input}');
//   }
// }

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  //If subscribe based sent notification then use this token
  final fcmToken = await messaging.getToken();
  print(fcmToken);

  //If subscribe based on topic then use this
  await messaging.subscribeToTopic('flutter_notification');

  if (!kIsWeb) {
    channel = AndroidNotificationChannel(
        'flutter_notification', // id
        'flutter_notification_title',
        'flutter_notification_description', // title
        importance: Importance.high,
        enableLights: true,
        enableVibration: true,
        showBadge: true,
        playSound: true);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final android =
        AndroidInitializationSettings('@drawable/ic_notifications_icon');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin!.initialize(
      initSettings,
      onSelectNotification: (payload) async {
        print(payload);
      },
    );

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  await setUp();
  runApp(MealPlanner());
}

Future<void> setUp() async {
  try {
    await dotenv.load(fileName: await getConfigEnvFile());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  } catch (e) {
    log(e.toString());
  }
}
