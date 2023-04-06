//a model, FullScreenArg, that has a String? videoUrl and a File? videoFile
import 'dart:io';

class FullScreenArg {
  final String? videoUrl;
  final File? videoFile;

  FullScreenArg({this.videoUrl, this.videoFile});
}