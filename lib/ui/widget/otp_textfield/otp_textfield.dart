import 'package:fafte/utils/export.dart';

class BuildOtpTextfield extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool? autoFocus;
  const BuildOtpTextfield(
      {super.key, required this.controller, this.onChanged, this.autoFocus});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 66,
      height: 66,
      child: TextField(
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        autofocus: autoFocus ?? false,
        style: pt16Regular(context)
            .copyWith(fontSize: Sizes.s18, color: splashColor),
        decoration: InputDecoration(
          hintText: '0',
          counterText: "",
          fillColor: whiteAccent,
          hintStyle: pt16Regular(context)
              .copyWith(fontSize: Sizes.s18, color: greyAccent),
          filled: true,
          contentPadding:
              EdgeInsets.symmetric(horizontal: Sizes.s27, vertical: Sizes.s22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(66),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(66),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(66),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
