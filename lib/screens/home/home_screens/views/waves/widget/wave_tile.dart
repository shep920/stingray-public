import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/helpers/vibration.dart';
import 'package:hero/models/arguements/full_screen_video_arg.dart';
import 'package:hero/models/arguements/video_page_view_arg.dart';
import 'package:hero/screens/home/home_screens/views/waves/wave_image.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/bubble/bubble_tile.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/verified_icon.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/full_screen_page_view.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/full_screen_viewer.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/wave_video_preview.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/yip_yap/yip_yap_tile.dart';
import 'package:hero/screens/home/home_screens/votes/vote_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../../../blocs/vote/vote_bloc.dart' as vote;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';

import '../../../../../../blocs/profile/profile_bloc.dart';
import '../../../../../../blocs/wave_liking/wave_liking_bloc.dart';
import '../../../../../../models/user_model.dart';
import '../../../../../../models/posts/wave_model.dart';
import '../../../../../../widgets/text_splitter.dart';
import '../../generic_view.dart';
import '../../photo_view/photo_view.dart';
import '../compose_wave_reply_screen.dart';
import '../wave_tile_popup.dart';

class WaveTile extends StatefulWidget {
  const WaveTile({
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
  State<WaveTile> createState() => _WaveTileState();
}

class _WaveTileState extends State<WaveTile> {
  late User user;

  @override
  void initState() {
    user = (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.wave.type == Wave.default_type)
        ? (widget.wave.style == Wave.defaultStyle)
            ? IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          waveColumn(context),
                          Expanded(
                              flex: 5,
                              child: Column(
                                //take min

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  waveHeader(
                                      widget.poster, widget.wave, context, user,
                                      onDeleted: widget.onDeleted,
                                      showPopup: widget.showPopup),
                                  waveText(widget.wave, context),
                                  if (widget.wave.imageUrl != null)
                                    WaveImage(wave: widget.wave),
                                  if (widget.wave.videoUrl != null &&
                                      widget.wave.videoUrl != 'noVideo' &&
                                      widget.wave.videoUrl != 'null')
                                    WaveVideoPreview(
                                      videoUrl: widget.wave.videoUrl,
                                      wave: widget.wave,
                                      poster: widget.poster,
                                    ),
                                  if (widget.showButtons)
                                    waveButtons(widget.wave, widget.poster),
                                  if (!widget.showButtons)
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10.0, right: 20.0, bottom: 10.0),
                                    )
                                ],
                              ))
                        ],
                      ),
                    ),
                    //horizontal divider
                    if (widget.showDivider) WaveDivider(),
                  ],
                ),
              )
            : BubbleTile(
                poster: widget.poster,
                wave: widget.wave,
                onDeleted: widget.onDeleted,
                showPopup: widget.showPopup,
                showDivider: widget.showDivider,
                showButtons: widget.showButtons,
              )
        : YipYapTile(
            poster: widget.poster,
            wave: widget.wave,
            onDeleted: widget.onDeleted,
            showPopup: widget.showPopup,
            extendBelow: widget.extendBelow,
            showDivider: widget.showDivider,
            showButtons: widget.showButtons,
          );
  }

  Expanded waveColumn(BuildContext context) {
    return Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
              width: 40,
              height: 40,
              child: InkWell(
                child: Hero(
                  tag: 'wave${widget.wave.id}',
                  child: CircleAvatar(
                      child: ClipOval(
                          child: CachedNetworkImage(
                    imageUrl: widget.poster.imageUrls[0]!,
                    fit: BoxFit.cover,
                    memCacheWidth: 100,
                    memCacheHeight: 100,
                  ))),
                ),
                onTap: () {
                  BlocProvider.of<vote.VoteBloc>(context)
                      .add(vote.LoadUserEvent(user: widget.poster));
                  Navigator.pushNamed(
                    context,
                    VoteScreen.routeName,
                  );
                },
              ),
            ),

            if (widget.extendBelow)
              Expanded(
                child: VerticalDivider(
                  color: Theme.of(context).backgroundColor,
                  thickness: 1,
                  width: 10,
                ),
              ),

            //add a grey line
          ]),
    );
  }
}

class WaveDivider extends StatelessWidget {
  const WaveDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      height: .8,
      color: Theme.of(context).backgroundColor,
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
          Container(
            margin: const EdgeInsets.only(right: 2.0),
            child: Text(
              poster.name,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          //a container that if the poster is verified, shows a checkmark
          if (poster.verified)
            VerifiedIcon(
              size: 20,
              margin: EdgeInsets.only(right: 2),
            ),
          Expanded(
            child: Text(
              '${poster.handle} · ${timeago.format(wave.createdAt, locale: 'en_short')}',
              style: Theme.of(context).textTheme.headline5,
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
      if (wave.replyToHandles!.isNotEmpty)
        Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5.0),
                child: Text('Replying to',
                    style: Theme.of(context).textTheme.subtitle1!),
              ),
              ...wave.replyToHandles!
                  .map((handle) => TextSplitter(
                        '$handle ',
                        context,
                        Theme.of(context).textTheme.subtitle2!,
                      ))
                  .toList(),
            ],
          ),
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
