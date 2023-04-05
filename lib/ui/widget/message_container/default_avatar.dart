import 'package:fafte/models/user.dart';
import 'package:fafte/ui/widget/message_container/image_provider.dart';
import 'package:fafte/utils/export.dart';

class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar({
    required this.user,
    this.size = 35,
    this.fallbackImage,
    this.onPressAvatar,
    this.onLongPressAvatar,
  });

  /// The URL of the user's profile picture
  final UserModel user;

  /// Size of the avatar
  final double size;

  /// Placeholder image in case there is no initials ot he profile image do not load
  final ImageProvider? fallbackImage;

  /// Function to call when the user long press on the avatar
  final void Function(UserModel)? onLongPressAvatar;

  /// Function to call when the user press on the avatar
  final void Function(UserModel)? onPressAvatar;

  /// Get the initials of the user
  String getInitials() {
    return (user.userName == null || user.userName!.isEmpty
            ? ''
            : user.userName![0]) +
        (user.userName == null || user.userName!.isEmpty
            ? ''
            : user.userName![0]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressAvatar != null ? () => onPressAvatar!(user) : null,
      onLongPress:
          onLongPressAvatar != null ? () => onLongPressAvatar!(user) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: SizedBox(
          height: size,
          width: size,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  color: Colors.grey[200],
                  child: getInitials().isNotEmpty
                      ? Center(
                          child: Text(
                            getInitials(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: size * 0.35,
                            ),
                          ),
                        )
                      : Image(
                          image: fallbackImage ??
                              const AssetImage(
                                'assets/profile_placeholder.png',
                                package: 'dash_chat_2',
                              ),
                        ),
                ),
              ),
              if (user.profileImageUrl != null &&
                  user.profileImageUrl!.isNotEmpty)
                Center(
                  child: ClipOval(
                    child: FadeInImage(
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      image: getImageProvider(user.profileImageUrl!),
                      placeholder: fallbackImage ??
                          const AssetImage(
                            'assets/profile_placeholder.png',
                            package: 'dash_chat_2',
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
