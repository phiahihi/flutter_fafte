import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void showSnackBar(String text, {bool clear = true}) {
    if (clear) clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: Text(text,
            style: Theme.of(this)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white))));
  }

  void clearSnackBars() => ScaffoldMessenger.of(this).clearSnackBars();
}
