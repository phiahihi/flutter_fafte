import 'package:get/get.dart';
import 'package:fafte/utils/export.dart';

class BuildBackButton extends StatelessWidget {
  final void Function()? onPressed;
  const BuildBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
        visualDensity: VisualDensity.compact,
        style: TextButton.styleFrom(
          minimumSize: Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.zero,
        ),
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: Sizes.s20,
        ),
        onPressed: onPressed ??
            () {
              Get.back();
            },
      ),
    );
  }
}
