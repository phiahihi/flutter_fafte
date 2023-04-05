import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/utils/export.dart';
import 'package:shimmer/shimmer.dart';

class InviteSkeleton extends StatelessWidget {
  const InviteSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizes.s16),
      child: SizedBox(
        height: Sizes.s80,
        child: Shimmer.fromColors(
          baseColor: splashColor.withOpacity(0.5),
          highlightColor: splashColor.withOpacity(0.1),
          child: Row(
            children: [
              CircleAvatar(radius: Sizes.s40),
              SpacingBox(
                w: 16,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: Sizes.s20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.s24),
                          color: blackAccent),
                    ),
                    SpacingBox(
                      h: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: Sizes.s30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Sizes.s24),
                                color: blackAccent),
                          ),
                        ),
                        SpacingBox(w: 16),
                        Expanded(
                          child: Container(
                            height: Sizes.s30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Sizes.s24),
                                color: blackAccent),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
