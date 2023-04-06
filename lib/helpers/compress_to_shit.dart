import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CompressToShit {
  static Future<File?> compressToShit(File image) async {
    try {
      print('Size before compression: ${image.lengthSync()}');
      int len = image.lengthSync();

      if (len < 500000) {
        return image;
      }

      File? temp = image;
      final String fileType = image.path.substring(image.path.lastIndexOf('.'));
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path + '.' + fileType;

      temp = await compress(temp, tempPath, 500000);

      len = temp!.lengthSync();
      ('length after compression: ${temp.lengthSync()}');

      print('Size after compression: ${len.toString()}');
      if (len > 500000) {
        return null;
      } else {
        return temp;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future<File?> compress(
      File file, String targetPath, int targetSize) async {
    int quality = 100;
    File? result;

    while (quality > 0) {
      result = (await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minHeight: 200,
      ))!;

      // Check the file size
      final fileInfo = await result.stat();
      if (fileInfo.size <= targetSize) {
        break;
      }

      // Decrease the quality by 5 and try again
      quality -= 5;
    }

    return result;
  }
}
