import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hero/blocs/wave/wave_bloc.dart';
import 'package:hero/blocs/wave_replies/wave_replies_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/helpers/diceroll_avatars.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/composeBottomIconWidget.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/widgets/top_appBar.dart';

import '../../../../../blocs/profile/profile_bloc.dart';
import '../../../../../blocs/typesense/bloc/search_bloc.dart';
import '../../../../../models/user_model.dart';
import '../../../../../models/posts/wave_model.dart';
import '../../../../../widgets/dismiss_keyboard.dart';
import '../../votes/leaderboard_screen.dart';

class ComposeWaveReplyScreen extends StatefulWidget {
  final User originalPoster;
  final Wave wave;
  ComposeWaveReplyScreen(
      {Key? key, required this.wave, required this.originalPoster})
      : super(key: key);

  //add the route name here
  static const routeName = '/compose-wave-reply';
  static Route route({required Map<String, dynamic> map}) {
    return MaterialPageRoute(
      builder: (_) => ComposeWaveReplyScreen(
        originalPoster: map['originalPoster'],
        wave: map['wave'],
      ),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  State<ComposeWaveReplyScreen> createState() => _ComposeWaveScreenState();
}

class _ComposeWaveScreenState extends State<ComposeWaveReplyScreen> {
  bool isSearching = false;
  int editingIndex = 0;
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  File? image;
  String message = '';

  void _onImageIconSelected(File file) {
    setState(() {
      image = file;
    });
  }

  void _nullifyImage() {
    setState(() {
      image = null;
    });
  }

  initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    textEditingController.dispose();

    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return //profile bloc builder here
        BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User user = profileState.user;
          return DismissKeyboard(
            child: Scaffold(
              appBar: buildAppBar(context, user),
              body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        WaveTile(
                          wave: widget.wave,
                          poster: widget.originalPoster,
                          extendBelow: true,
                          showButtons: false,
                          showDivider: false,
                        ),
                        currentlyEditingWave(
                          user,
                          context,
                          focusNode,
                          textEditingController,
                          image,
                          _nullifyImage,
                        ),

                        if (isSearching)
                          BlocBuilder<SearchBloc, SearchState>(
                            builder: (context, searchState) {
                              if (searchState is QueryLoaded) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .68,
                                  width: MediaQuery.of(context).size.width,
                                  child: SearchingUsersView(
                                    state: searchState,
                                    callback: (int index) {
                                      //remove the textfield's text until the @
                                      textEditingController.text =
                                          textEditingController.text.substring(
                                              0,
                                              textEditingController.text
                                                  .lastIndexOf('@'));
                                      //add the handle
                                      textEditingController.text +=
                                          searchState.users[index]!.handle;

                                      //set the textfield's focus to the end
                                      textEditingController.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: textEditingController
                                                      .text.length));
                                      //set searching to false
                                      setState(() {
                                        isSearching = false;
                                      });
                                    },
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),

                        //make a widget that looks like twitter composing tweet
                      ],
                    ),
                  ),
                  ComposeBottomIconWidget(
                    onImageIconSelected: _onImageIconSelected,
                    textEditingController: textEditingController,
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context, User user) {
    return AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: SizedBox(
          //width of screen
          width: MediaQuery.of(context).size.width,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //align text that looks like twitter to the left that says cancel
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
            //align text that looks to the right that says tweet
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      if (message != '' || image != null) {
                        Wave _wave = Wave.genericWave(
                          message: message,
                          senderId: user.id!,
                          replyTo: widget.wave.id,
                          type: (widget.wave.type == Wave.default_type)
                              ? Wave.default_type
                              : widget.wave.type,
                        );

                        BlocProvider.of<WaveRepliesBloc>(context).add(
                            CreateWaveReplies(
                                wave: _wave,
                                sender: user,
                                receiver: widget.originalPoster,
                                file: image));

                        Navigator.of(context).pop();
                        //snackbar that says Waved back!
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'Waved back!',
                        )));
                      }
                    },
                    child: Container(
                      //make the container a color filled circle of Extra
                      child: Text(
                        'Send',
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            //copy with color
                            !
                            .copyWith(
                                color: (message != '' || image != null)
                                    ? ExtraColors.highlightColor
                                    : Theme.of(context).colorScheme.primary),
                      ),
                    )))
          ]),
        ));
  }

  IntrinsicHeight currentlyEditingWave(
    User user,
    BuildContext context,
    FocusNode _focusNode,
    TextEditingController _textEditingController,
    File? _image,
    void Function() nullifyImage,
  ) {
    return IntrinsicHeight(
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.wave.style != Wave.bubbleStyle)
                    SizedBox(
                      height: 10,
                      child: VerticalDivider(
                        color: Theme.of(context).backgroundColor,
                        thickness: 2,
                        width: 10,
                      ),
                    ),
                  //make a widget that looks like twitter composing tweet
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: (widget.wave.type == Wave.default_type)
                        ? CachedNetworkImageProvider(user.imageUrls[0])
                        : null,
                    backgroundColor: Colors.transparent,
                    child: (widget.wave.type == Wave.yip_yap_type)
                        ? SvgPicture.network(
                            DiceRollAvatars.getAvatarUrl(userId: user.id!))
                        : null,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          onChanged: (value) {
                            if (value.endsWith('@')) {
                              setState(() {
                                isSearching = true;
                              });
                            }

                            if (value.endsWith(' ')) {
                              if (isSearching) {
                                setState(() {
                                  isSearching = false;
                                });
                              }
                            }

                            //check if the backspace is pressed

                            if (isSearching) {
                              context.read<SearchBloc>().add(SearchUsers(
                                  limit: 4,
                                  query: value
                                      .substring(value.lastIndexOf('@') + 1),
                                  //get the user from blocprovider of profilebloc state as profile loaded
                                  searcher: (context.read<ProfileBloc>().state
                                          as ProfileLoaded)
                                      .user));
                            }
                            setState(() {
                              message = value;
                            });
                          },
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 280,
                          controller: _textEditingController,
                          style: Theme.of(context).textTheme.headline5,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'What\'s happening?',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      //icon button of x
                    ],
                  ),
                  if (_image != null)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      //divider color
                      color: Theme.of(context).dividerColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            //a stack which holds the image and a button to remove the image
                            Container(
                          height: 150,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              //show the image
                              Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                //position it in the middle of the image
                                top: 0,
                                left: 0,
                                child: IconButton(
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      //divider color
                                      color: Theme.of(context).dividerColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close, color: Colors.red),
                                  ),
                                  onPressed: () {
                                    nullifyImage();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
