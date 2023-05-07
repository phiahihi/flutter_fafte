import 'package:fafte/controller/chat_controller.dart';
import 'package:fafte/controller/friend_controller.dart';
import 'package:fafte/controller/notification_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/controller/user_controller.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/theme/colors.dart';
import 'package:fafte/theme/text_style.dart';
import 'package:fafte/ui/home/chat/chat.dart';
import 'package:fafte/ui/home/friend/friend.dart';
import 'package:fafte/ui/home/menu/menu_screen.dart';
import 'package:fafte/ui/home/notification/notification.dart';
import 'package:fafte/ui/home/post/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLogin = false;
  int _selectedIndex = 0;

  UserController? userController;
  NotificationController notificationController =
      NotificationController.instance;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        PostController.instance.getAllPost();
      }
      if (index == 1) {
        FriendController.instance.get10Invitation();
        FriendController.instance.getAllInvitation();
      }
      if (index == 2) {
        ChatController.instance.getAllBoxChat();
      }
      if (index == 3) {
        NotificationController.instance.getAllNotification();
      }
      if (index == 4) {
        UserController.instance.getUser();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userController == null) {
      UserController.instance.getUser();
      NotificationController.instance.getAllNotification();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationController.instance.getAllNotification();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          PostScreen(),
          FriendScreen(),
          ChatScreen(),
          NotificationScreen(),
          MenuScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(Assets.home),
              activeIcon: SvgPicture.asset(Assets.home, color: splashColor),
              label: ''),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(Assets.users),
              activeIcon: SvgPicture.asset(Assets.users, color: splashColor),
              label: ''),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(Assets.messageSquare),
              activeIcon:
                  SvgPicture.asset(Assets.messageSquare, color: splashColor),
              label: ''),
          BottomNavigationBarItem(
              icon: Badge(
                label: Text(
                  notificationController.listNotificationModel.length
                      .toString(),
                  style: pt12Regular(context).copyWith(color: white),
                ),
                child: SvgPicture.asset(Assets.bell),
              ),
              activeIcon: Badge(
                label: Text(
                  notificationController.listNotificationModel.length
                      .toString(),
                  style: pt12Regular(context).copyWith(color: white),
                ),
                child: SvgPicture.asset(
                  Assets.bell,
                  color: splashColor,
                ),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(Assets.menu),
              activeIcon: SvgPicture.asset(Assets.menu, color: splashColor),
              label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: splashColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
