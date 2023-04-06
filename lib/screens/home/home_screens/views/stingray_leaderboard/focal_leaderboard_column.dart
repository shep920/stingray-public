import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

class FocalLeaderColumnWidget extends StatefulWidget {
  const FocalLeaderColumnWidget({Key? key}) : super(key: key);

  @override
  _FocalLeaderColumnWidgetState createState() =>
      _FocalLeaderColumnWidgetState();
}

class _FocalLeaderColumnWidgetState extends State<FocalLeaderColumnWidget> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FaIcon(
          FontAwesomeIcons.chessQueen,
          color: Colors.black,
          size: 48,
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 120,
            height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.network(
              'https://picsum.photos/seed/854/600',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          'Hello World',
        ),
      ],
    );
  }
}
