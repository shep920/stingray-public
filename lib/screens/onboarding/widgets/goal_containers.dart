import 'package:flutter/material.dart';

class GoalContainer extends StatelessWidget {
  final String? text;

  const GoalContainer({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.075,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).backgroundColor,
        ]),
        border: Border.all(color: Theme.of(context).backgroundColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
          child: Text(text!,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.white))),
    );
  }
}
