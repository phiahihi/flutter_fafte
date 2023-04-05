import 'package:flutter_svg/flutter_svg.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/utils/export.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(),
          SafeArea(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Sizes.s8, horizontal: Sizes.s16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(Assets.search),
                    ),
                    SpacingBox(
                      w: 4,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: Sizes.s40,
                          padding: EdgeInsets.all(Sizes.s10),
                          child: Text(
                            S.current.search,
                            style: pt16Regular(context),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                    SpacingBox(
                      w: 4,
                    ),
                    GestureDetector(
                        onTap: () {}, child: SvgPicture.asset(Assets.plus)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: whiteAccent,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SpacingBox(
                          h: 15,
                        ),
                        SpacingBox(
                          h: 13,
                        ),
                        SizedBox(
                          height: Sizes.s50,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            children: [
                              _buildActive(),
                              _buildActive(),
                              _buildActive(),
                              _buildActive(),
                              _buildActive(),
                              _buildActive(),
                              _buildActive(),
                            ],
                          ),
                        ),
                        SpacingBox(
                          h: 13,
                        ),
                        _buildItemMessage(context),
                        _buildItemMessage(context),
                        _buildItemMessage(context),
                        _buildItemMessage(context),
                        _buildItemMessage(context),
                        _buildItemMessage(context),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildItemMessage(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigateTo(MessageScreen());
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: Sizes.s16).copyWith(top: Sizes.s8),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.s50),
                  child: Image.asset(
                    Assets.logo,
                    width: Sizes.s50,
                    height: Sizes.s50,
                  ),
                ),
                SpacingBox(
                  w: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Darien Don',
                            style: pt14Bold(context).copyWith(
                                fontSize: Sizes.s13, color: textColor2),
                          ),
                          Text(
                            '15:28 PM',
                            style:
                                pt12Regular(context).copyWith(color: textColor),
                          )
                        ],
                      ),
                      SpacingBox(
                        h: 5,
                      ),
                      Text(
                        'Great! Do you Love it.',
                        style:
                            pt14Regular(context).copyWith(fontSize: Sizes.s13),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SpacingBox(
              w: 8,
            ),
            Row(
              children: [
                SizedBox(
                  width: Sizes.s50,
                ),
                SpacingBox(
                  w: 15,
                ),
                Expanded(
                    child: Divider(
                  color: greyAccent,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActive() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s8),
      child: SizedBox(
        width: Sizes.s50,
        height: Sizes.s50,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.s25),
              child: Image.asset(
                Assets.logo,
                fit: BoxFit.contain,
                width: Sizes.s50,
                height: Sizes.s50,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: Sizes.s15,
                height: Sizes.s15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.s100),
                  color: Colors.green,
                  border: Border.all(width: Sizes.s2, color: whiteAccent),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
