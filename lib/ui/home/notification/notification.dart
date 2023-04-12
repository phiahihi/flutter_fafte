import 'package:fafte/controller/notification_controller.dart';
import 'package:fafte/models/notification.dart';
import 'package:fafte/utils/export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _notificationController = NotificationController.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NotificationModel>>(
        future: _notificationController
            .fetchNotifications(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, AsyncSnapshot<List<NotificationModel>> snapshot) {
          final notifications = snapshot.data;
          return notifications == null
              ? SizedBox()
              : ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Dismissible(
                        key: Key(notification.timestamp.toString()),
                        onDismissed: (direction) {
                          // Xử lý khi người dùng xóa notification
                        },
                        child: notification.type == 'friend_request'
                            ? ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(notification.body!),
                                ),
                                title: Text(notification.body!),
                                subtitle: Text(notification.body!),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // Xử lý khi người dùng chấp nhận lời mời kết bạn
                                      },
                                      icon: Icon(Icons.check),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // Xử lý khi người dùng từ chối lời mời kết bạn
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ],
                                ),
                              )
                            : ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(notification.type!),
                                ),
                                title: Text(notification.body!),
                                subtitle: Text(notification.title!),
                              ));
                  },
                );
        });
  }
}
