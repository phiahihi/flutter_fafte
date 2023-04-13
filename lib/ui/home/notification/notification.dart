import 'package:fafte/controller/notification_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/utils/export.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController? _notificationController;
  final _postController = PostController.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_notificationController == null) {
      // isLoading = false;
      _notificationController = Provider.of<NotificationController>(context);
      _notificationController?.getAllNotification();
      setState(() {});
    }
    setState(() {
      // isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _notificationController?.listNotificationModel.length,
      itemBuilder: (context, index) {
        final notification =
            _notificationController?.listNotificationModel[index];

        return FutureBuilder<UserModel>(
            future: _postController.getPoster(notification?.senderId ?? ''),
            builder: (context, AsyncSnapshot<UserModel> snapshot) {
              return notification?.read == true
                  ? ListTile(
                      selected: true,
                      selectedColor: splashColor,
                      selectedTileColor: splashColor,
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data?.profileImageUrl ?? ''),
                      ),
                      title: Text(notification?.body ?? ''),
                      subtitle: Text(notification?.body ?? ''),
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
                        backgroundImage: snapshot.data?.profileImageUrl == null
                            ? null
                            : NetworkImage(snapshot.data!.profileImageUrl!),
                      ),
                      selectedTileColor: splashColor.withOpacity(0.1),
                      selected: true,
                      title: Text(notification?.body ?? ''),
                      subtitle: Text(notification?.title ?? ''),
                    );
            });
      },
    );
  }
}
