import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

navigateToGoogleMap(double lat, double lng) async {
  var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  if (await canLaunchUrl(uri)) {
    await launchUrlString(uri.toString());
  } else {
    throw 'Could not launch ${uri.toString()}';
  }
}

launchMaps(double lat, double lng) async {
  String googleUrl = 'comgooglemaps://?center=$lat,$lng';
  String appleUrl = 'https://maps.apple.com/?sll=$lat,$lng';
  if (await canLaunchUrlString("comgooglemaps://")) {
    print('launching com googleUrl');
    await launchUrlString(googleUrl);
  } else if (await canLaunchUrlString(appleUrl)) {
    print('launching apple url');
    await launchUrlString(appleUrl);
  } else {
    throw 'Could not launch url';
  }
}

Future<bool> launchCaller(String? number) async {
  String url = "tel:$number";
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
    return true;
  } else {
    return false;
  }
}
