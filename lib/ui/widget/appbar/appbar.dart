import 'package:flutter_svg/flutter_svg.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/utils/export.dart';

class BuildAppBar extends StatelessWidget {
  final String name;
  final bool isMessage;
  final void Function()? onCall;
  final void Function()? onVideoCall;

  const BuildAppBar({
    super.key,
    required this.name,
    this.isMessage = false,
    this.onCall,
    this.onVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.s15),
          child: Center(
            child: Text(
              name,
              style: pt22Bold(context),
            ),
          ),
        ),
        Positioned(
          left: Sizes.s20,
          top: Sizes.s7,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: Sizes.s40,
              height: Sizes.s40,
              padding: EdgeInsets.all(Sizes.s8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.s40),
                color: white,
              ),
              child: SvgPicture.asset(
                Assets.arrowLeft,
                color: blackAccent,
                width: Sizes.s24,
                height: Sizes.s24,
              ),
            ),
          ),
        ),
        if (isMessage)
          Positioned(
            right: Sizes.s20,
            top: Sizes.s7,
            child: Row(
              children: [
                GestureDetector(
                  onTap: onCall,
                  child: Container(
                    width: Sizes.s40,
                    height: Sizes.s40,
                    padding: EdgeInsets.all(Sizes.s8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.s40),
                      color: white,
                    ),
                    child: SvgPicture.asset(
                      Assets.phone,
                      color: splashColor,
                      width: Sizes.s24,
                      height: Sizes.s24,
                    ),
                  ),
                ),
                SpacingBox(
                  w: 10,
                ),
                GestureDetector(
                  onTap: onVideoCall,
                  child: Container(
                    width: Sizes.s40,
                    height: Sizes.s40,
                    padding: EdgeInsets.all(Sizes.s8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.s40),
                      color: white,
                    ),
                    child: SvgPicture.asset(
                      Assets.video,
                      color: splashColor,
                      width: Sizes.s24,
                      height: Sizes.s24,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
