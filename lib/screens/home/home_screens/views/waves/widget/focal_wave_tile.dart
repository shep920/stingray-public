// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/vote/vote_bloc.dart';
import 'package:hero/blocs/wave_liking/wave_liking_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/models/arguements/video_page_view_arg.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/screens/home/home_screens/direct_message/direct_message_popup.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/verified_icon.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/full_screen_page_view.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/wave_video_preview.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/yip_yap/yip_yap_tile.dart';
import 'package:hero/widgets/profilePics.dart';
import 'package:hero/widgets/text_splitter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

import '../compose_wave_reply_screen.dart';
import 'yip_yap/my_dislike_button.dart';
import 'yip_yap/my_like_button.dart';

class FocalWaveTile extends StatelessWidget {
  const FocalWaveTile({
    Key? key,
    required this.poster,
    required this.wave,
    required this.user,
  }) : super(key: key);

  final User poster;
  final Wave wave;

  final User user;

  @override
  Widget build(BuildContext context) {
    return (wave.style != Wave.bubbleStyle && wave.style != Wave.seaRealStyle)
        ? Padding(
            padding: //only the left, right and above
                const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: //screen width
                  MediaQuery.of(context).size.width * .9,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ProfilePics.genericPic(
                          wave: wave,
                          context: context,
                          poster: poster,
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (wave.type != Wave.yip_yap_type)
                              Row(
                                children: [
                                  Text(
                                    poster.name,
                                    style: //headline 3
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  //verified badge
                                  if (poster.verified)
                                    VerifiedIcon(
                                      size: 20,
                                    ),
                                ],
                              ),
                            if (wave.type != Wave.yip_yap_type)
                              Row(
                                children: [
                                  Text(
                                    poster.handle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                          ],
                        ),
                        //align three dot dropdown to the right
                        Spacer(),
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text('Report Wave'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (wave.replyToHandles!.isNotEmpty &&
                        wave.type == Wave.default_type)
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5.0),
                              child: Text('Replying to',
                                  style:
                                      Theme.of(context).textTheme.subtitle1!),
                            ),
                            ...wave.replyToHandles!.toSet().map((handle) {
                              return TextSplitter(
                                '$handle ',
                                context,
                                Theme.of(context).textTheme.subtitle2!,
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    Flexible(
                      child: TextSplitter(
                          wave.message,
                          context,
                          Theme.of(context).textTheme.headline3!.copyWith(
                                fontWeight: FontWeight.normal,
                              )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (wave.imageUrl != null)
                      Flexible(
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: wave.imageUrl!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (wave.videoUrl != null && wave.videoUrl != 'noVideo')
                      WaveVideoPreview(
                        videoUrl: wave.videoUrl,
                        wave: wave,
                        poster: poster,
                      ),
                    //show the date formatted with hour:minute AM/PM then the date
                    Text(
                        DateFormat('hh:mm a - dd MMMM yyyy')
                            .format(wave.createdAt),
                        style: //body text 2
                            Theme.of(context).textTheme.bodyText1),
                    SizedBox(
                      height: 10,
                    ),
                    //gray line
                    Divider(
                      color: Theme.of(context).backgroundColor,
                      height: .1,
                      thickness: .1,
                    ),

                    YipYapButtons(
                      wave: wave,
                      user: user,
                      poster: poster,
                    ),
                    if (wave.type == Wave.yip_yap_type)
                      SizedBox(
                        height: 10,
                      ),
                    WaveDivider()
                  ]),
            ),
          )
        : WaveTile(
            poster: poster,
            wave: wave,
          );
  }
}
