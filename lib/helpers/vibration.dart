import 'package:vibration/vibration.dart';

class MyVibration {
  static Future<void> vibrate() async {
    bool? canVibrate = await Vibration.hasVibrator();
    if (canVibrate != null && canVibrate) {
      Vibration.vibrate(pattern: [1, 100], intensities: [1, 100]);
    }
  }
}
