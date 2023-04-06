import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MyCache {
  //method get video. It taks a String as a parameter, which is the video url. It checks the flutter cache manager for the video. If it exists, it returns the file. If it doesn't exist, it downloads the video and returns the file. if the video is not found, it downloads it and adds it to the cache.
  static Future<File?> getVideo(String url) async {
    DefaultCacheManager _cacheManager = DefaultCacheManager();
    File? file = await _cacheManager.getSingleFile(url);
    return file;
  }
}
