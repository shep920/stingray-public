import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AutoCarasolWidget extends StatefulWidget {
  final List<String> imageUrls;

  final void Function(int) onTap;

  AutoCarasolWidget({required this.imageUrls, required this.onTap});

  @override
  _AutoCarasolWidgetState createState() => _AutoCarasolWidgetState();
}

class _AutoCarasolWidgetState extends State<AutoCarasolWidget> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    //make a raondom int between 2-5
    int randomTime = Random().nextInt(5);

    super.initState();
    // Start auto-scrolling after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carouselController.animateToPage(
        _currentIndex,
        duration: Duration(seconds: randomTime),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: widget.imageUrls.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final imageUrl = widget.imageUrls[index];
        return GestureDetector(
          onTap: () {
            widget.onTap(index);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              memCacheWidth: 300,
              memCacheHeight: 300,
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      carouselController: _carouselController,
    );
  }
}
