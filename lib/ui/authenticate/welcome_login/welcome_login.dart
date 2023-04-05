import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/authenticate/signup/signup.dart';
import 'package:fafte/ui/authenticate/welcome_v2_login/welcome_v2_login.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/utils/export.dart';

class WelcomeLoginScreen extends StatefulWidget {
  const WelcomeLoginScreen({super.key});

  @override
  State<WelcomeLoginScreen> createState() => _WelcomeLoginScreenState();
}

class _WelcomeLoginScreenState extends State<WelcomeLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Sizes.s8),
              child: Image.asset(Assets.welcomeLogin),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                      horizontal: Sizes.s20, vertical: Sizes.s36)
                  .copyWith(top: Sizes.s10),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.s20, vertical: Sizes.s30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.s20),
                  color: white,
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          S.current.welcomeTo,
                          style: pt22Bold(context).copyWith(
                            fontSize: Sizes.s30,
                          ),
                        ),
                        const SpacingBox(
                          h: 1,
                        ),
                        Text(
                          S.current.videoSharingApp,
                          style: pt22Bold(context).copyWith(
                            fontSize: Sizes.s30,
                          ),
                        ),
                        const SpacingBox(
                          h: 15,
                        ),
                        Text(
                          S.current.deliverYourOrderAroundTheWorld,
                          style: pt16Regular(context).copyWith(
                            fontSize: Sizes.s18,
                          ),
                        ),
                        const SpacingBox(
                          h: 1,
                        ),
                        Text(
                          S.current.withoutHesitation,
                          style: pt16Regular(context).copyWith(
                            fontSize: Sizes.s18,
                          ),
                        ),
                      ],
                    ),
                    const SpacingBox(
                      h: 26,
                    ),
                    BuildTextLinearButton(
                      onTap: () {
                        navigateTo(const WelcomeV2LoginScreen(
                          isLogin: true,
                        ));
                      },
                      text: S.current.login,
                      style: pt16Regular(context).copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: Sizes.s18,
                        color: white,
                      ),
                    ),
                    const SpacingBox(
                      h: 20,
                    ),
                    BuildTextLinearButton(
                      onTap: () {
                        navigateTo(const SignupScreen(
                          isSignup: true,
                        ));
                      },
                      text: S.current.register,
                      colors: const [purpleLightGradient, purpleLDarkGradient],
                      style: pt16Regular(context).copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: Sizes.s18,
                        color: white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
