import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fafte/generated/l10n.dart';
import 'package:fafte/theme/colors.dart';

const List<LocalizationsDelegate> localization = [
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

// /// Use this method to get all colors
// AppColor getColor(context) => AppTheme.colors(context);

/// The default theme configuration IOS.
CupertinoThemeData defaultThemeIOS = CupertinoThemeData(
    brightness: Brightness.light,
    textTheme:
        CupertinoTextThemeData(textStyle: TextStyle(fontFamily: 'Avenir')));

// /// The default theme configuration Android.
ThemeData defaultThemeAndroid = ThemeData(
    brightness: Brightness.light,
    primaryColor: redPrimary,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: redPrimary,
      selectionColor: blackAccent,
      selectionHandleColor: redPrimary,
    ),
    fontFamily: 'Avenir');

// class AppColor {
//   // Backgrounds
//   Color bgAppBarColor;
//   Color bgBackgroundColor;
//   Color bgSemiBg;
//   Color bgTransColor;
//   Color bgFrostedGlass;
//   Color bgCardColor;
//   Color bgCardColor2;
//   // Text
//   Color textColorPrimary;
//   Color textColorPrimary2;
//   Color textColorPrimary3;
//   Color textColorPrimary4;
//   Color textColorPrimary5;
//   Color textColorPrimary6;
//   Color textColorPrimary7;
//   Color textColorPrimary8;

//   Color textColorSecondary;
//   Color textColorGrey;
//   Color textLinkColor;
//   // Icon
//   Color iconColorPrimary;
//   Color iconColorSecondary;
//   // Button
//   Color bgIconButtonColor;
//   Color bgButtonColor;
//   Color bgButtonDarkColor;
//   Color bgButtonWarningColor;
//   Color bgButtonBlueColor;

//   // Linear Progress
//   Color bgLinearActiveProgress;
//   Color bgLinearInActiveProgress;
//   // Circle Progress
//   Color bgCircleActiveProgress;
//   Color bgCircleInActiveProgress;

//   // Divide
//   Color divideColor;
//   Color borderColor;
//   Color borderColor2;
//   Color borderBlueColor;
//   Color borderGreyColor;
//   // Action
//   Color textColorAction;
//   Color iconColorAction;

//   factory AppColor.createDarkThemColor() {
//     return AppColor(
//       borderGreyColor: grey6,
//       borderBlueColor: blue4,
//       bgButtonBlueColor: blue3,
//       textColorPrimary8: yellow3,
//       borderColor2: yellow2,
//       textColorPrimary7: orange,
//       textColorPrimary6: white3,
//       textColorPrimary5: green3,
//       bgCircleActiveProgress: green2,
//       bgCircleInActiveProgress: white2,
//       bgCardColor2: orange3,
//       textColorPrimary4: red2,
//       textColorPrimary3: grey5,
//       textColorPrimary2: black2,
//       bgLinearInActiveProgress: grey4,
//       bgLinearActiveProgress: grey1,
//       bgAppBarColor: semiBlack,
//       bgBackgroundColor: black,
//       bgTransColor: transBlack.withOpacity(0.6),
//       bgFrostedGlass: glassBlack.withOpacity(0.9),
//       bgCardColor: semiBlack2,
//       textColorPrimary: white,
//       textColorSecondary: white,
//       textLinkColor: blue,
//       textColorAction: red,
//       iconColorPrimary: white,
//       iconColorSecondary: greyLight,
//       iconColorAction: red,
//       bgIconButtonColor: lightBlack,
//       bgButtonColor: orange,
//       bgButtonDarkColor: semiBlack2,
//       bgButtonWarningColor: red,
//       divideColor: orange1,
//       borderColor: orange4,
//       bgSemiBg: darkBlack,
//       textColorGrey: grey,
//     );
//   }

//   factory AppColor.createLightThemColor() {
//     return AppColor(
//       borderGreyColor: grey6,
//       borderBlueColor: blue4,
//       bgButtonBlueColor: blue3,
//       textColorPrimary8: yellow3,
//       borderColor2: yellow2,
//       textColorPrimary7: orange,
//       textColorPrimary6: white3,
//       textColorPrimary5: green3,
//       bgCircleInActiveProgress: white2,
//       bgCircleActiveProgress: green2,
//       bgCardColor2: orange3,
//       textColorPrimary4: red2,
//       textColorPrimary3: grey5,
//       textColorPrimary2: black2,
//       bgLinearActiveProgress: grey1,
//       bgLinearInActiveProgress: grey4,
//       bgAppBarColor: white,
//       bgBackgroundColor: white,
//       bgTransColor: transWhite.withOpacity(0.6),
//       bgFrostedGlass: greyLight.withOpacity(0.6),
//       bgCardColor: greyLight,
//       textColorPrimary: lightBlack,
//       textColorSecondary: white,
//       textLinkColor: blue,
//       textColorAction: red,
//       iconColorPrimary: lightBlack,
//       iconColorSecondary: grey,
//       iconColorAction: red,
//       bgIconButtonColor: greyLight,
//       bgButtonColor: orange,
//       bgButtonDarkColor: greyWhite,
//       bgButtonWarningColor: red,
//       divideColor: orange1,
//       borderColor: orange4,
//       bgSemiBg: lighWhite,
//       textColorGrey: grey,
//     );
//   }

//   AppColor({
//     required this.borderGreyColor,
//     required this.borderBlueColor,
//     required this.bgButtonBlueColor,
//     required this.textColorPrimary8,
//     required this.borderColor2,
//     required this.textColorPrimary7,
//     required this.textColorPrimary6,
//     required this.textColorPrimary5,
//     required this.bgCircleActiveProgress,
//     required this.bgCircleInActiveProgress,
//     required this.bgCardColor2,
//     required this.textColorPrimary4,
//     required this.textColorPrimary3,
//     required this.textColorPrimary2,
//     required this.bgLinearActiveProgress,
//     required this.bgLinearInActiveProgress,
//     required this.bgAppBarColor,
//     required this.bgBackgroundColor,
//     required this.bgTransColor,
//     required this.bgCardColor,
//     required this.textColorPrimary,
//     required this.textColorSecondary,
//     required this.textColorAction,
//     required this.textLinkColor,
//     required this.iconColorPrimary,
//     required this.iconColorSecondary,
//     required this.iconColorAction,
//     required this.bgIconButtonColor,
//     required this.bgButtonColor,
//     required this.bgButtonWarningColor,
//     required this.bgFrostedGlass,
//     required this.bgButtonDarkColor,
//     required this.bgSemiBg,
//     required this.divideColor,
//     required this.borderColor,
//     required this.textColorGrey,
//   });
// }

// class AppTheme {
//   static final _darkTheme = AppColor.createDarkThemColor();
//   static final _lightTheme = AppColor.createLightThemColor();

//   static AppColor colors(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark
//           ? _darkTheme
//           : _lightTheme;
// }
