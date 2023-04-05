import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fafte/utils/export.dart';

ImageProvider getImageProvider(String url) {
  if (url.startsWith('http')) {
    return CachedNetworkImageProvider(url);
  } else {
    return FileImage(
      File(url),
    );
  }
}
