import 'package:fafte/utils/export.dart';

class BuildTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final int? maxLines;
  final BorderRadius? borderRadius;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;
  final bool obscureText;
  final BorderSide? borderSide;

  const BuildTextField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.hintStyle,
    this.contentPadding,
    this.fillColor,
    this.maxLines,
    this.borderRadius,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.validator,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      maxLines: maxLines,
      minLines: 1,
      style: pt16Regular(context),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            hintStyle ?? pt16Regular(context).copyWith(color: greyAccent),
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(Sizes.s50),
          borderSide: borderSide ?? BorderSide.none,
        ),
        fillColor: fillColor ?? whiteAccent,
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ?? EdgeInsets.all(Sizes.s14),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(Sizes.s50),
          borderSide: borderSide ?? BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(Sizes.s50),
          borderSide: borderSide ?? BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(Sizes.s50),
          borderSide: borderSide ?? BorderSide.none,
        ),
      ),
    );
  }
}
