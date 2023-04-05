import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/utils/export.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Image.asset(Assets.success),
          ),
          Column(
            children: [
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
                        S.current.accountCreated,
                        style: pt22Bold(context).copyWith(color: splashColor),
                      ),
                      SpacingBox(
                        h: 17,
                      ),
                      Text(
                        S.current.yourAccountHadBeedCreated,
                        style: pt16Regular(context),
                      ),
                      SpacingBox(
                        h: 4,
                      ),
                      Text(
                        S.current.successfully,
                        style: pt16Regular(context),
                      ),
                      SpacingBox(
                        h: 4,
                      ),
                      Text(
                        S.current.pleaseSignInToUseYourAccount,
                        style: pt16Regular(context),
                      ),
                      SpacingBox(
                        h: 4,
                      ),
                      Text(
                        S.current.andEnjoy,
                        style: pt16Regular(context),
                      ),
                      SpacingBox(
                        h: 30,
                      ),
                      BuildTextLinearButton(
                        padding: EdgeInsets.zero,
                        onTap: () {},
                        text: S.current.takeMeToSignIn,
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
          SpacingBox(
            h: 65,
          ),
        ],
      )),
    );
  }
}
