import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/general_containers/floating_icon.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/general_containers/tutorial_video.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:video_player/video_player.dart';

class GeneralContainerChild extends StatefulWidget {
  final List<String> headers;
  final List<String> bodies;
  final List<String> images;
  final Color textColor;
  final Color iconColor;
  final List<List<IconData>> relevantIcons;

  const GeneralContainerChild({
    required this.headers,
    required this.bodies,
    required this.images,
    required this.textColor,
    required this.iconColor,
    required this.relevantIcons,
    Key? key,
  }) : super(key: key);

  @override
  State<GeneralContainerChild> createState() => _GeneralContainerChildState();
}

class _GeneralContainerChildState extends State<GeneralContainerChild> {
  int _index = 0;
  late String _assetPath;
  List<VideoPlayerController> _videoControllers = [];
  List<ChewieController> _chewieControllers = [];
  late int _imageCount;

  initState() {
    super.initState();
    _assetPath = widget.images[_index];
    for (var i = 0; i < widget.images.length; i++) {
      if (widget.images[i].contains('mp4')) {
        _videoControllers.add(VideoPlayerController.asset(widget.images[i],
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
            )));
        _videoControllers.last.setVolume(0);
      }
      //set all video controller volume to 0
    }
    for (var i = 0; i < _videoControllers.length; i++) {
      _chewieControllers.add(ChewieController(
        videoPlayerController: _videoControllers[i],
        aspectRatio: 1 / 2,
        autoPlay: true,
        looping: true,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: false,
        allowedScreenSleep: false,
        showControls: false,
      ));
    }
    _imageCount = //images where the video is not included
        widget.images.where((element) => !element.contains('mp4')).length;
  }

  @override
  dispose() {
    for (var i = 0; i < _videoControllers.length; i++) {
      _videoControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Hero(
            tag: 'tutorialHeader',
            child: Text(
              widget.headers[_index],
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    //hex color of 1B2021
                    color: widget.textColor,
                    //CENTER
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              //min size
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //iconbutton of an arrow going to the left
                IconButton(
                    onPressed: () {
                      setState(() {
                        (_index == 0)
                            ? _index = widget.images.length - 1
                            : _index--;

                        _assetPath = widget.images[_index];
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios, size: 40),
                    color: widget.iconColor),
                if (!widget.images[_index].contains('mp4'))
                  Image.asset(widget.images[_index],
                      height: //half of the screen height
                          MediaQuery.of(context).size.height / 2,
                      width: //half of the screen width
                          MediaQuery.of(context).size.width / 2),

                if (widget.images[_index].contains('mp4'))
                  TutorialVideo(
                      videoPath: _assetPath,
                      videoPlayerController:
                          _videoControllers[_index - _imageCount],
                      chewieController:
                          _chewieControllers[_index - _imageCount]),
                //iconbutton of an arrow going to the right
                IconButton(
                    onPressed: () {
                      setState(() {
                        (_index == widget.images.length - 1)
                            ? _index = 0
                            : _index++;

                        _assetPath = widget.images[_index];
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios, size: 40),
                    //hex color of 1B2021
                    color: widget.iconColor),
              ],
            ),
          ),

          //make a row for the relevant icons
          if (widget.relevantIcons.isNotEmpty &&
              widget.relevantIcons[_index].isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Relevant Icons:',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        //hex color of 1B2021
                        color: widget.textColor,
                      ),
                ),
                for (var i = 0; i < widget.relevantIcons[_index].length; i++)
                  FloatingIcon(
                    icon: widget.relevantIcons[_index][i],
                    color: widget.iconColor,
                  ),
              ],
            ),
          //text of the body
          Text(widget.bodies[_index],
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    //hex color of 1B2021
                    color: widget.textColor,
                  )),

          const SizedBox(height: 20),
          StepProgressIndicator(
            totalSteps: widget.images.length,
            currentStep: _index + 1,
            selectedColor: Theme.of(context).colorScheme.primary,
            unselectedColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ],
      ),
    );
  }
}
