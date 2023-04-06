import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:hero/models/models.dart';
import 'package:hero/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  final Team team;
  const TeamCard({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int size = team.imageUrls.length;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.4,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(team.imageUrls)),
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: Offset(3, 3),
                    )
                  ]),
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
              bottom: 0,
              child: Container(
                width: 177,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${team.name}',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    // Text(
                    //   team.charity,
                    //   style: Theme.of(context).textTheme.headline3!.copyWith(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.normal,
                    //       ),
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () => print('bruh'),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              CachedNetworkImageProvider(team.charityImgUrl)),
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(2, 2),
                        )
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
