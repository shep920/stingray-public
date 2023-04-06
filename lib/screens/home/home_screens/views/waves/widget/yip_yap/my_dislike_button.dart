import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/wave_disliking/wave_disliking_bloc.dart';
import 'package:hero/helpers/vibration.dart';

import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:like_button/like_button.dart';
import 'package:vibration/vibration.dart';

class MyDislikeButton extends StatelessWidget {
  final Wave wave;
  final double size;
  final Color inactiveColor;
  final User poster;
  const MyDislikeButton({
    super.key,
    required this.user,
    required this.wave,
    this.size = 30,
    this.inactiveColor = Colors.grey,
    required this.poster,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaveDislikingBloc, WaveDislikingState>(
      builder: (context, waveDislikingState) {
        //set waveDislikingState to be WaveDislikingLoaded
        WaveDislikingLoaded dislikingState =
            waveDislikingState as WaveDislikingLoaded;
        bool inShortTermDislikes =
            dislikingState.shortTermDislikes.contains(wave.id);
        bool inShortTermDislikesRemoved =
            dislikingState.shortTermRemovedDislikes.contains(wave.id);
        bool inLikes = dislikingState.dislikes.contains(wave.id);
        bool inDislikesRemoved =
            dislikingState.removedDislikes.contains(wave.id);
        bool dislikedBy = wave.dislikedBy.contains(user.id);
        bool isDisliked = ((dislikedBy || inLikes || inShortTermDislikes) &&
            !(inDislikesRemoved || inShortTermDislikesRemoved));
        int dislikeCount = (inLikes || inShortTermDislikes)
            ? wave.dislikes + 1
            : (inDislikesRemoved || inShortTermDislikesRemoved)
                ? wave.dislikes - 1
                : wave.dislikes;
        return LikeButton(
          isLiked: isDisliked,
          size: size,
          circleColor: CircleColor(
              start: Color(
                0xFFFFB700,
              ),
              end: Color(0xFFFFB700)),
          bubblesColor: BubblesColor(
            dotPrimaryColor: Color(0xFFFFB700),
            dotSecondaryColor: Color(0xFFFFB700),
          ),
          likeBuilder: (bool isdisliked) {
            return FaIcon(
              FontAwesomeIcons.arrowDown,
              color: isdisliked ? Color(0xFFFFB700) : inactiveColor,
              size: size,
            );
          },
          likeCount: dislikeCount,
          countBuilder: (int? count, bool isdisliked, String text) {
            var color = isdisliked ? Color(0xFFFFB700) : inactiveColor;
            Widget result;

            result = Text(text,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: color,
                    ));
            return result;
          },
          onTap: (bool isdisliked) async {
            MyVibration.vibrate();
            (isdisliked)
                ? BlocProvider.of<WaveDislikingBloc>(context)
                    .add(RemoveDislikeWave(waveId: wave.id, userId: user.id!, poster: poster))
                : BlocProvider.of<WaveDislikingBloc>(context)
                    .add(DislikeWave(waveId: wave.id, userId: user.id!, poster: poster));
            return !isdisliked;
          },
        );
      },
    );
  }
}
