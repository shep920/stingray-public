import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hero/models/posts/wave_model.dart';

class BubbleImages extends StatefulWidget {
  const BubbleImages({
    super.key,
    required this.wave,
  });

  final Wave wave;

  @override
  State<BubbleImages> createState() => _BubbleImagesState();
}

class _BubbleImagesState extends State<BubbleImages> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
          child: SizedBox(
            height: 360,
            width: 360,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.wave.bubbleImageUrls!.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.wave.bubbleImageUrls![index],
                    memCacheHeight: 720,
                    memCacheWidth: 720,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
        //linear progress indicator
        if (widget.wave.bubbleImageUrls!.length > 1)
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < widget.wave.bubbleImageUrls!.length; i++)
                  Container(
                    margin: const EdgeInsets.only(right: 5.0),
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? Theme.of(context).accentColor
                          : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class MyCahchedNetworkImage extends StatelessWidget {
  const MyCahchedNetworkImage({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      placeholder: (context, url) => Container(
        height: 200,
        width: double.infinity,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: 200,
        width: double.infinity,
        child: const Center(
          child: Icon(Icons.error),
        ),
      ),
      fit: BoxFit.fill,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
