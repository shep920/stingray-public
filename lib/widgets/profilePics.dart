import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hero/blocs/vote/vote_bloc.dart';
import 'package:hero/helpers/diceroll_avatars.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';

class ProfilePics {
  static Widget genericPic(
      {required Wave wave,
      required BuildContext context,
      required User poster,
      double width = 20,
      double height = 20}) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: ClipOval(
              child: (wave.type == Wave.default_type)
                  ? CachedNetworkImage(
                      imageUrl: poster.imageUrls[0]!,
                      fit: BoxFit.cover,
                      memCacheWidth: 100,
                      memCacheHeight: 100,
                    )
                  : SvgPicture.network(
                      DiceRollAvatars.getAvatarUrl(userId: poster.id!))),
        ));
  }
}
