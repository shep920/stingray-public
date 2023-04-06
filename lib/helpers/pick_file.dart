import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hero/helpers/compress_to_shit.dart';
import 'package:hero/helpers/trimmer_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

class PickFile {
  static Future<File?> setImage(
      {required ImageSource source,
      required BuildContext context,
      bool isVideo = false}) async {
    ImagePicker _picker = ImagePicker();
    final XFile? _image = (isVideo)
        ? await _picker.pickVideo(
            source: source,
          )
        : await _picker.pickImage(
            source: source,
            imageQuality: 100,
          );

    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No image was selected.')));
    }

    //get if the file is an image or video
    String? _fileType = _image!.path.split('.').last;

    if (!isVideo) {
      if (_image != null) {
        File? compressedFile =
            await CompressToShit.compressToShit(File(_image.path));
        if (compressedFile == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Your image exceeded the 1mb limit.')));
        } else {
          return File(compressedFile.path);
        }
      }
    } else {
      File _video = File(_image.path);
      if (_video.lengthSync() < 30000000) {
        //if the video is not in .mp4 format, convert it to .mp4
        if (_fileType != 'mp4') {
          MediaInfo? mediaInfo = await VideoCompress.compressVideo(
            _video.path,
            quality: VideoQuality.HighestQuality,
            deleteOrigin: false,
          );

          File _convertedVideo = File(mediaInfo!.path!);

          String? _trimmedFilePath = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TrimmerView(_convertedVideo);
            }),
          );

          if (_trimmedFilePath != null) {
            File _trimmedVideo = File(_trimmedFilePath);
            return _trimmedVideo;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Your video exceeded the 5mb limit.')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your video exceeded the 5mb limit.')));
      }
    }
  }
}
