import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/wave_liking/wave_liking_bloc.dart';
import 'package:hero/helpers/vibration.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:like_button/like_button.dart';
import 'package:vibration/vibration.dart';

class MyLikeButton extends StatelessWidget {
  final Wave wave;
  final double size;
  final Color inactiveColor;
  final User poster;
  const MyLikeButton({
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
    return BlocBuilder<WaveLikingBloc, WaveLikingState>(
      builder: (context, waveLikingState) {
        //set waveLikingState to be WaveLikingLoaded
        waveLikingState = waveLikingState as WaveLikingLoaded;
        bool inShortTermLikes =
            waveLikingState.shortTermLikes.contains(wave.id);
        bool inShortTermDislikes =
            waveLikingState.shortTermDislikes.contains(wave.id);
        bool inLikes = waveLikingState.likes.contains(wave.id);
        bool inDislikes = waveLikingState.dislikes.contains(wave.id);
        bool likedBy = wave.likedBy.contains(user.id);
        bool isLiked = ((likedBy || inLikes || inShortTermLikes) &&
            !(inDislikes || inShortTermDislikes));
        int likeCount = (inLikes || inShortTermLikes)
            ? wave.likes + 1
            : (inDislikes || inShortTermDislikes)
                ? wave.likes - 1
                : wave.likes;

        return LikeButton(
          isLiked: isLiked,
          size: size,
          circleColor:
              CircleColor(start: Colors.red[300]!, end: Colors.red[900]!),
          bubblesColor: BubblesColor(
            dotPrimaryColor: Colors.red[300]!,
            dotSecondaryColor: Color.fromARGB(255, 0, 234, 255),
          ),
          likeBuilder: (bool isLiked) {
            return FaIcon(
              FontAwesomeIcons.arrowUp,
              color: isLiked ? Color.fromARGB(255, 0, 234, 255) : inactiveColor,
              size: size,
            );
          },
          likeCount: likeCount,
          countBuilder: (int? count, bool isLiked, String text) {
            var color =
                isLiked ? Color.fromARGB(255, 0, 234, 255) : inactiveColor;
            Widget result;

            result = Text(text,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: color,
                    ));
            return result;
          },
          onTap: (bool isLiked) async {
            MyVibration.vibrate();
            (isLiked)?BlocProvider.of<WaveLikingBloc>(context)
                    .add(DislikeWave(waveId: wave.id, userId: user.id!, poster: poster))
                : BlocProvider.of<WaveLikingBloc>(context)
                    .add(LikeWave(waveId: wave.id, userId: user.id!, poster: poster));
            return !isLiked;
          },
        );
      },
    );
  }
}
