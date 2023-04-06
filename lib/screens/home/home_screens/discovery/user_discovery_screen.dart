import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/wave/wave_bloc.dart';
import 'package:hero/widgets/discovery_user_card.dart';
import 'package:hero/widgets/top_appBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
//import math
import 'dart:math' as math;

import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../blocs/typesense/bloc/search_bloc.dart';
import '../../../../blocs/user discovery swiping/user_discovery_bloc.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/discovery_message_card.dart';
import '../../../../widgets/send_message_user_card.dart';
import '../../../../widgets/user_card.dart';
import '../../../../widgets/user_image_small.dart';
import '../../../onboarding/widgets/partially_filled_icon.dart';

class UserDiscoveryScreen extends StatefulWidget {
  const UserDiscoveryScreen({Key? key}) : super(key: key);

  @override
  State<UserDiscoveryScreen> createState() => _UserDiscoveryScreenState();
}

class _UserDiscoveryScreenState extends State<UserDiscoveryScreen>
    with TickerProviderStateMixin {
  late AnimationController _childAnimationController;
  late AnimationController _feedbackAnimationController;

  double likeOpacity = 0.0;
  double dislikeOpacity = 0.0;
  Offset _childOffset = Offset(0, 0);
  Offset _endpointOffset = Offset(0, 0);

  @override
  void initState() {
    _childAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    _feedbackAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    if (Provider.of<UserDiscoveryBloc>(context, listen: false).state
        is UserDiscoveryLoading) {
      Provider.of<ProfileBloc>(context, listen: false)
          .add(LoadDiscovery(context: context));
      print('loading discovery users');
    }

    super.initState();
  }

  @override
  void dispose() {
    _feedbackAnimationController.dispose();
    _childAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoading) {
          return CircularProgressIndicator();
        }
        if (profileState is ProfileLoaded) {
          User? user = profileState.user;
          if (user.finishedOnboarding) {
            return Scaffold(
              body: BlocBuilder<UserDiscoveryBloc, UserDiscoveryState>(
                builder: (context, state) {
                  if (state is UserDiscoveryLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is UserDiscoveryLoaded) {
                    return (state.users.isEmpty)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    "Either your daily discovery limit has been reached, or you've gone through all the users. Come back tomorrow for more!",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                //show the partially filled icon
                                PartiallyFilledIcon(
                                  icon: Icons.people,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 40,
                                  filledPercentage:
                                      (user.discoveriesRemaning / 15)
                                          .toDouble(),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .75,
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(
                                        children: [
                                          Draggable(
                                            child: Stack(
                                              children: [
                                                if (state.users.length > 1)
                                                  DiscoveryUserCard(
                                                    user: state.users[1],
                                                    imageUrlIndex: 0,
                                                  ),
                                                SlideTransition(
                                                  position: Tween<Offset>(
                                                          begin: _childOffset,
                                                          end: _endpointOffset)
                                                      .animate(CurvedAnimation(
                                                          parent:
                                                              _childAnimationController,
                                                          curve:
                                                              Curves.easeIn)),
                                                  child: DiscoveryUserCard(
                                                    user: state.users[0],
                                                    imageUrlIndex:
                                                        state.imageUrlIndex,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            feedback: Stack(
                                              children: [
                                                DiscoveryUserCard(
                                                  user: state.users[0],
                                                  imageUrlIndex:
                                                      state.imageUrlIndex,
                                                  votable: false,
                                                ),
                                                //a green check mark positioned on the top right corner
                                              ],
                                            ),
                                            childWhenDragging: (state
                                                        .users.length >
                                                    1)
                                                ? DiscoveryUserCard(
                                                    user: state.users[1],
                                                    imageUrlIndex: 0,
                                                  )
                                                : Center(
                                                    child:
                                                        Text("No users found"),
                                                  ),
                                            onDragEnd: (drag) {
                                              if (drag.offset.distance >
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .3
                                                  //and check if the drag is in the left direction
                                                  &&
                                                  drag.offset.dx < 0) {
                                                setState(() {
                                                  //set the child offset to be an offset with the offset of the drag and the width of the screen
                                                  _childOffset = Offset(-.8, 0);

                                                  //set an offset with offset.distance that is 1.5 times the width of the screen
                                                  _endpointOffset =
                                                      Offset(-1, 0);
                                                });
                                                _childAnimationController
                                                    .forward()
                                                    .then(
                                                        (value) => setState(() {
                                                              _childOffset =
                                                                  Offset(0, 0);
                                                              _endpointOffset =
                                                                  Offset(0, 0);
                                                            }))
                                                    .then((value) => context
                                                        .read<
                                                            UserDiscoveryBloc>()
                                                      ..add(
                                                          UserDiscoverySwipeLeft(
                                                        receiver:
                                                            state.users[0],
                                                        sender: user,
                                                      )))
                                                    .then((value) =>
                                                        _childAnimationController
                                                            .reset());
                                                print('UserDiscoveryd left');
                                              } else if (drag.offset.distance >
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .3 &&
                                                  drag.offset.dx > 0) {
                                                // context
                                                //     .read<UserDiscoveryBloc>()
                                                //   ..add(UserDiscoverySwipeRight(
                                                //     receiver: state.users[0],
                                                //     sender: user,
                                                //   ));
                                                print('swiped right');
                                                setState(() {
                                                  _childOffset = Offset(.8, 0);
                                                  _endpointOffset =
                                                      Offset(1, 0);
                                                });
                                                _childAnimationController
                                                    .forward()
                                                    .then((value) => setState(
                                                        () => _childOffset =
                                                            Offset(0, 0)));
                                                //make a timer that will wait for 1 second and then show the dialog
                                                Timer(
                                                    Duration(milliseconds: 260),
                                                    () {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return SendMessageDialog(
                                                          animationController:
                                                              _childAnimationController,
                                                          sender: user,
                                                          receiver:
                                                              state.users[0],
                                                        );
                                                      });
                                                });
                                              }
                                            },
                                          ),
                                          //set a positioned row on the bottom of buttons
                                          Positioned(
                                            bottom: 0,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  //a circular transparent conatiner with a red circular border and a red x icon
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      border: Border.all(
                                                          color: Colors.red,
                                                          width: 1),
                                                    ),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                        size: 40,
                                                      ),
                                                      onPressed: () {
                                                        // context.read<
                                                        //     UserDiscoveryBloc>()
                                                        //   ..add(
                                                        //       UserDiscoverySwipeLeft(
                                                        //     receiver: state
                                                        //         .users[0],
                                                        //     sender: user,
                                                        //   ));
                                                        setState(() {
                                                          _childOffset =
                                                              Offset.zero;
                                                          _endpointOffset =
                                                              Offset(-1, 0);
                                                        });
                                                        _childAnimationController
                                                            .forward()
                                                            .then((value) =>
                                                                setState(() {
                                                                  _childOffset =
                                                                      Offset(
                                                                          0, 0);
                                                                  _endpointOffset =
                                                                      Offset(
                                                                          0, 0);
                                                                }))
                                                            .then((value) => context
                                                                .read<
                                                                    UserDiscoveryBloc>()
                                                              ..add(
                                                                  UserDiscoverySwipeLeft(
                                                                receiver: state
                                                                    .users[0],
                                                                sender: user,
                                                              )))
                                                            .then((value) =>
                                                                _childAnimationController
                                                                    .reset());
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      border: Border.all(
                                                          color: Colors.purple,
                                                          width: 1),
                                                    ),
                                                    child: IconButton(
                                                      icon: PartiallyFilledIcon(
                                                        icon: Icons.people,
                                                        color: //primary color
                                                            Colors.purple,
                                                        size: 40,
                                                        filledPercentage:
                                                            (user.discoveriesRemaning /
                                                                    15)
                                                                .toDouble(),
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      border: Border.all(
                                                          color: Colors.green,
                                                          width: 1),
                                                    ),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                        size: 40,
                                                      ),
                                                      onPressed: () {
                                                        print('swiped right');
                                                        setState(() {
                                                          _childOffset =
                                                              Offset.zero;
                                                          _endpointOffset =
                                                              Offset(1, 0);
                                                        });
                                                        _childAnimationController
                                                            .forward()
                                                            .then((value) =>
                                                                null);
                                                        //make a timer that will wait for 1 second and then show the dialog
                                                        Timer(
                                                            Duration(
                                                                milliseconds:
                                                                    260), () {
                                                          showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return SendMessageDialog(
                                                                  sender: user,
                                                                  receiver: state
                                                                      .users[0],
                                                                  animationController:
                                                                      _childAnimationController,
                                                                );
                                                              });
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          );
                  } else if (state is UserDiscoveryError) {
                    return Center(
                      child: Text("No users found error"),
                    );
                  } else if (state is UserDiscoveryEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "Either your daily discovery limit has been reached, or you've gone through all the users. Come back tomorrow for more!",
                              style: Theme.of(context).textTheme.headline4),
                          //show the partially filled icon
                          PartiallyFilledIcon(
                            icon: Icons.people,
                            color: Theme.of(context).colorScheme.primary,
                            size: 40,
                            filledPercentage:
                                (user.discoveriesRemaning / 15).toDouble(),
                          ),
                        ],
                      ),
                    );
                  } else if (state is UserDiscoverySendMessageState) {
                    return DiscoveryMessageUserCard(
                        imageUrlIndex: 0, user: state.users[0]);
                  } else {
                    return Text('Somethings wrong, yo');
                  }
                },
              ),
            );
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Please setup your profile before you start Discovering.',
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.popAndPushNamed(
                        context, '/onboarding',
                        arguments: user),
                    child: Text('Create profile',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Theme.of(context).dividerColor)),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary,
                        textStyle: Theme.of(context).textTheme.headline5),
                  ),
                ],
              ),
            );
          }
        }

        return Text('Something went wrong');
      },
    );
  }
}

