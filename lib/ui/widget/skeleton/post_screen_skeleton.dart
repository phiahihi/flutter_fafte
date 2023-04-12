import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/utils/export.dart';
import 'package:shimmer/shimmer.dart';

class PostScreenSkeleton extends StatelessWidget {
  const PostScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Shimmer.fromColors(
        baseColor: splashColor.withOpacity(0.5),
        highlightColor: splashColor.withOpacity(0.1),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Sizes.s16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(),
                  SpacingBox(
                    w: 8,
                  ),
                  Expanded(
                    child: Container(
                      height: Sizes.s35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.s24),
                        color: white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: Sizes.s25,
                    width: Sizes.s100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.s25),
                        color: white),
                  ),
                  Container(
                    height: Sizes.s16,
                    width: Sizes.s70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.s25),
                        color: white),
                  ),
                ],
              ),
            ),
            SpacingBox(
              h: 11,
            ),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Container(
            //     height: Sizes.s150,
            //     child: Row(
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.only(left: Sizes.s20),
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(Sizes.s10),
            //             child: Container(
            //               color: white,
            //               width: Sizes.s100,
            //               height: Sizes.s148,
            //             ),
            //           ),
            //         ),
            //         SpacingBox(
            //           w: 8,
            //         ),
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(Sizes.s10),
            //           child: Container(
            //             color: white,
            //             width: Sizes.s100,
            //             height: Sizes.s148,
            //           ),
            //         ),
            //         SpacingBox(
            //           w: 8,
            //         ),
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(Sizes.s10),
            //           child: Container(
            //             color: white,
            //             width: Sizes.s100,
            //             height: Sizes.s148,
            //           ),
            //         ),
            //         SpacingBox(
            //           w: 8,
            //         ),
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(Sizes.s10),
            //           child: Container(
            //             color: white,
            //             width: Sizes.s100,
            //             height: Sizes.s148,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SpacingBox(
              h: 16,
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.all(Sizes.s16),
                  child: Row(
                    children: [
                      CircleAvatar(),
                      SpacingBox(
                        w: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: Sizes.s15,
                              width: Sizes.s70,
                              color: white,
                            ),
                            SpacingBox(
                              h: 8,
                            ),
                            Container(
                              height: Sizes.s15,
                              color: white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: Sizes.s300,
                  color: white,
                ),
                SpacingBox(
                  h: 8,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
                  child: Container(
                    height: Sizes.s40,
                    width: deviceWidth(context),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(Sizes.s24),
                            ),
                          ),
                        ),
                        SpacingBox(w: 8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(Sizes.s24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
