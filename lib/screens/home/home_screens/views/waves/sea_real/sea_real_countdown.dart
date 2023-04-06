import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class SeaRealCountDown extends StatefulWidget {
  const SeaRealCountDown({Key? key}) : super(key: key);

  @override
  _SeaRealCountDownState createState() => _SeaRealCountDownState();
}

class _SeaRealCountDownState extends State<SeaRealCountDown> {
  late CountdownTimerController _countdownController;
  bool _isLate = false;

  @override
  void initState() {
    super.initState();
    // calculate the time difference between now and the last occurrence of 10:00 PM
    final now = DateTime.now();
    final lastTenPm = DateTime(now.year, now.month, now.day, 22);
    final difference = now.difference(lastTenPm);
    _isLate = difference.isNegative;
    _countdownController = CountdownTimerController(
      endTime:
          DateTime.now().millisecondsSinceEpoch + difference.inMilliseconds,
      onEnd: () {
        setState(() {
          _isLate = true;
        });
      },
    );
  }

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWithinTwoMinutes = !_isLate &&
        DateTime.now().hour == 22 &&
        DateTime.now().minute >= 0 &&
        DateTime.now().minute < 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SeaReal.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (isWithinTwoMinutes)
          Text(
            'On Time SeaReal',
            style: TextStyle(
              fontSize: 16,
              //lighter font weight
              fontWeight: FontWeight.w300,
            ),
          )
        else if (_isLate)
          Text(
            'Late SeaReal',
            style: TextStyle(
              fontSize: 16,
              //lighter font weight
              fontWeight: FontWeight.w300,
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
