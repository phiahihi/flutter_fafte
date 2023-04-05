import 'package:fafte/utils/export.dart';

class BuildTextLinearButton extends StatelessWidget {
  final void Function()? onTap;
  final double? width;
  final double? height;
  final List<Color>? colors;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  final String text;

  const BuildTextLinearButton({
    required this.onTap,
    required this.text,
    this.width,
    this.height,
    this.colors,
    this.borderRadius,
    this.padding,
    this.style,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(horizontal: Sizes.s12),
        child: Container(
          width: width ?? deviceWidth(context),
          height: height ?? Sizes.s50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors ??
                  [
                    pink2LightGradient,
                    pink2DarkGradient,
                  ],
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(Sizes.s25),
          ),
          child: Center(
            child: Text(
              text,
              style: style ??
                  pt16Bold(context).copyWith(fontSize: Sizes.s18, color: white),
            ),
          ),
        ),
      ),
    );
  }
}
