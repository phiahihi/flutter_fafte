import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/appbar/appbar.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/otp_textfield/otp_textfield.dart';
import 'package:fafte/utils/export.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  TextEditingController _firstController = TextEditingController();
  TextEditingController _secondController = TextEditingController();
  TextEditingController _thirdController = TextEditingController();
  TextEditingController _fourthController = TextEditingController();

  String? _otp;

  _verify() {
    _otp = _firstController.text +
        _secondController.text +
        _thirdController.text +
        _fourthController.text;
    if (_otp == _otpAdmin) {
      print('succes');
    } else {
      print('error');
    }
  }

  String get _otpAdmin => '1234';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
          child: Column(
        children: [
          BuildAppBar(name: S.current.oTPVerification),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Sizes.s8),
                    child: Image.asset(Assets.otp),
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
                            S.current.anAuthenticationCodeHasBeenSentTo,
                            style: pt16Regular(context),
                          ),
                          SpacingBox(
                            h: 5,
                          ),
                          Text(
                            '(+880) 111 222 333',
                            style: pt16Regular(context),
                          ),
                          SpacingBox(h: 17),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BuildOtpTextfield(
                                  autoFocus: true,
                                  controller: _firstController,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    });
                                  }),
                              BuildOtpTextfield(
                                controller: _secondController,
                                onChanged: (value) {
                                  setState(() {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    } else {
                                      FocusScope.of(context).previousFocus();
                                    }
                                  });
                                },
                              ),
                              BuildOtpTextfield(
                                controller: _thirdController,
                                onChanged: (value) {
                                  setState(() {
                                    if (value.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    } else {
                                      FocusScope.of(context).previousFocus();
                                    }
                                  });
                                },
                              ),
                              BuildOtpTextfield(
                                  controller: _fourthController,
                                  onChanged: (value) {
                                    setState(() {
                                      _verify();
                                      if (value.length == 1) {
                                        return;
                                      } else {
                                        FocusScope.of(context).previousFocus();
                                      }
                                    });
                                  }),
                            ],
                          ),
                          SpacingBox(h: 25),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  S.current.iDidntReceiveCode,
                                  style: pt16Regular(context),
                                ),
                                SpacingBox(
                                  w: 4,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    S.current.resendCode,
                                    style: pt16Regular(context).copyWith(
                                      color: blueAccent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SpacingBox(
                            h: 10,
                          ),
                          Text(
                            '1:20 ${S.current.secLeft}',
                            style: pt16Regular(context).copyWith(
                              fontWeight: FontWeight.w500,
                              color: splashColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SpacingBox(
                    h: 10,
                  ),
                  BuildTextLinearButton(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
                    onTap: () {},
                    text: S.current.verifyNow,
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
