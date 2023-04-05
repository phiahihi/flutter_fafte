import 'package:fafte/models/chat_media.dart';
import 'package:fafte/utils/export.dart';
import 'package:video_player/video_player.dart';

class VideoMedia extends StatefulWidget {
  final ChatMedia media;
  final Widget loading;
  const VideoMedia({super.key, required this.media, required this.loading});

  @override
  State<VideoMedia> createState() => _VideoMediaState();
}

class _VideoMediaState extends State<VideoMedia> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.media.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        VideoPlayer(_controller),
        if (widget.media.isUploading) widget.loading
      ],
    );
  }
}
