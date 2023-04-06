import 'package:flutter/material.dart';

class CollapsibleMenu extends StatefulWidget {
  final String title;
  final Widget body;

  CollapsibleMenu({required this.title, required this.body});

  @override
  _CollapsibleMenuState createState() => _CollapsibleMenuState();
}

class _CollapsibleMenuState extends State<CollapsibleMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animationOpacity;
  late Animation<double> _animationSize;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animationOpacity = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationSize = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
              if (_isExpanded) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            });
          },
          child: ListTile(
            title: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline4,
            ),
            leading: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animationSize,
          child: FadeTransition(
            opacity: _animationOpacity,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: widget.body,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
