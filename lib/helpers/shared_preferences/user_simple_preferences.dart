import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;

  static const _keyUsername = 'username';
  static const _keyVideos = 'videos';
  static const _keyStoryIds = 'storyIds';
  static const _keyBirthday = 'birthday';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static String? getUsername() => _preferences.getString(_keyUsername);

  static Future setSeenVideos(bool seenVideos) async =>
      await _preferences.setBool(_keyVideos, seenVideos);

  static bool? getSeenVideos() => _preferences.getBool(_keyVideos);

  static Future setSeenStoryIds(List<String> ids) async =>
      await _preferences.setStringList(_keyStoryIds, ids);

  static List<String>? getSeenStoryIds() =>
      _preferences.getStringList(_keyStoryIds);

  static void saveData(String key, dynamic value) async {
    if (value is int) {
      _preferences.setInt(key, value);
    } else if (value is String) {
      _preferences.setString(key, value);
    } else if (value is bool) {
      _preferences.setBool(key, value);
    } else {
      print("Invalid Type");
    }
  }

  static Future<dynamic> readData(String key) async {
    dynamic obj = _preferences.get(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    return _preferences.remove(key);
  }
}
