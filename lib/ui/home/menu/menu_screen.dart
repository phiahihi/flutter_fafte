import 'package:fafte/controller/auth_controller.dart';
import 'package:fafte/controller/user_controller.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/authenticate/change_password/change_password.dart';
import 'package:fafte/ui/authenticate/welcome_login/welcome_login.dart';
import 'package:fafte/ui/home/personal/personal.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/utils/export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fafte/utils/snackbars_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final provider = AuthController.instance;
  bool isShowInfo = false;
  bool isShowReview = false;

  final model = UserController.instance;

  double turnsInfo = 0.0;

  String email = 'phi.ndh.62cntt@ntu.edu.vn';

  void _nextRotationInfo() {
    setState(() => turnsInfo += 0.5);
  }

  void _backRotationInfo() {
    setState(() => turnsInfo -= 0.5);
  }

  double turnsReview = 0.0;

  void _nextRotationReview() {
    setState(() => turnsReview += 0.5);
  }

  void _backRotationReview() {
    setState(() => turnsReview -= 0.5);
  }

  String emailUrl = Uri.encodeComponent('phi.ndh.62cntt@ntu.edu.vn');
  String subject = Uri.encodeComponent("Hello Flutter");
  String body = Uri.encodeComponent("Hi! I'm Flutter Developer");

  _openEmail() async {
    print(subject); //output: Hello%20Flutter
    Uri mail = Uri.parse("mailto:$emailUrl?subject=$subject&body=$body");
    if (await launchUrl(mail)) {
      //email app opened
    } else {
      //email app is not opened
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
          child: Column(
            children: [
              SpacingBox(h: 16),
              _buildItemInfo(context),
              SpacingBox(h: 32),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.s12),
                    boxShadow: [
                      BoxShadow(
                          blurStyle: BlurStyle.outer,
                          color: splashColor,
                          blurRadius: Sizes.s4),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInfoApp(context),
                    Divider(
                      height: Sizes.s1,
                    ),
                    _buildReviewApp(context),
                  ],
                ),
              ),
              SpacingBox(h: 32),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.s12),
                    boxShadow: [
                      BoxShadow(
                          blurStyle: BlurStyle.outer,
                          color: splashColor,
                          blurRadius: Sizes.s4),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _builItemFeature(context,
                        title: 'Đổi mật khẩu',
                        subtitle: 'Dùng để đổi mật khẩu',
                        icon: Assets.refreshCw, onTap: () {
                      navigateTo(ChangePasswordScreen());
                    }),
                    Divider(
                      height: Sizes.s1,
                    ),
                    _builItemFeature(context,
                        title: 'Đăng xuất',
                        subtitle: 'Dùng để đăng xuất',
                        icon: Assets.logOut, onTap: () {
                      provider.logout().then((response) {
                        if (response.success) {
                          navigateTo(WelcomeLoginScreen(), clearStack: true);
                        } else {
                          ContextExtensions(context)
                              .showSnackBar(response.message);
                        }
                      }).catchError((error) {
                        ContextExtensions(context).showSnackBar(error);
                      });
                    }),
                  ],
                ),
              ),
              SpacingBox(h: 32),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildReviewApp(BuildContext context) {
    return Column(
      children: [
        _builItemFeature(context,
            title: 'Phản hồi',
            subtitle: 'Phản hồi và đánh giá',
            trailing: AnimatedRotation(
              turns: turnsReview,
              duration: const Duration(milliseconds: 500),
              child: SvgPicture.asset(Assets.chevronDown),
            ),
            icon: Assets.messageCircle, onTap: () {
          setState(() {
            isShowReview = !isShowReview;
            if (isShowReview) {
              _nextRotationReview();
            } else {
              _backRotationReview();
            }
          });
        }),
        AnimatedContainer(
          decoration: BoxDecoration(
              color: white,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(Sizes.s16))),
          curve: Curves.easeIn,
          height: isShowReview ? Sizes.s50 : 0,
          width: deviceWidth(context),
          duration: Duration(milliseconds: 500),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
            child: ClipRRect(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(Sizes.s16)),
                child: Wrap(
                  children: [
                    Text(
                      'Mọi phản hồi và góp ý vui lòng liên hệ email:',
                      style: pt14Regular(context),
                    ),
                    InkWell(
                      onTap: _openEmail,
                      child: Text(
                        email,
                        style: pt14Bold(context)
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoApp(BuildContext context) {
    return Column(
      children: [
        _builItemFeature(context,
            title: 'Thông tin',
            subtitle: 'Thông tin chi tiết về ứng dụng',
            trailing: AnimatedRotation(
              turns: turnsInfo,
              duration: const Duration(milliseconds: 500),
              child: SvgPicture.asset(Assets.chevronDown),
            ),
            icon: Assets.alertCircle, onTap: () {
          setState(() {
            isShowInfo = !isShowInfo;
            if (isShowInfo) {
              _nextRotationInfo();
            } else {
              _backRotationInfo();
            }
          });
        }),
        AnimatedContainer(
          curve: Curves.easeIn,
          height: isShowInfo ? Sizes.s270 : 0,
          width: deviceWidth(context),
          color: white,
          duration: Duration(milliseconds: 500),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
            child: ClipRRect(
                child: Wrap(
              runSpacing: Sizes.s16,
              children: [
                Text(
                  'Fafte là một ứng dụng mạng xã hội được phát triển bằng Flutter - một công nghệ tiên tiến của Google cho phép phát triển ứng dụng di động nhanh chóng và đa nền tảng.',
                  style: pt14Regular(context),
                ),
                Text(
                  'Với Fafte, người dùng có thể tạo tài khoản, tìm kiếm và kết nối với những người dùng khác, chia sẻ nội dung và tương tác với nhau thông qua các tính năng của ứng dụng.',
                  style: pt14Regular(context),
                ),
                Text(
                  'Fafte cung cấp một giao diện thân thiện, trực quan và dễ sử dụng, giúp người dùng dễ dàng tìm kiếm, đăng bài và tương tác với những người dùng khác trên nền tảng mạng xã hội này. Điều này giúp tạo ra một cộng đồng mạng đa dạng và thân thiện với những người dùng cùng sở thích.',
                  style: pt14Regular(context),
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }

  Widget _builItemFeature(BuildContext context,
      {required String title,
      required String subtitle,
      required String icon,
      Widget? trailing,
      void Function()? onTap}) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ListTile(
        tileColor: white,
        minVerticalPadding: 0,
        minLeadingWidth: 10,
        leading: SizedBox(
          height: double.infinity,
          child: SvgPicture.asset(icon),
        ),
        title: Text(
          title,
          style: pt16Regular(context),
        ),
        subtitle: Text(
          subtitle,
          style: pt14Regular(context),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildItemInfo(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.s12),
      ),
      onTap: () {
        navigateTo(PersonalScreen(
          model: model.userModel,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(Sizes.s12),
            boxShadow: [
              BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: splashColor,
                  blurRadius: Sizes.s4),
            ]),
        child: ListTile(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(Sizes.s8),
          //   side: BorderSide(color: splashColor),
          // ),
          leading: CircleAvatar(
            radius: Sizes.s30,
            backgroundImage: model.userModel?.profileImageUrl == null
                ? null
                : NetworkImage(model.userModel!.profileImageUrl!),
          ),
          title: Text(
            model.userModel?.userName ?? '',
            style: pt16Regular(context),
          ),
          subtitle: Text(
            'Xem trang cá nhân',
            style: pt14Regular(context),
          ),
        ),
      ),
    );
  }
}
