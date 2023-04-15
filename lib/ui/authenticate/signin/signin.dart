import 'package:flutter_svg/flutter_svg.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/appbar/appbar.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/export.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
          child: Column(
        children: [
          BuildAppBar(name: 'Đăng nhập'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Sizes.s8),
                    child: Image.asset(Assets.login2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                            horizontal: Sizes.s20, vertical: Sizes.s26)
                        .copyWith(top: Sizes.s17),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes.s20, vertical: Sizes.s30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.s20),
                        color: white,
                      ),
                      child: Column(
                        children: [
                          Text(
                            S.current.simplyEnterYourPhoneNumberToLogin,
                            style: pt16Regular(context),
                          ),
                          SpacingBox(
                            h: 3,
                          ),
                          Text(
                            S.current.orCreateAnAccount,
                            style: pt16Regular(context),
                          ),
                          SpacingBox(
                            h: 23,
                          ),
                          BuildTextField(
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(Sizes.s14),
                              child: SvgPicture.asset(Assets.lock),
                            ),
                            hintText: S.current.phoneNumber,
                          ),
                          SpacingBox(h: 29),
                          Text(
                            S.current.byUsingOurMobileApp,
                            style: pt14Regular(context).copyWith(
                              fontSize: Sizes.s15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  S.current.privacyPolicy,
                                  style: pt14Regular(context).copyWith(
                                    fontSize: Sizes.s15,
                                  ),
                                ),
                                SpacingBox(
                                  w: 6,
                                ),
                                Text(
                                  S.current.and,
                                  style: pt14Regular(context).copyWith(
                                    fontSize: Sizes.s15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SpacingBox(
                                  w: 6,
                                ),
                                Text(
                                  S.current.termsOfUse,
                                  style: pt14Regular(context).copyWith(
                                    fontSize: Sizes.s15,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SpacingBox(
                    h: 6,
                  ),
                  BuildTextLinearButton(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
                    onTap: () {},
                    text: S.current.continuee,
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
      )),
    );
  }
}
