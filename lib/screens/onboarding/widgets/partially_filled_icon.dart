import 'package:flutter/material.dart';

class PartiallyFilledIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final double filledPercentage;

  PartiallyFilledIcon(
      {required this.icon,
      required this.size,
      required this.color,
      required this.filledPercentage});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect rect) {
        return LinearGradient(
          stops: [0, filledPercentage, filledPercentage],
          colors: [color, color, color.withOpacity(0)],
        ).createShader(rect);
      },
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, size: size, color: Colors.grey[300]),
      ),
    );
  }
}
