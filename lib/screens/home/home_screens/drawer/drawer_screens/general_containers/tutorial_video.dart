import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class TutorialVideo extends StatefulWidget {
  final String videoPath;
  final VideoPlayerController videoPlayerController;
  final ChewieController chewieController;

  const TutorialVideo({
    Key? key,
    required this.videoPath,
    required this.videoPlayerController,
    required this.chewieController,
  }) : super(key: key);

  @override
  _TutorialVideoState createState() => _TutorialVideoState();
}

class _TutorialVideoState extends State<TutorialVideo> {
  
  

  @override
  void initState() {
    super.initState();

    // _videoPlayerController = VideoPlayerController.asset(widget.videoPath,
    //     videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));




    
  }

  @override
  void dispose() {
    
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.black,
          child: Chewie(
            controller: widget.chewieController,
          ),
        ),
      ),
    );
  }
}
