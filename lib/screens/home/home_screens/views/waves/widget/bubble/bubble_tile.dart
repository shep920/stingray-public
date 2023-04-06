import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/vote/vote_bloc.dart';
import 'package:hero/helpers/is_wave.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/views/waves/wave_tile_popup.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/bubble/bubble_images.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/bubble/sea_real_images.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/verified_icon.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/yip_yap/yip_yap_tile.dart';
import 'package:hero/screens/home/home_screens/votes/vote_screen.dart';
import 'package:hero/widgets/text_splitter.dart';
//import timeago
import 'package:timeago/timeago.dart' as timeago;

class BubbleTile extends StatefulWidget {
  final User poster;
  final Wave wave;
  final bool showButtons;
  final bool showPopup;
  final void Function()? onDeleted;
  final bool showDivider;
  const BubbleTile({
    super.key,
    required this.poster,
    required this.wave,
    required this.showButtons,
    required this.showPopup,
    this.onDeleted,
    required this.showDivider,
  });

  @override
  State<BubbleTile> createState() => _BubbleTileState();
}

class _BubbleTileState extends State<BubbleTile> {
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  waveHeader(
                      widget.poster,
                      widget.wave,
                      context,
                      (BlocProvider.of<ProfileBloc>(context).state
                              as ProfileLoaded)
                          .user,
                      onDeleted: widget.onDeleted,
                      showPopup: widget.showPopup),
                  if (widget.wave.style == Wave.bubbleStyle)
                    Center(child: BubbleImages(wave: widget.wave)),
                  if (widget.wave.style == Wave.seaRealStyle)
                    SeaRealImages(wave: widget.wave),
                  if (widget.showButtons)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: waveButtons(widget.wave, widget.poster),
                    ),
                  if (!widget.showButtons)
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10.0, right: 20.0, bottom: 10.0),
                    ),
                  if (widget.wave.style != Wave.seaRealStyle)
                    waveText(widget.wave, context, widget.poster),
                ],
              )),
          //horizontal divider
          if (widget.showDivider && widget.wave.style != Wave.seaRealStyle)
            WaveDivider(
              
            ),
        ],
      ),
    );
  }
}

Widget waveHeader(User poster, Wave wave, BuildContext context, User user,
    {required VoidCallback? onDeleted, required bool showPopup}) {
  bool _onTime = IsWave.onTime(wave.createdAt);
  String _lateText = !_onTime ? 'Late' : 'On Time';
  return Padding(
    padding: const EdgeInsets.only(left: 15.0),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
              width: 40,
              height: 40,
              child: InkWell(
                child: Hero(
                  tag: 'wave${wave.id}',
                  child: CircleAvatar(
                    radius: 20,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: poster.imageUrls[0],
                        memCacheHeight: 175,
                        memCacheWidth: 175,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  BlocProvider.of<VoteBloc>(context)
                      .add(LoadUserEvent(user: poster));
                  Navigator.pushNamed(
                    context,
                    VoteScreen.routeName,
                  );
                },
              ),
            ),
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
        SizedBox(
          height: 5,
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
        if (wave.style == Wave.seaRealStyle)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 2.0, left: 5.0),
                child: Text(
                  _lateText,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: (!_onTime)
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).accentColor),
                ),
              ),
              //a container that if the poster is verified, shows a checkmark

              Expanded(
                child: Text(
                  '· ${timeago.format(wave.createdAt, locale: 'en_short')}',
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

Widget waveText(Wave wave, BuildContext context, User poster) {
  return Flexible(
      child: Padding(
    padding: EdgeInsets.only(right: 18.0, left: 15),
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
          margin: EdgeInsets.only(
            top: 10.0,
            left: 10,
            right: 20.0,
            bottom: 10.0,
          ),
          child: YipYapButtons(user: user, wave: wave, poster: poster),
        );
      }
      return Container();
    },
  );
}
