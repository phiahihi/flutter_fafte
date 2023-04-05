// import 'dart:io';

// import 'package:fafte/env/env.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// // import 'package:fafte/ui/widget/notification/nofication.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

// class OneSignalService {
//   static init() {
//     try {
//       //Remove this method to stop OneSignal Debugging
//       OneSignal.shared.setLogLevel(
//         dev ? OSLogLevel.error : OSLogLevel.none,
//         dev ? OSLogLevel.none : OSLogLevel.none,
//       );

//       OneSignal.shared.setAppId(dotenv.env["ONE_SIGNAL_APP_ID"] ?? "");

//       // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt.
//       // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//       Platform.isIOS
//           ? OneSignal.shared
//               .promptUserForPushNotificationPermission()
//               .then((accepted) {
//               print("Accepted permission: $accepted");
//             })
//           : null;

//       OneSignal.shared.setNotificationWillShowInForegroundHandler(
//           (OSNotificationReceivedEvent event) {
//         // Will be called whenever a notification is received in foreground
//         // Display Notification, pass null param for not displaying the notification
//         // Or event.notification to keep the background notification
//         event.complete(null);
//         FlutterRingtonePlayer.playNotification();
//         if (event.notification.title != null ||
//             event.notification.body != null) {
//           showSnackbar(
//             event.notification.title,
//             event.notification.body,
//           );
//         }
//       });

//       OneSignal.shared
//           .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
//         // Will be called whenever a notification is opened/button pressed.
//       });

//       OneSignal.shared
//           .setPermissionObserver((OSPermissionStateChanges changes) {
//         // Will be called whenever the permission changes
//         // (ie. user taps Allow on the permission prompt in iOS)
//       });

//       OneSignal.shared
//           .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
//         // Will be called whenever the subscription changes
//         // (ie. user gets registered with OneSignal and gets a user ID)
//       });

//       OneSignal.shared.setEmailSubscriptionObserver(
//           (OSEmailSubscriptionStateChanges emailChanges) {
//         // Will be called whenever then user's email subscription changes
//         // (ie. OneSignal.setEmail(email) is called and the user gets registered
//       });
//     } catch (e) {}
//   }

//   static void setOnesignalUserId(String id) {
//     OneSignal.shared.setExternalUserId(id);
//   }

//   static Future<String?> getOnesignalUserId() async {
//     final status = await OneSignal.shared.getDeviceState();
//     final String? osUserID = status?.userId;
//     return osUserID;
//   }
// }
