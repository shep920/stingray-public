import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FloatingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;

  const FloatingIcon({required this.icon, required this.color});

  @override
  _FloatingIconState createState() => _FloatingIconState();
}

class _FloatingIconState extends State<FloatingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  late final Animation<double> _offsetAnimation = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
  ]).animate(_controller);

  bool _isVisible = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.25,
        duration: const Duration(milliseconds: 500),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0.0, _offsetAnimation.value),
              child: FaIcon(
                widget.icon,
                color: widget.color,
                size: 50,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      setState(() {
        _isVisible = status == AnimationStatus.completed ||
            status == AnimationStatus.forward;
      });
      if (_offsetAnimation.value == 10.0) {
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            _isVisible = false;
          });
        });
      }
    });
  }
}
