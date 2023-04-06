import 'dart:ui';
//import rive as riv
import 'package:rive/rive.dart' as riv;

import 'package:flutter/material.dart';

class MovingGradientBackground extends StatefulWidget {
  const MovingGradientBackground({Key? key}) : super(key: key);

  @override
  _MovingGradientBackgroundState createState() =>
      _MovingGradientBackgroundState();
}

class _MovingGradientBackgroundState extends State<MovingGradientBackground>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Create an AnimationController with a duration of 10 seconds
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: const riv.RiveAnimation.asset('assets/riv/coffee.riv',
          fit: BoxFit.cover),
    );
  }
}
