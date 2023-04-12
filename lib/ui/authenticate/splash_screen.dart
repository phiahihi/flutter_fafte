import 'dart:async';

import 'package:fafte/controller/auth_controller.dart';
import 'package:fafte/shared_preferences/shared_preferences.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/authenticate/onboarding/onboarding.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/utils/export.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int count = 0;
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    startTimer();
  }

  Timer? _timer;
  int _start = 0;

  void startTimer() async {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_start == 3) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final firstOpen = await checkFirstOpen();
          if (firstOpen) {
            navigateTo(const OnboardingScreen(), clearStack: true);
            prefs.setBool("first_open", false);
          } else {
            AuthController.instance.checkUserSignIn();
          }
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: splashColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Sizes.s200,
                  ),
                  color: white),
              height: Sizes.s206,
              width: Sizes.s206,
              child: Transform.scale(
                scale: Sizes.s1,
                child: Image.asset(Assets.logo),
              ),
            ),
            const SpacingBox(
              h: 32.5,
            ),
            Text(
              'Fafte',
              style: pt22Bold(context).copyWith(
                color: white,
                fontSize: Sizes.s50,
              ),
            ),
            const SpacingBox(
              h: 22,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.s62),
              child: LinearPercentIndicator(
                barRadius: Radius.circular(Sizes.s5),
                percent: _start / 3,
                progressColor: white,
                backgroundColor: white.withOpacity(0.37),
                lineHeight: Sizes.s10,
              ),
            ),
            const SpacingBox(
              h: 15,
            ),
            Text(
              S.current.loading,
              style: pt16Regular(context).copyWith(color: white),
            )
          ],
        ),
      ),
    );
  }
}
