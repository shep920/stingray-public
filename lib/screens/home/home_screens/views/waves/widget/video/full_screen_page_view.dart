import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/cubits/trolling-police/trolling_cubit.dart';
import 'package:hero/helpers/bloc_set.dart';
import 'package:hero/helpers/cache_manager/cache_manager.dart';
import 'package:hero/helpers/get.dart';
import 'package:hero/models/arguements/full_screen_video_arg.dart';
import 'package:hero/models/arguements/video_page_view_arg.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:hero/screens/home/home_screens/direct_message/direct_message_popup.dart';
import 'package:hero/screens/home/home_screens/views/waves/wave_tile_popup.dart';
import 'package:hero/screens/home/home_screens/views/waves/waves_replies_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/full_screen_viewer.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/yip_yap/my_dislike_button.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/yip_yap/my_like_button.dart';
import 'package:path_provider/path_provider.dart';

import 'package:video_player/video_player.dart';

class WaveVideoPageView extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  final User? poster;
  final Wave? wave;
  final bool isFromMainPage;

  static const routeName = '/wave-video-page-view';

  const WaveVideoPageView(
      {super.key,
      this.videoFile,
      this.videoUrl,
      this.poster,
      this.wave,
      this.isFromMainPage = false});

  static Route route({required PageViewArg arg}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => WaveVideoPageView(
          videoFile: arg.videoFile,
          videoUrl: arg.videoUrl,
          poster: arg.poster,
          wave: arg.wave),
    );
  }

  @override
  _WaveVideoPageViewState createState() => _WaveVideoPageViewState();
}

class _WaveVideoPageViewState extends State<WaveVideoPageView> {
  late List<Wave?> waves;
  late List<User> posters;
  List<dynamic> newlySeenWaveIds = [];
  late String userId;
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  bool hasMore = true;

  int index = 0;
  void initState() {
    waves = (widget.wave == null) ? [] : [widget.wave!];
    posters = (widget.poster == null) ? [] : [widget.poster!];
    userId = Get.blocUser(context).id!;
    super.initState();

    _initAsync();
  }

  void _initAsync() async {
    await getWaves(initialLoad: true).then((value) {
      getPosters();
    });
  }

  void getPosters() {
    for (Wave? wave in waves) {
      if (!posters.any((element) => element.id == wave!.senderId)) {
        FirestoreRepository().getFutureUser(wave!.senderId).then((value) {
          setState(() {
            posters.add(value);
          });
        });
      }
    }
  }

  Future<void> getWaves({required bool initialLoad}) async {
    List<String> _waveIds = waves.map((e) => e!.id).toList();

    if (initialLoad) {
      List<String> _seenWaveIds = await FirestoreRepository()
          .getSeenVideoIds(Get.blocUser(context).id!);

      _waveIds.addAll(_seenWaveIds);
    }

    List<Wave?> _waves = await TypesenseRepository().getVideoWaves(
        waveIds: _waveIds,
        user: (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded)
            .user);

    setState(() {
      if (_waves.length < 5) {
        hasMore = false;
      }
      waves.addAll(_waves);
    });
    if (waves.isNotEmpty) {
      BlocSet.kelpMemories(context, [waves[0]!.id]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User user = profileState.user;
          return Scaffold(
            backgroundColor: Colors.black,
            body: PageView.builder(
              onPageChanged: (int index) {
                if (index == waves.length - 1 && hasMore) {
                  getWaves(initialLoad: false).then((value) => getPosters());
                }
                setState(() {
                  this.index = index;
                  //if newlySeenWaveIds does not contain the wave id, add it
                  if (!newlySeenWaveIds.contains(waves[index]!.id)) {
                    newlySeenWaveIds.add(waves[index]!.id);
                    BlocSet.kelpMemories(context, [waves[index]!.id]);
                  }
                });
              },
              scrollDirection: Axis.vertical,
              itemCount: waves.length,
              itemBuilder: (context, index) {
                Wave _wave = waves[index]!;
                User _poster = posters.firstWhere(
                    (element) => element.id == _wave.senderId,
                    orElse: () => User.anon('anon'));
                return Stack(
                  children: [
                    FullScreenVideoPlayer(
                      videoUrl: _wave.videoUrl,
                      wave: _wave,
                      poster: _poster,
                      user: user,
                      isFromMainPage: widget.isFromMainPage,
                    ),
                  ],
                );
              },
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    if (newlySeenWaveIds.isNotEmpty) {
      FirestoreRepository()
          .setSeenVideoIds(userId: userId, waveIds: newlySeenWaveIds);
    }
    super.dispose();
  }
}
