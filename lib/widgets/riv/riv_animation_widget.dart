// import 'package:flutter/material.dart';
// import 'package:rive/rive.dart';

// class RiveAnimationWidget extends StatefulWidget {
//   final String filename;

//   RiveAnimationWidget({required this.filename});

//   @override
//   _RiveAnimationWidgetState createState() => _RiveAnimationWidgetState();
// }

// class _RiveAnimationWidgetState extends State<RiveAnimationWidget> {
//   late RiveAnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     //initialize the controller. Load the artboard from widget.filename
//     _controller = SimpleAnimation('idle');

//     //listen for when the artboard is loaded
//     _controller.onInit = (artboard) {
//       //set the artboard to the size of the widget
//       artboard.fit = BoxFit.contain;
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Rive(
//       filename: widget.filename,
//       controller: _controller,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
