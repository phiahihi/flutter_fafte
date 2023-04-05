import 'package:fafte/models/chat_media.dart';
import 'package:fafte/models/message.dart';
import 'package:fafte/ui/widget/message_container/image_provider.dart';
import 'package:fafte/ui/widget/message_container/message_options.dart';
import 'package:fafte/ui/widget/message_container/text_container.dart';
import 'package:fafte/ui/widget/message_container/video_controller.dart';
import 'package:fafte/utils/export.dart';

class MediaContainer extends StatefulWidget {
  const MediaContainer({
    required this.message,
    required this.isOwnMessage,
    this.messageOptions = const MessageOptions(),
    Key? key,
  }) : super(key: key);

  /// Message that contains the media to show
  final MessageModel message;

  /// If the message is from the current user
  final bool isOwnMessage;

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;

  @override
  State<MediaContainer> createState() => _MediaContainerState();
}

class _MediaContainerState extends State<MediaContainer> {
  /// Get the right media widget according to its type
  Widget _getMedia(ChatMedia media, double? height, double? width) {
    final Widget loading = Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.all(10),
      child: const CircularProgressIndicator(),
    );
    switch (media.type) {
      case MediaType.video:
        return VideoMedia(
          media: media,
          loading: loading,
        );
      case MediaType.image:
        return Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            Image(
              height: height,
              width: width,
              fit: BoxFit.cover,
              alignment:
                  widget.isOwnMessage ? Alignment.topRight : Alignment.topLeft,
              image: getImageProvider(media.url),
            ),
            if (media.isUploading) loading
          ],
        );
      default:
        return TextContainer(
          isOwnMessage: widget.isOwnMessage,
          messageOptions: widget.messageOptions,
          message: widget.message,
          messageTextBuilder:
              (MessageModel m, MessageModel? p, MessageModel? n) {
            return Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: !media.isUploading
                      ? Icon(
                          Icons.description,
                          size: 18,
                          color: widget.isOwnMessage
                              ? (widget.messageOptions.currentUserTextColor ??
                                  Colors.white)
                              : (widget.messageOptions.textColor ??
                                  Colors.black),
                        )
                      : loading,
                ),
                Flexible(
                  child: Text(
                    media.fileName,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: widget.isOwnMessage
                          ? (widget.messageOptions.currentUserTextColor ??
                              Colors.white)
                          : (widget.messageOptions.textColor ?? Colors.black),
                    ),
                  ),
                ),
              ],
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.medias != null && widget.message.medias!.isNotEmpty) {
      final List<ChatMedia> media = widget.message.medias!;
      return Wrap(
        alignment:
            widget.isOwnMessage ? WrapAlignment.end : WrapAlignment.start,
        children: media.map(
          (ChatMedia m) {
            final double gallerySize =
                (MediaQuery.of(context).size.width * 0.7) / 2 - 5;
            final bool isImage = m.type == MediaType.image;
            return Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 5, right: 5),
              width: media.length > 1 && isImage ? gallerySize : null,
              height: media.length > 1 && isImage ? gallerySize : null,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: GestureDetector(
                onTap: widget.messageOptions.onTapMedia != null
                    ? () => widget.messageOptions.onTapMedia!(m)
                    : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      m.isUploading
                          ? Colors.white54
                          : Colors.white.withOpacity(
                              0.1,
                            ), // Because transparent is causing an issue on flutter web
                      BlendMode.srcATop,
                    ),
                    child: _getMedia(
                      m,
                      media.length > 1 ? gallerySize : null,
                      media.length > 1 ? gallerySize : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      );
    }
    return Container();
  }
}
