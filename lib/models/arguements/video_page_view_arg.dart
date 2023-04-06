//a model, FullScreenArg, that has a String? videoUrl and a File? videoFile
import 'dart:io';

import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';

class PageViewArg {
  final String? videoUrl;
  final File? videoFile;
  final Wave wave;
  final User poster;

  PageViewArg(
      {this.videoUrl,
      this.videoFile,
      required this.wave,
      required this.poster});
}
