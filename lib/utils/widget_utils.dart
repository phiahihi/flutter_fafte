import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const EdgeInsets zeroPadding = EdgeInsets.all(0);

extension ContextExtensions on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}

/// Use this method to call a function after build() method is completed.
void onWidgetBuildDone(Function function) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    function();
  });
}

dismissKeyboard(context) => FocusScope.of(context).requestFocus(FocusNode());