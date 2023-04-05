import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Navigate to target screen (widget).
///
/// [screen] Target screen that we want to navigate to.
///
/// [transition] Transition effect.
///
/// [clearStack] If provided (= true), go to next screen and clear all previous
/// screens.
///
/// [offCurrentScreen] If provided (= true), go to next screen and can not go
/// back to current screen.
///
/// [preventDuplicates] By default, GetX will prevent you from push a route that
/// you already in, if you want to push anyway, set preventDuplicates to false.
///

String? lastRoute;

Future<dynamic> navigateTo(Widget screen,
    {Transition transition = Transition.downToUp,
    bool clearStack = false,
    bool offCurrentScreen = false,
    bool preventDuplicates = true,
    bool popGesture = false,
    Duration? duration = const Duration(milliseconds: 250)}) async {
  lastRoute = screen.runtimeType.toString();
  if (clearStack) {
    return await Get.offAll(() => screen,
        transition: transition, duration: duration);
  } else if (offCurrentScreen) {
    return await Get.off(() => screen,
        transition: transition,
        duration: duration,
        preventDuplicates: preventDuplicates);
  } else {
    final upcoming = screen.runtimeType.toString();
    final current = ModalRoute.of(Get.context!)?.settings.name;
    if (upcoming == current && preventDuplicates) {
      return;
    }
    return await Get.to(() => screen,
        transition: transition,
        duration: duration,
        popGesture: popGesture,
        preventDuplicates: preventDuplicates);
  }
}
