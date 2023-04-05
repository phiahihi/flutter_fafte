import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

String? getDevicePlatform() {
  if (Platform.isAndroid) return 'Android';
  if (Platform.isIOS) return 'IOS';
  if (Platform.isFuchsia) return 'Fuchsia';
  if (Platform.isLinux) return 'Linux';
  if (Platform.isMacOS) return 'MacOS';
  if (Platform.isWindows) return 'Windows';
  return null;
}

Future<String?> platformVersion() async {
  String? version;
  if (Platform.isAndroid) {
    version = (await deviceInfo.androidInfo).version.release;
  }
  if (Platform.isIOS) {
    version = (await deviceInfo.iosInfo).systemVersion;
  }
  if (Platform.isLinux) {
    version = (await deviceInfo.linuxInfo).version;
  }
  if (Platform.isMacOS) {
    version = (await deviceInfo.macOsInfo).osRelease;
  }
  if (Platform.isWindows) {
    version = (await deviceInfo.windowsInfo).computerName;
  }
  return (getDevicePlatform() ?? '') + (version ?? '');
}

Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
  return null;
}
