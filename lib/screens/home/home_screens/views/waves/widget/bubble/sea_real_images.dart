import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/bubble/bubble_images.dart';

class SeaRealImages extends StatefulWidget {
  const SeaRealImages({
    super.key,
    required this.wave,
  });

  final Wave wave;

  @override
  State<SeaRealImages> createState() => _SeaRealImagesState();
}

class _SeaRealImagesState extends State<SeaRealImages> {
  bool _isFrontImageVisible = true;

  bool _showFront = true;

  @override
  void initState() {
    super.initState();
  }

  void _switchImages() {
    setState(() {
      _isFrontImageVisible = !_isFrontImageVisible;
      _showFront = !_showFront;
    });

    //wait 250 milliseconds, then change the bool again
    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        _isFrontImageVisible = !_isFrontImageVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: SizedBox(
            height: 600,
            width: 720,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _isFrontImageVisible ? 1.0 : 0.75,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: (_showFront)
                      ? widget.wave.frontImageUrl
                      : widget.wave.backImageUrl,
                  fit: BoxFit.cover,
                  memCacheHeight: 1200,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 25,
          left: 25,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _switchImages,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _isFrontImageVisible ? 1.0 : 0.75,
                child: Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: (!_showFront)
                          ? widget.wave.frontImageUrl
                          : widget.wave.backImageUrl,
                      fit: BoxFit.cover,
                      memCacheHeight: 375,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
