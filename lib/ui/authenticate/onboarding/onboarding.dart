import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/authenticate/welcome_login/welcome_login.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/utils/export.dart';

final List<Map<String, String>> splashData = [
  {
    "title": S.current.welcomeTo,
    "title2": S.current.socialVideoApp,
    'image': Assets.onboarding1,
  },
  {
    "title": S.current.unlimited,
    "title2": S.current.videoSharing,
    'image': Assets.onboarding2,
  },
  {
    "title": S.current.easyToEdit,
    "title2": S.current.photoAndVideo,
    'image': Assets.onboarding3,
  },
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  Animation<Offset>? animation;
  AnimationController? animationController;

  final _controller = PageController(viewportFraction: 0.87);
  int _currentPage = 0;
  List<Map<String, String>> _getSplashData() => splashData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: Sizes.s8),
                child:
                    Image.asset(splashData[_currentPage]['image'].toString()),
              ),
            ),
            const SpacingBox(
              h: 20,
            ),
            SizedBox(
              height: Sizes.s286,
              child: PageView.builder(
                controller: _controller,
                itemCount: splashData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.s5),
                    child: Transform.translate(
                      offset: Offset(0, _currentPage == index ? 0 : Sizes.s20),
                      child: Container(
                        height: index == _currentPage ? Sizes.s290 : Sizes.s222,
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizes.s26, vertical: Sizes.s30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.s20),
                          color: white,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '${splashData[index]['title']}',
                                style: pt22Bold(context).copyWith(
                                  fontSize: Sizes.s30,
                                ),
                              ),
                              const SpacingBox(
                                h: 1,
                              ),
                              Text(
                                '${splashData[index]['title2']}',
                                style: pt22Bold(context).copyWith(
                                  fontSize: Sizes.s30,
                                ),
                              ),
                              const SpacingBox(
                                h: 15,
                              ),
                              Text(
                                S.current.referenceSiteAboutLorem,
                                style: pt16Regular(context).copyWith(
                                  fontSize: Sizes.s18,
                                ),
                              ),
                              const SpacingBox(
                                h: 1,
                              ),
                              Text(
                                S.current.ipsumGivingInformationOrigins,
                                style: pt16Regular(context).copyWith(
                                  fontSize: Sizes.s18,
                                ),
                              ),
                              if (index == _currentPage)
                                Column(
                                  children: [
                                    const SpacingBox(
                                      h: 45,
                                    ),
                                    BuildTextLinearButton(
                                      onTap: () {
                                        navigateTo(WelcomeLoginScreen(),
                                            clearStack: true);
                                      },
                                      width: deviceWidth(context) - Sizes.s138,
                                      text: S.current.getStarted,
                                    )
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                onPageChanged: (value) => setState(() => _currentPage = value),
              ),
            ),
            const SpacingBox(
              h: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDots(index: 0),
                _buildDots(index: 1),
                _buildDots(index: 2),
              ],
            ),
            const SpacingBox(
              h: 20,
            ),
            SizedBox(
              height: Sizes.s35,
              width: Sizes.s85,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: _currentPage == splashData.length - 1
                      ? activeDot
                      : backgroundSkip,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.s100),
                  ),
                ),
                onPressed: () {
                  if (_currentPage == splashData.length - 1) {
                    navigateTo(WelcomeLoginScreen(), clearStack: true);
                  }
                },
                child: Text(
                  S.current.skip,
                  style: pt20Bold(context).copyWith(
                    fontWeight: FontWeight.w500,
                    height: 0.9,
                    color: white,
                  ),
                ),
              ),
            ),
            const SpacingBox(
              h: 20,
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer _buildDots({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        color: _currentPage == index ? splashColor : inactiveDot,
      ),
      margin: EdgeInsets.only(right: Sizes.s10),
      height: Sizes.s8,
      curve: Curves.easeIn,
      width: _currentPage == index ? Sizes.s36 : Sizes.s20,
    );
  }
}
