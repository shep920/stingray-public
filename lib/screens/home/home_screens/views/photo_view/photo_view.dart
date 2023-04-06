import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MyPhotoView extends StatefulWidget {
  final dynamic imageUrl;

  //make a routename
  static const routeName = '/photo-view';
  //make a route object
  static Route route({required Map<String, dynamic> map}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => MyPhotoView(
        imageUrl: map['imageUrl'],
      ),
    );
  }

  MyPhotoView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<MyPhotoView> createState() => _MyPhotoViewState();
}

class _MyPhotoViewState extends State<MyPhotoView> {
  //add a controller

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: PhotoViewGallery.builder(
            itemCount: 1,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(widget.imageUrl),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: '${widget.imageUrl}'),
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
          ),
          //when the user swipes down, pop the screen
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 50) {
              Navigator.of(context).pop();
            }
            if (details.delta.dy < 50) {
              Navigator.of(context).pop();
            }
          },
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
