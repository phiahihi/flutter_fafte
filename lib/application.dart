import 'dart:convert';
import 'dart:io';

import 'package:fafte/controller/bottom_bar_visibility_provider.dart';
import 'package:fafte/controller/chat_controller.dart';
import 'package:fafte/controller/friend_controller.dart';
import 'package:fafte/controller/notification_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/main.dart';
import 'package:fafte/ui/home/main_screen/main_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:fafte/controller/auth_controller.dart';
import 'package:fafte/generated/l10n.dart';
import 'package:fafte/theme/app_theme.dart';
import 'package:fafte/ui/authenticate/splash_screen.dart';
import 'package:provider/provider.dart';

class FafteFlutter extends StatefulWidget {
  const FafteFlutter({super.key});

  @override
  State<FafteFlutter> createState() => _FafteFlutterState();
}

class _FafteFlutterState extends State<FafteFlutter> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    setupInteractedMessage();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      RemoteNotification? notification = message?.notification!;

      print(notification != null ? notification.title : '');
    });

    FirebaseMessaging.onMessage.listen((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null && !kIsWeb) {
        String action = jsonEncode(message.data);

        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channel!.description,
                priority: Priority.high,
                importance: Importance.max,
                setAsGroupSummary: true,
                styleInformation: DefaultStyleInformation(true, true),
                largeIcon:
                    DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
                channelShowBadge: true,
                autoCancel: true,
                icon: '@drawable/ic_notifications_icon',
              ),
            ),
            payload: action);
      }
      print('A new event was published!');
    });

    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message.data));
  }

  Future<dynamic> onSelectNotification(payload) async {
    Map<String, dynamic> action = jsonDecode(payload);
    _handleMessage(action);
  }

  Future<void> setupInteractedMessage() async {
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) => _handleMessage(value != null ? value.data : Map()));
  }

  void _handleMessage(Map<String, dynamic> data) {
    if (data['redirect'] == "product") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>(
            create: (_) => AuthController.instance,
          ),
          ChangeNotifierProvider<ChatController>(
            create: (_) => ChatController.instance,
          ),
          ChangeNotifierProvider<BottomBarVisibilityProvider>(
            create: (_) => BottomBarVisibilityProvider(),
          ),
          ChangeNotifierProvider<PostController>(
            create: (_) => PostController.instance,
          ),
          ChangeNotifierProvider<FriendController>(
            create: (_) => FriendController.instance,
          ),
          ChangeNotifierProvider<NotificationController>(
            create: (_) => NotificationController.instance,
          ),
        ],
        child: Platform.isIOS
            ? CupertinoApp(
                debugShowCheckedModeBanner: false,
                theme: defaultThemeIOS,
                navigatorKey: Get.key,
                localizationsDelegates: localization,
                supportedLocales: S.delegate.supportedLocales,
                home: SplashScreen(),
              )
            : MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: defaultThemeAndroid,
                navigatorKey: Get.key,
                localizationsDelegates: localization,
                supportedLocales: S.delegate.supportedLocales,
                home: SplashScreen(),
              ),
      ),
    );
  }
}
