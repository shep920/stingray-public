import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/vote/vote_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/screens/home/home_screens/views/photo_view/photo_view.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/verified_icon.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/screens/home/home_screens/direct_message/direct_message_popup.dart';
import 'package:hero/screens/home/home_screens/votes/all_waves_screen.dart';
import 'package:hero/screens/home/home_screens/votes/vote_screen.dart';
import 'package:hero/static_data/general_profile_data/bars.dart';
import 'package:hero/static_data/general_profile_data/dorms.dart';
import 'package:hero/static_data/general_profile_data/intramurals.dart';
import 'package:hero/static_data/general_profile_data/leadership.dart';
import 'package:hero/static_data/general_profile_data/nothing_data.dart';
import 'package:hero/static_data/general_profile_data/places.dart';
import 'package:hero/static_data/profile_data.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_test/flutter_test.dart';

class VoteView extends StatefulWidget {
  const VoteView({
    Key? key,
    required this.voteUser,
    required this.imageUrlIndex,
    required this.waves,
    required this.user,
    this.physics = const BouncingScrollPhysics(),
  }) : super(key: key);

  final User voteUser;
  final int imageUrlIndex;

  final List<Wave?> waves;
  final User user;
  final ScrollPhysics physics;

  @override
  State<VoteView> createState() => _VoteViewState();
}

