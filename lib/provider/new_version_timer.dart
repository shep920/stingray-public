import 'dart:async';

import 'package:flutter/material.dart';

class NewVersionTimer extends ChangeNotifier {
  int _minutes = 0;
  Timer? _timer;
  bool isFinished = false;

  int get seconds => _minutes;

  void start() {
    isFinished = false;
    _timer = Timer.periodic(Duration(seconds: 5), (t) {
      print('beep');
      isFinished = true;
      notifyListeners();
    });
    notifyListeners();
  }

  void stop() {
    _timer!.cancel();
  }

  void reset() {
    stop();
    _minutes = 0;
    notifyListeners();
  }
}
