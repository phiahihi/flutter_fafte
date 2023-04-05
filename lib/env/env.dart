import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

late ActiveEnv activeEnv;

// Change to false for production
bool get dev => (activeEnv == ActiveEnv.prod && !kDebugMode) ? false : true;
Level get loggerLevel =>
    activeEnv != ActiveEnv.prod ? Level.debug : Level.nothing;

Future<String> getConfigEnvFile() async {
  final packageInfo = await PackageInfo.fromPlatform();
  switch (packageInfo.packageName) {
    case "app.vcomply.mobile":
      activeEnv = ActiveEnv.prod;
      return 'lib/env/.env';
    case "app.vcomply.mobile.beta":
      activeEnv = ActiveEnv.dev;
      return 'lib/env/.dev_env';
    default:
      activeEnv = ActiveEnv.dev;
      return 'lib/env/.dev_env';
  }
}

// const bool isProduction = bool.fromEnvironment('dart.vm.product');

enum ActiveEnv { dev, prod }