class SendMessageDialog extends StatefulWidget {
  final User sender;
  final User receiver;
  final AnimationController animationController;
  const SendMessageDialog({
    Key? key,
    required this.sender,
    required this.receiver,
    required this.animationController,
  }) : super(key: key);

  @override
  State<SendMessageDialog> createState() => _SendMessageDialogState();
}

class _SendMessageDialogState extends State<SendMessageDialog>
    with TickerProviderStateMixin {
  late AnimationController _dialogAnimationController;
  late AnimationController _textFieldAnimationController;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _dialogAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds:
              //half a second
              500),
    );
    _textFieldAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds:
              //half a second
              500),
    );

    Timer(Duration(milliseconds: 50), () {
      _dialogAnimationController.forward();
    });
    Timer(Duration(milliseconds: 550), () {
      _textFieldAnimationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _dialogAnimationController.dispose();
    _textFieldAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SlideTransition(
            position: _introTween().animate(_dialogAnimationController),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      SendMessageUserCard(
                        imageUrlIndex: 0,
                        user: widget.receiver,
                      ),
                      //align a red button to the top right of the container
                      Align(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            //pop the dialog box
                            Navigator.pop(context);
                            widget.animationController.reverse();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SlideTransition(
                    position: _textFieldTween()
                        .animate(_textFieldAnimationController),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100),
                            ],
                            textInputAction: TextInputAction.send,
                            textCapitalization: TextCapitalization.sentences,
                            controller: _controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Add an optinal note...?',
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                helperStyle: TextStyle(color: Colors.black),
                                contentPadding: EdgeInsets.all(5.0)),
                            onSubmitted: (text) {
                              setState(() {
                                _controller.text = text;
                              });
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            //white
                            //primary color
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(2),
                          child: IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.send),
                              onPressed: () {
                                Provider.of<UserDiscoveryBloc>(context,
                                        listen: false)
                                    .add(UserDiscoverySendMessage(
                                        message: _controller.text,
                                        sender: widget.sender,
                                        receiver: widget.receiver));
                                widget.animationController.reset();
                                Navigator.of(context).pop();
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//make a function that takes in a delay and return a Tween<Offset> that chains different tweens together
TweenSequence<Offset> _introTween() {
  return TweenSequence([
    TweenSequenceItem(
      tween: Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset(0, 0),
      ),
      weight: .6,
    ),
    TweenSequenceItem(
      tween: Tween<Offset>(
        begin: Offset(0, 0),
        end: Offset(0, -.1),
      ),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween<Offset>(
        begin: Offset(0, -.1),
        end: Offset(0, 0),
      ),
      weight: .6,
    ),
  ]);
}

TweenSequence<Offset> _textFieldTween() {
  return TweenSequence([
    TweenSequenceItem(
      tween: Tween<Offset>(
        begin: Offset(0, 6),
        end: Offset(0, 4),
      ),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween<Offset>(
        begin: Offset(0, 4),
        end: Offset(0, 4.7),
      ),
      weight: 1.5,
    ),
    TweenSequenceItem(
      tween: Tween<Offset>(
        begin: Offset(0, 4.7),
        end: Offset(0, 4.5),
      ),
      weight: 1,
    ),
  ]);
}
