import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/screens/home/home_screens/views/photo_view/photo_view.dart';

class WaveImage extends StatelessWidget {
  final Wave wave;
  const WaveImage({

    super.key,
    required this.wave,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            child: Hero(
              tag: '${wave.imageUrl}',
              child: CachedNetworkImage(
                imageUrl: wave.imageUrl!,
                imageBuilder: (context, imageProvider) => Container(
                  constraints: BoxConstraints(minHeight: 200),
                  child: Image(
                    image: imageProvider,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                MyPhotoView.routeName,
                arguments: {
                  'imageUrl': wave.imageUrl!,
                },
              );
            },
          ),
        ),
      ),
    );
  }
}