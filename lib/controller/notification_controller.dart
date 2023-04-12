import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fafte/main.dart';
import 'package:fafte/models/notification.dart';
import 'package:fafte/utils/export.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationController extends ChangeNotifier {
  NotificationController._privateConstructor();
  static final NotificationController instance =
      NotificationController._privateConstructor();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendNotification(
      String title, String content, String token) async {
    final _serverKey = serverKey;
    final url = 'https://fcm.googleapis.com/fcm/send';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverKey',
    };

    final body = {
      'notification': {
        'title': title,
        'body': content,
        'sound': 'default',
        'color': '#990000',
      },
      'to': token,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Notification sending failed with status ${response.statusCode}');
    }
  }

  Future<List<NotificationModel>> fetchNotifications(String userId) async {
    final querySnapshot = await firestore
        .collection('notifications')
        .where('recipientId', isEqualTo: userId)
        .get();

    List<NotificationModel> notifications = [];

    querySnapshot.docs.forEach((doc) {
      notifications.add(NotificationModel.fromJson(doc.data()));
    });
    // notifications.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
    return notifications;
  }
}
