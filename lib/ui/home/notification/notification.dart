import 'package:fafte/controller/notification_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/models/notification.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/home/post/widget/detail_post_screen.dart';
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_notificationController == null) {
  //     // isLoading = false;
  //     _notificationController = Provider.of<NotificationController>(context);
  //     _notificationController?.getAllNotification();
  //     setState(() {});
  //   }
  //   setState(() {
  //     // isLoading = true;
  //   });
  // }

  Future<void> _detailPost(NotificationModel notificationModel) async {
    final post = await _postController.getPost(notificationModel.postId!);
    final user =
        await _postController.getPoster(notificationModel.recipientId!);
    navigateTo(DetailPostScreen(
      model: post,
      userModel: user,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Thông báo'),
        centerTitle: true,
        backgroundColor: splashColor,
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: _notificationController?.listNotificationModel.length,
          itemBuilder: (context, index) {
            final notification =
                _notificationController?.listNotificationModel[index];

            return FutureBuilder<UserModel>(
                future: _postController.getPoster(notification?.senderId ?? ''),
                builder: (context, AsyncSnapshot<UserModel> snapshot) {
                  return notification?.read == true
                      ? ListTile(
                          onTap: () {
                            _detailPost(notification!);
                          },
                          leading: CircleAvatar(
                            backgroundImage: snapshot.data?.profileImageUrl ==
                                        null ||
                                    snapshot.data?.backgroundImageUrl == ''
                                ? null
                                : NetworkImage(snapshot.data!.profileImageUrl!),
                          ),
                          title: Text(notification?.body ?? ''),
                          subtitle: Text(notification?.title ?? ''),
                        )
                      : ListTile(
                          onTap: () {
                            _detailPost(notification!);
                          },
                          leading: CircleAvatar(
                            backgroundImage: snapshot.data?.profileImageUrl ==
                                        null ||
                                    snapshot.data?.profileImageUrl == ''
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
        ),
      ),
    );
  }
}
