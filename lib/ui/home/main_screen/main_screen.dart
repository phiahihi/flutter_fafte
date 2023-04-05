import 'package:fafte/controller/user_controller.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/theme/colors.dart';
import 'package:fafte/theme/sizes.dart';
import 'package:fafte/ui/home/chat/chat.dart';
import 'package:fafte/ui/home/friend/friend.dart';
import 'package:fafte/ui/home/menu/menu_screen.dart';
import 'package:fafte/ui/home/post/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ScrollController? _hideButtonController;

  bool _isVisible = true;
  @override
  initState() {
    super.initState();

    _hideButtonController = new ScrollController();
    _hideButtonController?.addListener(() {
      if (_hideButtonController?.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible)
          setState(() {
            _isVisible = false;
            print("**** $_isVisible up");
          });
      }
      if (_hideButtonController?.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible)
          setState(() {
            _isVisible = true;
            print("**** $_isVisible down");
          });
      }
    });
  }

  // @override
  // void dispose() {
  //   // controller.dispose();
  //   super.dispose();
  // }

  // void hideNav() {
  //   setState(() {
  //     visible = false;
  //   });
  // }

  // void showNav() {
  //   setState(() {
  //     visible = true;
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userController == null) {
      print('ss');
      UserController.instance.getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          PostScreen(
            controller: _hideButtonController!,
          ),
          FriendScreen(),
          ChatScreen(),
          Container(),
          MenuScreen(),
        ],
      ),
      bottomNavigationBar: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _isVisible ? Sizes.s56 : 0.0,
          child: Wrap(children: [
            BottomNavigationBar(
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(Assets.home),
                    activeIcon:
                        SvgPicture.asset(Assets.home, color: splashColor),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(Assets.users),
                    activeIcon:
                        SvgPicture.asset(Assets.users, color: splashColor),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(Assets.messageSquare),
                    activeIcon: SvgPicture.asset(Assets.messageSquare,
                        color: splashColor),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(Assets.bell),
                    activeIcon:
                        SvgPicture.asset(Assets.bell, color: splashColor),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(Assets.menu),
                    activeIcon:
                        SvgPicture.asset(Assets.menu, color: splashColor),
                    label: ''),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: splashColor,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
            ),
          ])),
    );
  }
}
