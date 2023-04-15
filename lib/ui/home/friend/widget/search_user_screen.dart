import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fafte/controller/user_controller.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/home/personal/personal.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  TextEditingController _searchController = TextEditingController();
  final userController = UserController.instance;
  String _searchString = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: splashColor,
        title: BuildTextField(
          borderRadius: BorderRadius.circular(Sizes.s4),
          hintText: 'Tìm kiếm',
          controller: _searchController,
          onChanged: (p0) {
            setState(() {
              _searchString = p0;
            });
          },
          maxLines: 1,
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                _searchString = '';
                _searchController.clear();
              });
            },
            child: Icon(
              Icons.close,
              color: splashColor,
            ),
          ),
        ),
      ),
      body: _searchString == ''
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.s16),
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildItem(context,
                      model: userController.listUserStorageModel[index],
                      index: index,
                      isUserStorage: true);
                },
                itemCount: userController.listUserStorageModel.length,
              ),
            )
          : StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return Column(children: [
                    SpacingBox(h: 100),
                    Center(
                      child: Text(
                        'Có lỗi đã xảy ra',
                        style: pt16Regular(context),
                      ),
                    ),
                  ]);

                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                userController.listUserSearchModel = snapshot.data!.docs
                    .map((doc) => UserModel.fromDocument(doc))
                    .toList();

                userController.listUserSearchModel =
                    userController.listUserSearchModel
                        .where(
                          (e) => e.userName!.toLowerCase().contains(
                                _searchController.text.toLowerCase(),
                              ),
                        )
                        .toList();
                var len = userController.listUserSearchModel.length;
                if (len == 0)
                  return Column(
                    children: [
                      SpacingBox(h: 100),
                      Center(
                          child: Text("Không tìm thấy bạn bè",
                              style: pt16Regular(context)))
                    ],
                  );
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _buildItem(context,
                        model: userController.listUserSearchModel[index]);
                  },
                  itemCount: userController.listUserSearchModel.length,
                );
              },
            ),
    );
  }

  Widget _buildItem(BuildContext context,
      {required UserModel model, int? index, bool isUserStorage = false}) {
    return InkWell(
      onTap: () {
        setState(() {
          navigateTo(PersonalScreen(model: model));

          if (userController.listUserStorageModel
              .any((element) => element.id == model.id)) {
            userController.listUserStorageModel.removeAt(index!);
            userController.listUserStorageModel.add(model);
          } else {
            userController.listUserStorageModel.add(model);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  model.profileImageUrl == null || model.profileImageUrl == ''
                      ? CircleAvatar(radius: Sizes.s24)
                      : CircleAvatar(
                          radius: Sizes.s24,
                          backgroundImage:
                              NetworkImage(model.profileImageUrl ?? ''),
                        ),
                  SpacingBox(w: 8),
                  model.userName == null
                      ? Text(
                          'Không tên',
                          style: pt16Regular(context)
                              .copyWith(fontWeight: FontWeight.w300),
                        )
                      : Expanded(
                          child: Text(
                            model.userName!,
                            style: pt16Regular(context).copyWith(
                                fontWeight: FontWeight.w300,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                ],
              ),
            ),
            SpacingBox(w: 8),
            isUserStorage
                ? Padding(
                    padding: EdgeInsets.only(right: Sizes.s16),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          userController.listUserStorageModel.removeAt(index!);
                        });
                      },
                      child: Icon(Icons.close),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(right: Sizes.s16),
                    child: Transform.rotate(
                        angle: 3.1,
                        child: SvgPicture.asset(
                          Assets.arrowLeft,
                          color: splashColor,
                        )),
                  ),
          ],
        ),
      ),
    );
  }
}
