import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkFirstOpen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool firstOpen = prefs.getBool("first_open") ?? true;
  return firstOpen;
}
