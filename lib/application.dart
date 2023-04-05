import 'dart:io';

import 'package:fafte/controller/bottom_bar_visibility_provider.dart';
import 'package:fafte/controller/chat_controller.dart';
import 'package:fafte/controller/friend_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fafte/controller/auth_controller.dart';
import 'package:fafte/generated/l10n.dart';
import 'package:fafte/theme/app_theme.dart';
import 'package:fafte/ui/authenticate/splash_screen.dart';
import 'package:provider/provider.dart';

class MealPlanner extends StatefulWidget {
  const MealPlanner({super.key});

  @override
  State<MealPlanner> createState() => _MealPlannerState();
}

class _MealPlannerState extends State<MealPlanner> {
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
