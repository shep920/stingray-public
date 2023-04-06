import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hero/helpers/cache_manager/cache_manager.dart';
import 'package:hero/helpers/go_to_replies.dart';
import 'package:hero/models/arguements/full_screen_video_arg.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/direct_message/direct_message_popup.dart';
import 'package:hero/screens/home/home_screens/views/waves/wave_tile_popup.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/yip_yap/my_dislike_button.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/yip_yap/my_like_button.dart';
import 'package:hero/widgets/profilePics.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  final Wave wave;
  final User poster;
  final User user;
  final bool isFromMainPage;

  const FullScreenVideoPlayer(
      {super.key,
      this.videoFile,
      this.videoUrl,
      required this.wave,
      required this.poster,
      required this.user,
      this.isFromMainPage = false});

  @override
  _FullScreenPlayerState createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenVideoPlayer>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  ChewieController? _underLayerController;
  Animation<double>? _animation;
  AnimationController? _animationController;
  double _opacity = 0;

  void initState() {
    super.initState();

    _initAsync();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeIn,
      ),
    );
  }

  void _initAsync() async {
    File? _videoFile = widget.videoFile;
    if (_videoFile == null) {
      _videoFile = await getVideo(_videoFile);
    }

    _controller = VideoPlayerController.file(_videoFile!)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _controller!,
              aspectRatio: _controller!.value.aspectRatio,
              autoPlay: (!kDebugMode),
              looping: true,
              allowFullScreen: false,
              allowMuting: false,
              showOptions: false,
              showControlsOnInitialize: false,
              showControls: false,
              autoInitialize: true,
            );
          });
        }
      });
  }

  Future<File?> getVideo(File? _videoFile) async {
    _videoFile = await MyCache.getVideo(widget.videoUrl!);
    return _videoFile;
  }

  @override
  Widget build(BuildContext context) {
    return (_controller?.value.isInitialized ?? false)
        ? Stack(
            children: [
              buildMainVid(),
              buildBottom(context),
              buildColumn(context),
              //a positioned x button in the upper left corner to exit
              if (!widget.isFromMainPage)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10.0,
                  left: 10.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
            ],
          )
        : SizedBox.shrink();
  }

  Positioned buildBottom(BuildContext context) {
    return Positioned(
      left: 10.0,
      bottom: 0.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        //make it go down

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              //spread and blur it all the way to bottom and left
              spreadRadius: 1,
              blurRadius: 10,

              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfilePics.genericPic(
                  poster: widget.poster,
                  wave: widget.wave,
                  context: context,
                ),
                SizedBox(width: 10.0),
                if (widget.wave.type != Wave.yip_yap_type)
                  Text(
                    widget.poster.handle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            Text(
              widget.wave.message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }

  Positioned buildColumn(BuildContext context) {
    return Positioned(
      right: 5.0,
      //make it so that it is relevent to the bottom of the screen padding
      bottom: MediaQuery.of(context).padding.bottom + 10.0,
      child: Column(  
        children: [
          MyLikeButton(
            wave: widget.wave,
            user: widget.user,
            size: 30,
            inactiveColor: Colors.white,
            poster: widget.poster,
          ),
          SizedBox(height: 16.0),
          MyDislikeButton(
            wave: widget.wave,
            user: widget.user,
            size: 30,
            inactiveColor: Colors.white,
            poster: widget.poster,
          ),

          SizedBox(height: 16.0),
          //fontawsome icon for download
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.download,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              //get directory for ios and android

              File? _file = await MyCache.getVideo(widget.videoUrl!);

              final String videoPath = _file!.path;

              GallerySaver.saveVideo(videoPath).then((value) => {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Video saved to gallery!"),
                      duration: Duration(seconds: 2),
                    ))
                  });
            },
          ),
          SizedBox(height: 16.0),
          //fontawsome icon for download
          Row(
            children: [
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.comment,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () async {
                  pause;
                  WaveTile _waveTile = WaveTile(
                    wave: widget.wave,
                    poster: widget.poster,
                  );
                  GoTo.replies(_waveTile, context);
                },
              ),
              Text(
                widget.wave.comments.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          InkWell(
            child: FaIcon(
              FontAwesomeIcons.paperPlane,
              size: 30.0,
              color: Colors.white,
            ),
            onTap: () {
              if (widget.user.dailyDmsRemaining > 0) {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return DirectMessagePopup(
                      voteTarget: widget.poster,
                      secret: (widget.wave.type == Wave.yip_yap_type),
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
          SizedBox(height: 16.0),
          WaveTilePopup(
            poster: widget.poster,
            wave: widget.wave,
            onDeleted: () {},
            user: widget.user,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }

  GestureDetector buildMainVid() {
    return GestureDetector(
      child: Stack(
        children: [
          Chewie(
            controller: _chewieController!,
          ),
          AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(milliseconds: 500),
            child: Center(
              child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                size: 250,
                color: Colors.white,
                progress: _animation!,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        _controller!.value.isPlaying ? pause : play;
      },
    );
  }

  Set<void> get pause {
    return {
      _controller!.pause(),
      _animationController!.reverse(),
      setState(() {
        _opacity = 1;
      })
    };
  }

  Set<void> get play {
    return {
      _controller!.play(),
      _animationController!.forward(),
      setState(() {
        _opacity = 0;
      })
    };
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
