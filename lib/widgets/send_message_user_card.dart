import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:hero/blocs/swipe/swipe_bloc.dart';
import 'package:hero/blocs/user%20discovery%20swiping/user_discovery_bloc.dart';
import 'package:hero/models/models.dart';
import 'package:hero/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SendMessageUserCard extends StatelessWidget {
  final User? user;
  final int imageUrlIndex;
  const SendMessageUserCard(
      {Key? key, required this.user, required this.imageUrlIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int size = user!.imageUrls.length;
    return Hero(
      tag: 'user_image',
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .4,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(user!.imageUrls[0])),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user!.name}, ${user!.age}',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      '${user!.jobTitle}',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    Row(
                      children: [
                        // UserImagesSmall(imageUrl: user.imageUrls[1]),
                        // UserImagesSmall(imageUrl: user.imageUrls[2]),
                        // UserImagesSmall(imageUrl: user.imageUrls[3]),
                        // UserImagesSmall(imageUrl: user.imageUrls[4]),
                        // SizedBox(width: 10),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