class _VoteViewState extends State<VoteView> {
  late int imageUrlIndex;
  @override
  void initState() {
    imageUrlIndex = widget.imageUrlIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: widget.physics,
      children: [
        SizedBox(
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              InkWell(
                child: Hero(
                  tag: widget.voteUser.id!,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.voteUser.imageUrls[imageUrlIndex],
                        memCacheHeight: 1000,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    MyPhotoView.routeName,
                    arguments: {
                      'imageUrl': widget.voteUser.imageUrls[imageUrlIndex],
                      'index': widget.imageUrlIndex
                    },
                  );
                },
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
                setState(() {
                  if (imageUrlIndex < widget.voteUser.imageUrls.length - 1) {
                    imageUrlIndex++;
                  }
                });

                print(widget.imageUrlIndex);
              }),
              GestureDetector(child: LayoutBuilder(builder: (ctx, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
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
                if (imageUrlIndex > 0) {
                  setState(() {
                    imageUrlIndex--;
                  });
                }

                print(widget.imageUrlIndex);
              }),
              Positioned(
                  child: StepProgressIndicator(
                    totalSteps: widget.voteUser.imageUrls.length,
                    currentStep: imageUrlIndex + 1,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    unselectedColor: Theme.of(context).scaffoldBackgroundColor,
                    size: 5,
                  ),
                  top: 10,
                  left: 0,
                  right: 0),
              //an arrow surrounded by primary color circle positioned in the lower right corner
              Positioned(
                width: 60,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: FaIcon(
                      Icons.arrow_upward_rounded,
                      //scaffold background color
                      color: Theme.of(context).scaffoldBackgroundColor,
                      //make it bigger
                      size: 40,
                    ),
                    onPressed: () {
                      Provider.of<VoteBloc>(context, listen: false)
                          .add(CloseVote());
                      Navigator.pop(context);
                    },
                  ),
                ),
                bottom: 0,
                right: 0,
              ),
              //a small amber alert icon positioned in the lower left corner
              if (widget.voteUser.id != widget.user.id)
                Positioned(
                  child: IconButton(
                    icon: FaIcon(
                      Icons.warning_amber_rounded,
                      //scaffold background color
                      color: Colors.amber,
                      //make it bigger
                      size: 40,
                    ),
                    onPressed: () {
                      //have a modal come from the bottom
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return UserReportPopup(voteUser: widget.voteUser);
                        },
                      );
                    },
                  ),
                  bottom: 0,
                  left: 0,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.voteUser.name,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  if (widget.voteUser.verified) VerifiedIcon(size: 30)
                ],
              ),
              Text(
                widget.voteUser.handle,
                style: Theme.of(context).textTheme.headline4,
              ),
              //gray horizontal line
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //book icon
                  FaIcon(
                    Icons.book,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(widget.voteUser.bio,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(height: 1.5)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  //an icon to represent gender
                  Container(
                      height: 24,
                      width: 24,
                      margin: EdgeInsets.only(top: 4, bottom: 4),
                      child: (widget.voteUser.gender == '')
                          ? Icon(Icons.one_x_mobiledata)
                          : ProfileData.genders(context).firstWhere(
                              (listGender) =>
                                  widget.voteUser.gender == listGender['value'],
                              orElse: () {
                                return Nothing.nothing;
                              },
                            )['icon']),
                  SizedBox(
                    width: 5,
                  ),

                  Text(widget.voteUser.gender,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(height: 1.5)),
                ],
              ),
              //a row for age
              Row(
                children: [
                  //an icon to represent age
                  FaIcon(
                    Icons.cake,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(widget.voteUser.age.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(height: 1.5)),
                ],
              ),
              // a row for votes
              Row(
                children: [
                  //an icon to represent votes
                  FaIcon(
                    Icons.check_box,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(widget.voteUser.votes.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(height: 1.5)),
                ],
              ),
              //divider
              if (widget.user.id != widget.voteUser.id &&
                  widget.user.finishedOnboarding)
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
              if (widget.user.id != widget.voteUser.id &&
                  widget.user.finishedOnboarding)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.user.dailyDmsRemaining > 0) {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return DirectMessagePopup(
                                voteTarget: widget.voteUser,
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("You have no more DMs left for today!"),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      }, //This prop for beautiful expressions
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Message"),
                          SizedBox(
                            width: 10,
                          ),
                          FaIcon(
                            FontAwesomeIcons.paperPlane,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            size: 40,
                          ),
                        ],
                      ), // This child can be everything. I want to choose a beautiful Text Widget
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * .8,
                            100), //change size of this beautiful button
                        // We can change style of this beautiful elevated button thanks to style prop
                        primary: Theme.of(context).colorScheme.primary,
                        onPrimary: Colors.white, // change color of child prop
                        onSurface: Colors.blue, // surface color
                        shadowColor: Colors
                            .grey, //shadow prop is a very nice prop for every button or card widgets.
                        elevation:
                            5, // we can set elevation of this beautiful button
                        side: BorderSide(
                            color: Theme.of(context)
                                .primaryColor, //change border color
                            width: 2, //change border width
                            style: BorderStyle
                                .solid), // change border side of this beautiful button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), //change border radius of this beautiful button thanks to BorderRadius.circular function
                        ),
                        tapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ),
                  ),
                ),
              if (widget.user.id != widget.voteUser.id)
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
              if (userSocialsEmpty)
                SocialMediaGrid(
                  user: widget.voteUser,
                ),
              if (userSocialsEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1,
                  ),
                ),
              if (widget.voteUser.firstUndergrad != '' &&
                  widget.voteUser.firstUndergrad != 'None')
                buildUndergrads(),
              if (widget.voteUser.postGrad != '' &&
                  widget.voteUser.postGrad != 'None')
                Row(
                  children: [
                    FaIcon(
                      Icons.school,
                    ),
                    SizedBox(
                      width: 9,
                    ),
                    Text(widget.voteUser.postGrad,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(height: 1.5)),
                  ],
                ),
              if (widget.voteUser.firstStudentOrg != '' &&
                  widget.voteUser.firstStudentOrg != 'None')
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: (widget.voteUser.thirdStudentOrg == '')
                      ? (widget.voteUser.secondStudentOrg == '')
                          ? 1
                          : 2
                      : 3,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, studentOrgIndex) {
                    String _org = (studentOrgIndex == 0)
                        ? widget.voteUser.firstStudentOrg
                        : (studentOrgIndex == 1)
                            ? widget.voteUser.secondStudentOrg
                            : widget.voteUser.thirdStudentOrg;

                    String _orgPostision = (studentOrgIndex == 0)
                        ? widget.voteUser.firstStudentOrgPosition
                        : (studentOrgIndex == 1)
                            ? widget.voteUser.secondStudentOrgPosition
                            : widget.voteUser.thirdStudentOrgPosition;

                    String _display = _org + ' - ' + _orgPostision;

                    Widget _icon = Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                        child: Leadership.leadership.firstWhere(
                            (listLeader) => (studentOrgIndex == 0)
                                ? widget.voteUser.firstStudentOrgPosition ==
                                    listLeader['value']
                                : (studentOrgIndex == 1)
                                    ? widget.voteUser
                                            .secondStudentOrgPosition ==
                                        listLeader['value']
                                    : widget.voteUser.thirdStudentOrgPosition ==
                                        listLeader['value'], orElse: () {
                          return Nothing.nothing;
                        })['icon']);

                    return Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 2),
                      child: Row(
                        children: [
                          //an icon to represent votes
                          _icon,
                          SizedBox(
                            width: 9,
                          ),
                          Text(_display,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(height: 1.5)),
                        ],
                      ),
                    );
                  },
                ),
              if (widget.voteUser.firstStudentOrg != '' &&
                  widget.voteUser.firstStudentOrg != 'None')
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
              if (widget.voteUser.fraternity != '' &&
                  widget.voteUser.fraternity != 'None')
                Row(
                  children: [
                    //an icon to represent votes
                    Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                        child: Leadership.fratLeaders.firstWhere(
                            (listLeader) =>
                                widget.voteUser.fratPosition ==
                                listLeader['value'], orElse: () {
                          return Nothing.nothing;
                        })['icon']),
                    SizedBox(
                      width: 10,
                    ),
                    //text that says 'voteuser.fratposition of voteuser.fraternity'
                    Text(
                        widget.voteUser.fratPosition +
                            ' of ' +
                            widget.voteUser.fraternity,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(height: 1.5)),
                  ],
                ),
              //divider
              if (widget.voteUser.fraternity != '' &&
                  widget.voteUser.fraternity != 'None')
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
              if (widget.voteUser.favoriteBar != '' &&
                  widget.voteUser.favoriteBar != 'None')
                buildFavoriteBar(context),
              if (widget.voteUser.favoriteSpot != '' &&
                  widget.voteUser.favoriteSpot != 'None')
                buildSpot(context),

              if ((widget.voteUser.favoriteBar != '' &&
                      widget.voteUser.favoriteBar != 'None') &&
                  (widget.voteUser.favoriteSpot != '' &&
                      widget.voteUser.favoriteSpot != 'None'))
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),

              if (widget.voteUser.assosiatedDorm != '' &&
                  widget.voteUser.assosiatedDorm != 'None')
                buildAssociatedDorm(context),
              if (widget.voteUser.worstDorm != '' &&
                  widget.voteUser.worstDorm != 'None')
                buildWorstDorm(context),

              if ((widget.voteUser.favoriteBar != '' &&
                      widget.voteUser.favoriteBar != 'None') &&
                  (widget.voteUser.worstDorm != '' &&
                      widget.voteUser.worstDorm != 'None'))
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),

              if (widget.voteUser.intramuralSport != '' &&
                  widget.voteUser.intramuralSport != 'None')
                buildIntramurals(context),

              if (widget.voteUser.intramuralSport != '' &&
                  widget.voteUser.intramuralSport != 'None')
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),

              //a wrap to generate the list of waves as WaveTiles
            ],
          ),
        ),
        if (widget.waves.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "${widget.voteUser.name}'s top Waves",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
        if (widget.waves.isNotEmpty) SizedBox(height: 10),
        if (widget.waves.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.waves.length,
            itemBuilder: (BuildContext context, int index) {
              WaveTile waveTile = WaveTile(
                poster: widget.voteUser,
                wave: widget.waves[index]!,
              );
              return InkWell(
                child: waveTile,
                onTap: () {
                  Navigator.pushNamed(context, '/wave-replies',
                      arguments: [waveTile]);
                },
              );
            },
          ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AllWavesScreen.routeName,
                    arguments: widget.voteUser);
              }, //This prop for beautiful expressions
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    child: Text(
                      "${widget.voteUser.name}'s Waves",
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FaIcon(
                    FontAwesomeIcons.arrowUp,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 40,
                  ),
                ],
              ),

              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                minimumSize: Size(MediaQuery.of(context).size.width * .8,
                    100), //change size of this beautiful button
                // We can change style of this beautiful elevated button thanks to style prop
                primary: Theme.of(context).colorScheme.primary,
                onPrimary: Colors.white, // change color of child prop
                onSurface: Colors.blue, // surface color
                shadowColor: Colors
                    .grey, //shadow prop is a very nice prop for every button or card widgets.
                elevation: 5, // we can set elevation of this beautiful button
                side: BorderSide(
                    color: Theme.of(context).primaryColor, //change border color
                    width: 2, //change border width
                    style: BorderStyle
                        .solid), // change border side of this beautiful button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      30), //change border radius of this beautiful button thanks to BorderRadius.circular function
                ),
                tapTargetSize: MaterialTapTargetSize.padded,
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
      ],
    );
  }

  bool get userSocialsEmpty {
    return widget.voteUser.twitterUrl != '' ||
        widget.voteUser.instagramUrl != '' ||
        widget.voteUser.tinderUrl != '' ||
        widget.voteUser.tiktokUrl != '' ||
        widget.voteUser.discordUrl != '' ||
        widget.voteUser.snapchatUrl != '';
  }

  ListView buildUndergrads() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: (widget.voteUser.thirdUndergrad == '')
          ? (widget.voteUser.secondUndergrad == '')
              ? 1
              : 2
          : 3,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, undergradIndex) {
        String _undergradYear = (undergradIndex == 0)
            ? widget.voteUser.firstUndergrad
            : (undergradIndex == 1)
                ? widget.voteUser.secondUndergrad
                : widget.voteUser.thirdUndergrad;

        Widget _icon = Container(
            height: 24,
            width: 24,
            margin: EdgeInsets.only(top: 4, bottom: 4),
            child: FaIcon(ProfileData.getUndergrads().firstWhere(
                (listUndergrad) => (undergradIndex == 0)
                    ? widget.voteUser.firstUndergrad == listUndergrad['value']
                    : (undergradIndex == 1)
                        ? widget.voteUser.secondUndergrad ==
                            listUndergrad['value']
                        : widget.voteUser.thirdUndergrad ==
                            listUndergrad['value'], orElse: () {
              return Nothing.nothing;
            })['icon']));

        return Row(
          children: [
            _icon,
            SizedBox(
              width: 9,
            ),
            Text(_undergradYear,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(height: 1.5)),
          ],
        );
      },
    );
  }

  Row buildFavoriteBar(BuildContext context) {
    return Row(
      children: [
        //an icon to represent votes
        Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
            child: Bars.bars().firstWhere(
              (bar) => widget.voteUser.favoriteBar == bar['value'],
              orElse: () {
                return Nothing.nothing;
              },
            )['icon']),
        SizedBox(
          width: 10,
        ),
        //text that says 'Likes to go to voteuser.favoritebar on the weekends'
        Flexible(
          child: Text(
            'Likes to go to ' +
                widget.voteUser.favoriteBar +
                ' on the weekends',
            style: Theme.of(context).textTheme.headline5!.copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }

  Row buildSpot(BuildContext context) {
    return Row(
      children: [
        //an icon to represent votes
        Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
            child: Places.places().firstWhere(
              (spot) => widget.voteUser.favoriteSpot == spot['value'],
              orElse: () {
                return Places.places().firstWhere(
                  (spot) => 'None' == spot['value'],
                );
              },
            )['icon']),
        SizedBox(
          width: 10,
        ),
        //text that says 'Likes to go to voteuser.favoritebar on the weekends'
        Text(
          'Usually likes to go to ' + widget.voteUser.favoriteSpot,
          style: Theme.of(context).textTheme.headline5!.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Row buildWorstDorm(BuildContext context) {
    return Row(
      children: [
        //an icon to represent votes
        Container(
            height: 20,
            width: 20,
            //add a background color
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
            child: Dorms.dorms().firstWhere(
              (dorm) => widget.voteUser.worstDorm == dorm['value'],
              orElse: () {
                return Nothing.nothing;
              },
            )['icon']),
        SizedBox(
          width: 10,
        ),
        //text that says 'Likes to go to voteuser.favoritebar on the weekends'
        Text(
          'Thinks ' + widget.voteUser.worstDorm + ' is the smelliest dorm.',
          style: Theme.of(context).textTheme.headline5!.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Row buildAssociatedDorm(BuildContext context) {
    return Row(
      children: [
        //an icon to represent votes
        Container(
            height: 20,
            width: 20,
            //add a background color
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
            child: Dorms.dorms().firstWhere(
              (dorm) => widget.voteUser.assosiatedDorm == dorm['value'],
              orElse: () {
                return Nothing.nothing;
              },
            )['icon']),
        SizedBox(
          width: 10,
        ),
        //text that says 'Likes to go to voteuser.favoritebar on the weekends'
        Text(
          'Lived at ' + widget.voteUser.assosiatedDorm,
          style: Theme.of(context).textTheme.headline5!.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Row buildIntramurals(BuildContext context) {
    return Row(
      children: [
        //an icon to represent votes
        Container(
            height: 20,
            width: 20,
            //add a background color
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
            child: Intramurals.intramurals().firstWhere(
              (intramural) =>
                  widget.voteUser.intramuralSport == intramural['value'],
              orElse: () {
                return Nothing.nothing;
              },
            )['icon']),
        SizedBox(
          width: 10,
        ),
        //text that says 'Likes to go to voteuser.favoritebar on the weekends'
        Text(
          'In a ' + widget.voteUser.intramuralSport + ' intramural team',
          style: Theme.of(context).textTheme.headline5!.copyWith(height: 1.5),
        ),
      ],
    );
  }
}

class SocialMediaGrid extends StatefulWidget {
  final User user;
  const SocialMediaGrid({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<SocialMediaGrid> createState() => _SocialMediaGridState();
}

class _SocialMediaGridState extends State<SocialMediaGrid> {
  late List<Widget> _socialMediaIcons;

  initState() {
    _socialMediaIcons = [];
    if (widget.user.twitterUrl != '') {
      _socialMediaIcons.add(SocialMediaIconFromIcon(
        url: widget.user.twitterUrl,
        icon: FontAwesomeIcons.twitter,
        iconColor: Color(0xff1da1f2),
      ));
    }
    if (widget.user.instagramUrl != '') {
      _socialMediaIcons.add(SocialMediaIconFromIcon(
        url: widget.user.instagramUrl,
        icon: FontAwesomeIcons.instagram,
        //e1306c
        iconColor: Color(0xffe1306c),
      ));
    }
    if (widget.user.snapchatUrl != '') {
      _socialMediaIcons.add(SocialMediaIconFromIcon(
        url: widget.user.snapchatUrl,
        icon: FontAwesomeIcons.snapchat,
        //fffc00
        iconColor: Color(0xfffffc00),
      ));
    }
    if (widget.user.tiktokUrl != '') {
      _socialMediaIcons.add(SocialMediaIconFromIcon(
        url: widget.user.tiktokUrl,
        icon: FontAwesomeIcons.tiktok,
        //00bfff
        iconColor: Color(0xff00bfff),
      ));
    }
    if (widget.user.discordUrl != '') {
      _socialMediaIcons.add(SocialMediaIconFromIcon(
        url: widget.user.discordUrl,
        icon: FontAwesomeIcons.discord,
        //7289da
        iconColor: Color(0xff7289da),
      ));
    }
    if (widget.user.tinderUrl != '') {
      _socialMediaIcons.add(SocialMediaIconFromSvg(
        url: widget.user.tinderUrl,
        svgPath: "assets/social_media/tinder-icon.svg",
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: _socialMediaIcons.length,
      itemBuilder: (BuildContext context, int index) {
        return _socialMediaIcons[index];
      },
    );
  }
}

class SocialMediaIconFromIcon extends StatelessWidget {
  final String url;
  final IconData icon;
  final Color iconColor;
  const SocialMediaIconFromIcon({
    Key? key,
    required this.url,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: FaIcon(
            icon,
            size: 70,
            color: iconColor,
          ),
        ),
      ),
      onTap: () {
        launchUrlString(url);
      },
    );
  }
}

//write the staeless widget SocialMediaIconFromSvg
class SocialMediaIconFromSvg extends StatelessWidget {
  final String url;
  final String svgPath;
  const SocialMediaIconFromSvg({
    Key? key,
    required this.url,
    required this.svgPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: SvgPicture.asset(
          svgPath,
          width: 70,
          height: 70,
        )),
      ),
      onTap: () {
        launchUrlString(url);
      },
    );
  }
}

//write a test for this voteview
