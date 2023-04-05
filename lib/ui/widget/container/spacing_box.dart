import 'package:flutter/material.dart';
import 'package:fafte/theme/sizes.dart';

class SpacingBox extends StatelessWidget {
  final double h;
  final double w;
  const SpacingBox({this.h = 0, this.w = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h * Sizes.s1,
      width: w * Sizes.s1,
    );
  }
}
