import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hero/helpers/cache_manager/cache_manager.dart';
import 'package:hero/helpers/shared_preferences/user_simple_preferences.dart';
import 'package:hero/models/arguements/full_screen_video_arg.dart';
import 'package:hero/models/arguements/video_page_view_arg.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/full_screen_page_view.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/full_screen_viewer.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/widgets/awesome_dialogs/generic_awesome_dialog.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class WaveVideoPreview extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  final Wave? wave;
  final User? poster;

  WaveVideoPreview({this.videoFile, this.videoUrl, this.poster, this.wave});

  @override
  _WaveVideoPreviewState createState() => _WaveVideoPreviewState();
}

class _WaveVideoPreviewState extends State<WaveVideoPreview> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool firstDoubleTap = false;

  void initState() {
    super.initState();

    _initAsync();

    //add post frame callback to make sure the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void _initAsync() async {
    File? _videoFile = widget.videoFile;
    if (_videoFile == null) {
      _videoFile = await getVideo(_videoFile);
    }

    _controller = VideoPlayerController.file(_videoFile!,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        setState(() {
          _controller!.setVolume(0.0);

          _chewieController = ChewieController(
            videoPlayerController: _controller!,
            aspectRatio: _controller!.value.aspectRatio,
            autoPlay: true,
            looping: true,
            allowFullScreen: false,
          );
        });
      });

    bool? _seenVids = UserSimplePreferences.getSeenVideos();
    if (_seenVids == null || !_seenVids) {
      UserSimplePreferences.setSeenVideos(true);
      setState(() {
        firstDoubleTap = true;
      });
    }
  }

  Future<File?> getVideo(File? _videoFile) async {
    _videoFile = await MyCache.getVideo(widget.videoUrl!);
    return _videoFile;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            height: 200.0,
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: (_controller?.value.isInitialized ?? false)
                ? Chewie(
                    controller: _chewieController!,
                  )
                : SizedBox.shrink(),
          ),
          if (firstDoubleTap)
            //make a container that fills the whole screen with half opacity and grey color with text saying double tap to exit full screen
            Center(
              child: Container(
                height: 200.0,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Text(
                    'Double Tap to Enter Full Screen!',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ),
        ],
      ),
      onDoubleTap: () {
        (widget.wave != null && widget.poster != null)
            ? {
                _chewieController!.pause(),
                Navigator.pushNamed(
                  context,
                  WaveVideoPageView.routeName,
                  arguments: PageViewArg(
                      videoUrl: widget.wave!.videoUrl,
                      wave: widget.wave!,
                      poster: widget.poster!),
                )
              }
            : null;
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
