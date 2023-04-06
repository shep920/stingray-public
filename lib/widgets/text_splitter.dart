import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/config/extra_colors.dart';

import '../blocs/vote/vote_bloc.dart';

Widget TextSplitter(String input, BuildContext context, TextStyle textStyle) {
  List<TextSpan> textSpans = [];
  int atCount =
      //the number of occurences of @ in the input string
      input.split('@').length - 1;

  for (var i = 0; i <= atCount; i++) {
    String part = input.substring(
        0, input.indexOf('@') == -1 ? input.length : input.indexOf('@'));
    textSpans.addAll(greaterThanTextSpans(part, context, textStyle));

    input = input
        .substring(input.contains('@') ? input.indexOf('@') : input.length);
    String clickable = input.substring(
        0, input.indexOf(' ') == -1 ? input.length : input.indexOf(' '));
    textSpans.add(
      TextSpan(
        text: clickable,
        style: textStyle.copyWith(
          color: ExtraColors.highlightColor,
        ),
        recognizer: new TapGestureRecognizer()
          ..onTap = () {
            //with blocprovider, add the vote event loadUserFromHandle
            //and pass the handle as a parameter
            BlocProvider.of<VoteBloc>(context).add(
              LoadVoteUserFromHandle(handle: clickable, context: context),
            );
          },
      ),
    );
    input = input.substring(
        input.indexOf(' ') == -1 ? input.length : input.indexOf(' '));
  }

  return RichText(
    text: TextSpan(
      children: textSpans,
    ),
  );
}

List<TextSpan> greaterThanTextSpans(
    String input, BuildContext context, TextStyle textStyle) {
  List<TextSpan> textSpans = [];
  int greaterThanCount = input.split('>').length - 1;

  for (var i = 0; i <= greaterThanCount; i++) {
    String part = input.substring(
        0, input.indexOf('>') == -1 ? input.length : input.indexOf('>'));
    textSpans.add(
      TextSpan(
        text: part,
        style: textStyle,
      ),
    );
    input = input
        .substring(input.contains('>') ? input.indexOf('>') : input.length);
    String clickable = input.substring(
        0, input.indexOf('\n') == -1 ? input.length : input.indexOf('\n'));
    textSpans.add(
      TextSpan(
        text: clickable,
        style: textStyle.copyWith(
          color: Colors.green,
        ),
      ),
    );
    input = input.substring(
        input.indexOf('\n') == -1 ? input.length : input.indexOf('\n'));
  }
  return textSpans;
}
