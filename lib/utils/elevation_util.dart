import 'package:flutter/material.dart';

BoxDecoration elevatedDecoration(Color color) {
  return BoxDecoration(
    color: color,
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.grey.shade800.withOpacity(0.15),
        blurRadius: 15,
        offset: Offset(0, 0.5),
      ),
    ],
  );
}
