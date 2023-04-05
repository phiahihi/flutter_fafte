import 'package:fafte/models/user.dart';
import 'package:fafte/utils/export.dart';

class DefaultUserName extends StatelessWidget {
  const DefaultUserName({
    required this.user,
    this.style,
    this.padding,
    Key? key,
  }) : super(key: key);

  /// User to show
  final UserModel user;

  /// Style of the text
  final TextStyle? style;

  /// Padding around the text
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        user.userName ?? '',
        style: style ??
            const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
      ),
    );
  }
}
