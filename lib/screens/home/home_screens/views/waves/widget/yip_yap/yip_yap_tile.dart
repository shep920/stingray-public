import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/helpers/diceroll_avatars.dart';
import 'package:hero/screens/home/home_screens/direct_message/direct_message_popup.dart';
import 'package:hero/screens/home/home_screens/views/waves/wave_image.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/verified_icon.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/wave_video_preview.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/yip_yap/my_dislike_button.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/yip_yap/my_like_button.dart';
import 'package:hero/screens/home/home_screens/votes/vote_screen.dart';
import 'package:hero/widgets/profilePics.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:vibration/vibration.dart';
import '../../../../../../../blocs/vote/vote_bloc.dart' as vote;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';

import '../../../../../../../blocs/profile/profile_bloc.dart';
import '../../../../../../../blocs/wave_liking/wave_liking_bloc.dart';
import '../../../../../../../models/user_model.dart';
import '../../../../../../../models/posts/wave_model.dart';
import '../../../../../../../widgets/text_splitter.dart';
import '../../../generic_view.dart';
import '../../../photo_view/photo_view.dart';
import '../../compose_wave_reply_screen.dart';
import '../../wave_tile_popup.dart';

class YipYapTile extends StatelessWidget {
  const YipYapTile({
    Key? key,
    required this.poster,
    required this.wave,
    this.extendBelow = false,
    this.showDivider = true,
    this.showButtons = true,
    this.showPopup = true,
    this.onDeleted,
  }) : super(key: key);

  final User poster;
  final Wave wave;
  final bool extendBelow;
  final bool showDivider;
  final bool showButtons;
  final bool showPopup;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    User user =
        (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;
    return IntrinsicHeight(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                waveColumn(context),
                Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        waveHeader(poster, wave, context, user,
                            onDeleted: onDeleted, showPopup: showPopup),
                        waveText(wave, context),
                        if (wave.imageUrl != null) WaveImage(wave: wave),
                        if (wave.videoUrl != null &&
                            wave.videoUrl != 'noVideo' &&
                            wave.videoUrl != 'null')
                          WaveVideoPreview(
                              videoUrl: wave.videoUrl,
                              wave: wave,
                              poster: poster),
                        if (showButtons) waveButtons(wave, poster),
                        if (!showButtons)
                          Container(
                            margin: const EdgeInsets.only(
                                top: 1.0, right: 20.0, bottom: 10.0),
                          )
                      ],
                    ))
              ],
            ),
          ),
          if (showDivider) WaveDivider(),
        ],
      ),
    );
  }

  Expanded waveColumn(BuildContext context) {
    return Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfilePics.genericPic(
                context: context, poster: poster, wave: wave),

            if (extendBelow)
              Expanded(
                child: VerticalDivider(
                  color: Color.fromARGB(255, 207, 207, 207),
                  thickness: 2,
                  width: 10,
                ),
              ),

            //add a grey line
          ]),
    );
  }
}

Widget waveHeader(User poster, Wave wave, BuildContext context, User user,
    {required VoidCallback? onDeleted, required bool showPopup}) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Text(
              '${timeago.format(wave.createdAt, locale: 'en_short')}',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context).accentColor.withOpacity(0.5)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showPopup)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: WaveTilePopup(
                    poster: poster,
                    wave: wave,
                    user: user,
                    onDeleted: onDeleted),
              ),
            ),
        ],
      ),
    ],
  );
}

Widget waveText(Wave wave, BuildContext context) {
  return Flexible(
      child: Padding(
    padding: const EdgeInsets.only(right: 18.0),
    child: TextSplitter(
      wave.message,
      context,
      Theme.of(context).textTheme.subtitle2!,
    ),
  ));
}

Widget waveButtons(Wave wave, User poster) {
  return BlocBuilder<ProfileBloc, ProfileState>(
    builder: (context, profileState) {
      if (profileState is ProfileLoading) {
        return Container();
      }
      if (profileState is ProfileLoaded) {
        User user = profileState.user;
        return Container(
          margin: const EdgeInsets.only(top: 10.0, right: 20.0, bottom: 10.0),
          child: YipYapButtons(user: user, wave: wave, poster: poster),
        );
      }
      return Container();
    },
  );
}

class YipYapButtons extends StatelessWidget {
  final Wave wave;
  final User poster;
  const YipYapButtons({
    super.key,
    required this.user,
    required this.wave,
    required this.poster,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(wave.comments.toString(),
                style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Theme.of(context).accentColor.withOpacity(0.5))),
            SizedBox(width: 5),
            InkWell(
              child: FaIcon(
                FontAwesomeIcons.comment,
                size: 30.0,
                color: Colors.grey,
              ),
              onTap: () {
                Navigator.pushNamed(context, ComposeWaveReplyScreen.routeName,
                    arguments: {'wave': wave, 'originalPoster': poster});
              },
            ),
          ],
        ),
        if (poster.id != user.id && wave.type != Wave.yip_yap_type)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              child: FaIcon(
                FontAwesomeIcons.paperPlane,
                size: 30.0,
                color: Colors.grey,
              ),
              onTap: () {
                if (user.dailyDmsRemaining > 0) {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return DirectMessagePopup(
                        voteTarget: poster,
                        secret: (wave.type == Wave.yip_yap_type),
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("You have no more DMs left for today!"),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
            ),
          ),
        Spacer(),
        Row(
          children: [
            MyLikeButton(user: user, wave: wave, poster: poster),
            SizedBox(width: 5),
            MyDislikeButton(user: user, wave: wave, poster: poster),
          ],
        ),
      ],
    );
  }
}
