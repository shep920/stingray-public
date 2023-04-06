import 'package:flutter/material.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/general_containers/general_container_child.dart';

class GeneralContainer extends StatefulWidget {
  final List<String> headers;
  final List<String> bodies;
  final List<String> images;
  final Color expandedColor;
  final Color collapsedColor;
  final Color textColor;
  final Color iconColor;
  final List<List<IconData>> relevantIcons;
  const GeneralContainer({
    required this.headers,
    required this.bodies,
    required this.images,
    required this.expandedColor,
    required this.collapsedColor,
    required this.textColor,
    required this.iconColor,
    required this.relevantIcons,
    Key? key,
  }) : super(key: key);

  @override
  State<GeneralContainer> createState() => _GeneralContainerState();
}

class _GeneralContainerState extends State<GeneralContainer> {
  double _height = 150;
  bool _isExpanded = false;
  late Color _color;
  late Widget _child;

  @override
  void initState() {
    _color = widget.collapsedColor;
    _child = Text(
      widget.headers[0],
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: widget.textColor,
          fontFamily: 'Roboto',
          fontSize: 38),
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      //rounded corners
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _color,
      ),

      //half second animation
      duration: const Duration(milliseconds: 500),
      //width of all available space
      width: double.infinity,
      height: _height,
      //hex of 26F0F1

      child: TextButton(
        onPressed: () {
          setState(() {
            (_isExpanded)
                ? _height = 150
                : _height = MediaQuery.of(context).size.height * 1.5;
            (_isExpanded)
                ? _color = widget.collapsedColor
                : _color = widget.expandedColor;
            (_isExpanded)
                ? _child = Hero(
                    tag: 'tutorialHeader',
                    child: Text(widget.headers[0],
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              //hex color of 1B2021
                              color: widget.textColor,
                            )),
                  )
                : _child = GeneralContainerChild(
                    headers: widget.headers,
                    bodies: widget.bodies,
                    images: widget.images,
                    textColor: widget.textColor,
                    iconColor: widget.iconColor,
                    relevantIcons: widget.relevantIcons,
                  );
            //asset image of stingray_logo.png

            _isExpanded = !_isExpanded;
          });
        },
        child: _child,
      ),
    );
  }
}
