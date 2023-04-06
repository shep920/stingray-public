import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/swipe/swipe_bloc.dart';
import 'package:hero/blocs/user%20discovery%20swiping/user_discovery_bloc.dart';
import 'package:hero/blocs/vote/vote_bloc.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/verified_icon.dart';
import 'package:hero/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DiscoveryUserCard extends StatelessWidget {
  final User? user;
  final int imageUrlIndex;
  final bool votable;
  const DiscoveryUserCard({
    Key? key,
    required this.user,
    required this.imageUrlIndex,
    this.votable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .75,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Hero(
            tag: user!.id!,
            child: Stack(
              children: [
                Container(
                  color: Theme.of(context).dividerColor,
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          user!.imageUrls[imageUrlIndex],
                        )),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
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
            bottom: 75,
            child: Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(0, 0, 0, 0),
                    Color.fromARGB(200, 0, 0, 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            child: Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                //only circular bottom left and right
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(200, 0, 0, 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          GestureDetector(child: LayoutBuilder(builder: (ctx, constraints) {
            return Align(
              alignment: Alignment.centerRight,
              child: Opacity(
                opacity: 0.0,
                child: Container(
                  color: Colors.black,
                  height: constraints.maxHeight,
                  width: constraints.maxWidth * 0.3,
                ),
              ),
            );
          }), onTap: () {
            Provider.of<UserDiscoveryBloc>(context, listen: false)
                .add(IncrementUserDiscoveryImageUrlIndex());
          }),
          GestureDetector(child: LayoutBuilder(builder: (ctx, constraints) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Opacity(
                opacity: 0.0,
                child: Container(
                  color: Colors.transparent,
                  height: constraints.maxHeight,
                  width: constraints.maxWidth * 0.3,
                ),
              ),
            );
          }), onTap: () {
            Provider.of<UserDiscoveryBloc>(context, listen: false)
                .add(DecrementUserDiscoveryImageUrlIndex());
          }),
          Positioned(
            bottom: 70,
            left: 20,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: user!.id! + 'name',
                      child: Row(
                        children: [
                          Text(
                            '${user!.name}, ${user!.age}',
                            style:
                                Theme.of(context).textTheme.headline2!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          if (user!.verified) VerifiedIcon(size: 20),
                        ],
                      ),
                    ),
                    Text(
                      '${user!.handle}',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (imageUrlIndex == 0)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          '${user!.bio}',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                          //set overflow to ellipsis
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (imageUrlIndex == 1)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          '${user!.gender}',
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    color: Colors.grey,
                                  ),
                          //set overflow to ellipsis
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    if (imageUrlIndex == 2)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          'Votes: ${user!.votes}',
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    color: Colors.grey,
                                  ),
                          //set overflow to ellipsis
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    //if the imageurlindex is 0, then show the name
                  ],
                ),
              ],
            ),
          ),
          //an info button positioned to  the bottom right

          Positioned(
            bottom: 70,
            right: 20,
            child:
                //an icon button with an info icon
                Hero(
              tag: user!.id! + 'info',
              child: GestureDetector(
                child: Icon(
                  Icons.info,
                  //scaffold background color
                  color: Colors.white,
                  //mak eit bigger
                  size: 40,
                ),
                onTap: () {
                  BlocProvider.of<VoteBloc>(context)
                      .add(LoadUserEvent(user: user!));
                  Navigator.of(context).pushNamed('/votes');
                },
              ),
            ),
          ),

          Positioned(
              child: StepProgressIndicator(
                totalSteps: user!.imageUrls.length,
                currentStep: imageUrlIndex + 1,
                selectedColor: Theme.of(context).colorScheme.primary,
                unselectedColor: Theme.of(context).scaffoldBackgroundColor,
                size: 5,
              ),
              top: 10,
              left: 0,
              right: 0),
          //positioned container near the bottom that has a gradient from transparent to black
        ],
      ),
    );
  }
}
