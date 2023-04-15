import 'package:fafte/controller/auth_controller.dart';
import 'package:fafte/controller/user_controller.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/utils/string_utils.dart';
import 'package:fafte/ui/widget/appbar/appbar.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/export.dart';
import 'package:get/get.dart';

class UpdateInfoScreen extends StatefulWidget {
  final UserModel userModel;
  const UpdateInfoScreen({super.key, required this.userModel});

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  bool isLoading = false;

  final authController = AuthController.instance;

  final _formKey = GlobalKey<FormState>();

  String? validate(String? value, String error) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng điền $error';
    }
    return null;
  }

  @override
  void initState() {
    _fullNameController.text = widget.userModel.userName!;
    _phoneNumberController.text = widget.userModel.phoneNumber!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
          child: Stack(children: [
        Column(
          children: [
            BuildAppBar(name: 'Thông tin cá nhân'),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
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
                              BuildTextField(
                                  controller: _fullNameController,
                                  validator: (value) {
                                    final error = validate(value, 'họ và tên');
                                    if (error != null) {
                                      return error;
                                    } else {
                                      return null;
                                    }
                                  },
                                  hintText: 'Họ và tên',
                                  contentPadding: EdgeInsets.all(Sizes.s14)),
                              const SpacingBox(h: 16),
                              BuildTextField(
                                  validator: (value) {
                                    if (!StringValidator(value!)
                                        .isValidPhone()) {
                                      return 'Số điện thoại không hợp lệ';
                                    }
                                    final error =
                                        validate(value, 'số điện thoại');
                                    if (error != null) {
                                      return error;
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _phoneNumberController,
                                  hintText: 'Số điện thoại',
                                  contentPadding: EdgeInsets.all(Sizes.s14)),
                              const SpacingBox(
                                h: 16,
                              ),
                              BuildTextLinearButton(
                                padding: EdgeInsets.zero,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    UserController.instance
                                        .updateInfo(
                                            widget.userModel.id!,
                                            _fullNameController.text,
                                            _phoneNumberController.text)
                                        .then((value) {
                                      setState(() {
                                        isLoading = false;
                                        Get.back();
                                      });
                                    });
                                  }
                                },
                                text: 'Cập nhật',
                                style: pt16Regular(context).copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Sizes.s18,
                                  color: white,
                                ),
                                colors: [
                                  _fullNameController.text != '' &&
                                          _phoneNumberController.text != ''
                                      ? pink2LightGradient
                                      : pink2LightGradient.withOpacity(0.5),
                                  _fullNameController.text != '' &&
                                          _phoneNumberController.text != ''
                                      ? pink2DarkGradient
                                      : pink2DarkGradient.withOpacity(0.5),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isLoading)
          Container(
            width: deviceWidth(context),
            height: deviceHeight(context),
            color: white.withOpacity(0.8),
            child: Center(
              child: CircularProgressIndicator(
                color: splashColor,
              ),
            ),
          )
      ])),
    );
  }
}
