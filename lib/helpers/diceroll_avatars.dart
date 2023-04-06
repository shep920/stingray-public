import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/models/user_model.dart';

class DiceRollAvatars {
  static Widget getAvatar(
      {required int size,
      required BuildContext context,
      required String userId}) {
    Avatar _avatar = DiceBearBuilder(
      size: size,
      sprite: DiceBearSprite.bottts,
      seed: userId,
    ).build();

    return _avatar.toImage();
  }

  static String getAvatarUrl({required String userId}) {
    Avatar _avatar = DiceBearBuilder(
      sprite: DiceBearSprite.bottts,
      seed: userId,
    ).build();

    String _avatarUrl = _avatar.svgUri.toString();
    return _avatarUrl;
  }
}
