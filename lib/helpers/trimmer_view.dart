import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimmerView extends StatefulWidget {
  final File file;

  const TrimmerView(this.file, {Key? key}) : super(key: key);
  @override
  State<TrimmerView> createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
    //set the end value to the max duration of the video
    setState(() {});
  }

  _saveVideo() {
    setState(() {
      _progressVisibility = true;
    });

    _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        setState(() {
          _progressVisibility = false;
        });
        debugPrint('OUTPUT PATH: $outputPath');
        //pop and return the trimmed video
        Navigator.pop(context, outputPath);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                TextButton(
                  child: _isPlaying
                      ? const Icon(
                          Icons.pause,
                          size: 80.0,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.play_arrow,
                          size: 80.0,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    bool playbackState = await _trimmer.videoPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() => _isPlaying = playbackState);
                  },
                ),
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                Center(
                  child: TrimViewer(
                    trimmer: _trimmer,

                    type: ViewerType.auto,
                    viewerHeight: 100.0,

                    durationStyle: DurationStyle.FORMAT_MM_SS,
                    maxVideoLength: const Duration(seconds: 30),
                    editorProperties: TrimEditorProperties(
                      borderPaintColor: Colors.yellow,
                      borderWidth: 4,
                      borderRadius: 5,
                      circlePaintColor: Colors.yellow.shade800,
                    ),
                    areaProperties: TrimAreaProperties.edgeBlur(
                      thumbnailQuality: 10,
                    ),
                    //make it so that the user can scroll through the video

                    onChangeStart: (value) => _startValue = value,
                    onChangeEnd: (value) => _endValue = value,
                    onChangePlaybackState: (value) =>
                        setState(() => _isPlaying = value),
                  ),
                ),
                SizedBox(
                    height: 50,
                    //text saying 'hold here for 3 sec to scroll video, then an arrow pointing up. Should be at the right side of the screen

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 28.0),
                            child: Text(
                              'Drag the yellow box and hold here to scroll video',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    )),
                //SMALL WHITE TEXT SAying your video can be up to 30 seconds long
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(
                    'Your video can be up to 30 seconds long',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                _sendButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sendButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _progressVisibility ? null : () => _saveVideo(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Send",
              style: TextStyle(
                  color: Colors.white, fontSize: 55, fontFamily: 'Pacifico'),
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 55,
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
