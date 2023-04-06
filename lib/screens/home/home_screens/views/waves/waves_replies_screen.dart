import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/blocs/vote/vote_bloc.dart';
import 'package:hero/blocs/wave/wave_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/helpers/diceroll_avatars.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/focal_wave_tile.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/composeBottomIconWidget.dart';
import 'package:hero/widgets/top_appBar.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
//import timeago package
import 'package:timeago/timeago.dart' as timeago;
import 'package:typesense/typesense.dart';
import 'package:uuid/uuid.dart';

import '../../../../../blocs/profile/profile_bloc.dart';
import '../../../../../blocs/wave_liking/wave_liking_bloc.dart';
import '../../../../../blocs/wave_replies/wave_replies_bloc.dart';
import '../../../../../cubits/trolling-police/trolling_cubit.dart';
import '../../../../../models/models.dart';
import '../../../../../models/posts/wave_model.dart';
import '../../../../../repository/firestore_repository.dart';
import '../../../../../widgets/text_splitter.dart';
import '../../votes/leaderboard_screen.dart';
import 'get_replies_widget.dart';
import 'widget/video/wave_video_preview.dart';
import 'widget/wave_tile.dart';

class WaveRepliesScreen extends StatefulWidget {
  final List<WaveTile> waveTileList;
  final WaveTile waveTile;
  final bool isThread;

  const WaveRepliesScreen({
    Key? key,
    required this.waveTile,
    required this.waveTileList,
    this.isThread = false,
  }) : super(key: key);

  //make a static string routeName
  static const routeName = '/wave-replies';

  static Route route({required Map<String, dynamic> map}) {
    return MaterialPageRoute(
      builder: (_) => WaveRepliesScreen(
        waveTile: (map['waveTileList'] as List<WaveTile>).last,
        waveTileList: map['waveTileList'],
        isThread: map['isThread'],
      ),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  State<WaveRepliesScreen> createState() => _WaveRepliesScreenState();
}

class _WaveRepliesScreenState extends State<WaveRepliesScreen> {
  File? _image;
  void _onImageIconSelected(File file) {
    setState(() {
      _image = file;
    });
  }

  GlobalKey dataKey = GlobalKey();

  DocumentSnapshot? _lastDocument;

  int selectedIndex = 0;
  late ScrollController _scrollController;
  final TextEditingController _textEditingController = TextEditingController();
  bool isLoading = false;
  bool threadLoading = false;
  bool hasMore = true;
  List<Wave?> threads = [];
  List<Wave?> waves = [];
  List<Wave?> replyWaves = [];
  List<User?> users = [];
  bool isTyping = false;
  bool hasText = false;
  bool isSearching = false;
  bool atLeast2Seconds = false;
  Timer? initialTimer;
  //add a focus node
  final FocusNode _focusNode = FocusNode();

  late bool isYipYap;

  @override
  void initState() {
    isYipYap = (widget.waveTile.wave.type == Wave.yip_yap_type);
    //set timer so that after 5 seconds, atLeast2Seconds is true
    initialTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        atLeast2Seconds = true;
      });
    });

    if (widget.waveTile.wave.type != Wave.yip_yap_type) {
      users.add(
          (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user);
    } else {
      users.add(User.anon(
          (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded)
              .user
              .id!));
    }

    if (widget.isThread) {
      setState(() {
        threadLoading = true;
      });
      getThreadWaves().then((waveResults) {
        //remove any duplicate waveResults
        waveResults = waveResults.toSet().toList();

        setState(() {
          threads = waveResults;
          users.add(widget.waveTile.poster);
          threadLoading = false;
        });
        getReplies();
      });
    } else {
      getReplies();
    }

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Scrollable.ensureVisible(dataKey.currentContext!));

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * .7 &&
          !isLoading &&
          hasMore &&
          atLeast2Seconds) {
        setState(() {
          isLoading = true;
        });
        getWaves().then((waveResults) {
          getPosters(waveResults).then((userResults) => setState(() {
                users.addAll(userResults);
                waves.addAll(waveResults);
                isLoading = false;
              }));
        });

        print('reached the bottom');
      }
    });
    super.initState();
  }

  void getReplies() {
    if (threads.length < 3) {
      getWaves().then((waveResults) {
        getPosters(waveResults).then((userResults) {
          //remove any duplicate waveResults

          setState(() {
            users.addAll(userResults);
            //add all unique waves to waves
            waves.addAll(waveResults);
          });
          //for each wave in waveResults, get the replies
          for (Wave? wave in waveResults) {
            if (wave!.comments > 0) {
              getWaveReplies(wave).then((replyResults) {
                getPosters(replyResults).then((userResults) {
                  setState(() {
                    replyWaves.addAll(replyResults);
                    users.addAll(userResults);
                  });
                });
                //remove any duplicate replyResults
              });
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    initialTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User user = profileState.user;
          return Scaffold(
              appBar: TopAppBar(title: 'Waves'),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          //if the widget.waveTileList is greater than 1, return a ListView.builder with no scroll physics
                          if (widget.waveTileList.length > 1 && !isSearching)
                            previousWaves(context),

                          if (!isSearching)
                            FocalWaveTile(
                              key: dataKey,
                              wave: widget.waveTile.wave,
                              user: profileState.user,
                              poster: widget.waveTile.poster,
                            ),
                          if (widget.isThread && !isSearching)
                            (threadLoading)
                                ? Center(child: CircularProgressIndicator())
                                : threadBuilder(),

                          if (!isSearching) replies(),
                          if (isSearching) searching(),
                          if (isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .05,
                          )
                        ],
                      ),
                    ),
                    typingBar(user, context, widget.waveTile.wave)
                  ],
                ),
              ));
        }
        return Container();
      },
    );
  }

  Positioned typingBar(User user, BuildContext context, Wave wave) {
    return Positioned(
      child: (user.finishedOnboarding || wave.type == Wave.yip_yap_type)
          ? (!isTyping)
              ? buildNotTypingField(context, user)
              : buildTypingField(context, user)
          : buildNotOnboardedField(context, user),
      bottom: 0,
    );
  }

  Container buildNotOnboardedField(BuildContext context, User user) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).dividerColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //spaceBetween
        mainAxisSize: MainAxisSize.max,

        children: [
          Text('Please finish making your account',
              style: Theme.of(context).textTheme.headline6),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: () => Navigator.popAndPushNamed(context, '/onboarding',
                arguments: user),
            child: Text('Create profile',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Theme.of(context).dividerColor)),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary,
                textStyle: Theme.of(context).textTheme.headline5),
          ),
        ],
      ),
    );
  }

  Column buildTypingField(BuildContext context, User user) {
    return Column(
      children: [
        //add a container holds a row which shows the user image and then a column which holds the user name and the user handle in a subtite, then a button to send the wave aligned to the right
        Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          color: //divider color
              Theme.of(context).dividerColor,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: MediaQuery.of(context).size.width * .05,
                  backgroundImage:
                      (widget.waveTile.wave.type == Wave.yip_yap_type)
                          ? null
                          : CachedNetworkImageProvider(user.imageUrls[0]),
                  child: (widget.waveTile.wave.type == Wave.yip_yap_type)
                      ? SvgPicture.network(
                          DiceRollAvatars.getAvatarUrl(userId: user.id!))
                      : null,
                ),
              ),
              //a column which holds the user name and the user handle in a subtite
              if (widget.waveTile.wave.type == Wave.default_type)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text(user.handle,
                          style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                ),
              //align a button to the right
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        //add an oval container that holds a button which is inactive until the user types something
                        ElevatedButton(
                      //primary color
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary,
                        //make it bigger
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),

                      child: Text('Reply',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: (!hasText)
                                      ? null
                                      : Theme.of(context).dividerColor)),
                      onPressed: (!hasText)
                          ? null
                          : () {
                              List<dynamic>? _replyToHandles =
                                  widget.waveTile.wave.replyToHandles;
                              _replyToHandles!
                                  .add(widget.waveTile.poster.handle);

                              //remove any duplicates
                              _replyToHandles =
                                  _replyToHandles.toSet().toList();
                              final Wave wave = Wave.genericWave(
                                message: _textEditingController.text,
                                replyToHandles: _replyToHandles,
                                replyTo: widget.waveTile.wave.id,
                                senderId: user.id!,
                                type: (widget.waveTile.wave.type ==
                                        Wave.default_type)
                                    ? Wave.default_type
                                    : widget.waveTile.wave.type,
                              );
                              BlocProvider.of<WaveRepliesBloc>(context).add(
                                  CreateWaveReplies(
                                      wave: wave,
                                      sender: user,
                                      file: _image,
                                      receiver: widget.waveTile.poster));

                              _focusNode.unfocus();
                              setState(() {
                                _textEditingController.clear();
                                isTyping = false;
                                _image = null;

                                //append the wave to the end of the list of waves
                                waves.insert(0, wave);

                                //append the local user to the list of users
                                users.insert(0, user);
                              });
                            },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        //add text that say reply to poster handle
        if (widget.waveTile.wave.type == Wave.default_type)
          Container(
            width: MediaQuery.of(context).size.width,
            //divider color
            color: Theme.of(context).dividerColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Replying to ${widget.waveTile.poster.handle}',
                      style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            ),
          ),
        //if the image is not null, show it
        (_image != null)
            ? (_image!.path.endsWith('.mp4'))
                ? Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: WaveVideoPreview(
                      videoFile: _image!,
                    ),
                  )
                : Container(
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
                              _image!,
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
                                  setState(() {
                                    _image = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
            : Container(),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).dividerColor,
          child: Row(
            children: [
              //sizebox to add a padding
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  style: Theme.of(context).textTheme.headline4,
                  //fill the color with scaffold color

                  onChanged: (value) {
                    //if the value is not empty, set hasText to true
                    if (value.isNotEmpty) {
                      setState(() {
                        hasText = true;
                      });
                    } else {
                      setState(() {
                        hasText = false;
                      });
                    }

                    //if the most recently typed character is an @
                    textFieldSearching(value, context);
                  },

                  //allow the text to be multiline

                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  focusNode: _focusNode,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      //add padding
                      contentPadding: EdgeInsets.all(10),
                      filled: true,
                      //circular border
                      border: OutlineInputBorder(
                          //add some padding

                          //no border
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25)),
                      //light grey color
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: 'Reply to ${widget.waveTile.poster.handle}'),
                  onTap: () {
                    setState(() {
                      isTyping = true;
                    });
                  },
                ),
              ),
              //sized box
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        ComposeBottomIconWidget(
          onImageIconSelected: _onImageIconSelected,
          textEditingController: _textEditingController,
        ),
      ],
    );
  }

  Container buildNotTypingField(BuildContext context, User user) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      width: MediaQuery.of(context).size.width,
      color: //divider color
          Theme.of(context).dividerColor,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: MediaQuery.of(context).size.width * .05,
              backgroundImage: (widget.waveTile.wave.type == Wave.yip_yap_type)
                  ? null
                  : CachedNetworkImageProvider(user.imageUrls[0]),
              child: (widget.waveTile.wave.type == Wave.yip_yap_type)
                  ? SvgPicture.network(
                      DiceRollAvatars.getAvatarUrl(userId: user.id!))
                  : null,
            ),
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              //have a text style of headline 3
              style: Theme.of(context).textTheme.headline4,
              decoration: InputDecoration(
                  //have some padding
                  contentPadding: const EdgeInsets.all(8.0),
                  //fill color of scaffold background
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  filled: true,

                  //circule border
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  hintText: 'Wave your reply'),
              onTap: () {
                setState(() {
                  isTyping = true;
                  _focusNode.requestFocus();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  ListView threadBuilder() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: threads.length,
      itemBuilder: (BuildContext context, int index) {
        User _poster =
            users.firstWhere((user) => user!.id == threads[index]!.senderId)!;
        return InkWell(
          onTap: () {
            sendToWaveReplies(
                _poster, threads[index]!, widget.waveTileList, context);
          },
          child: WaveTile(
            poster: _poster,
            wave: threads[index]!,
            extendBelow: (index == threads.length - 1) ? false : true,
            showDivider: (index == threads.length - 1) ? true : false,
            onDeleted: () {
              BlocProvider.of<WaveBloc>(context)
                  .add(DeleteWave(wave: threads[index]!));

              setState(() {
                threads.removeAt(index);
              });

              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void sendToWaveReplies(User _poster, Wave _wave, List<WaveTile> _waveTiles,
      BuildContext context) {
    WaveTile waveTile = WaveTile(
      poster: _poster,
      wave: _wave,
    );
    List<WaveTile> _newWaveTiles = _waveTiles + [waveTile];
    User user =
        (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;
    BlocProvider.of<TrollingPoliceCubit>(context)
        .upDateTrolling(waveTile.wave.id, context, user);
    Navigator.of(context).pushNamed(
      WaveRepliesScreen.routeName,
      arguments: {
        'waveTileList': _newWaveTiles,
        'isThread': false,
      },
    );
  }

  BlocBuilder<SearchBloc, SearchState> searching() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, searchState) {
        if (searchState is QueryLoaded) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .68,
            width: MediaQuery.of(context).size.width,
            child: SearchingUsersView(
              state: searchState,
              callback: (int index) {
                //remove the textfield's text until the @
                _textEditingController.text = _textEditingController.text
                    .substring(0, _textEditingController.text.lastIndexOf('@'));
                //add the handle
                _textEditingController.text += searchState.users[index]!.handle;

                //set the textfield's focus to the end
                _textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _textEditingController.text.length));
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
    );
  }

  ListView replies() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: waves.length,
      itemBuilder: (BuildContext context, int index) {
        WaveTile? _replyTile;
        User? _replyPoster;
        Wave? _reply = replyWaves
            .firstWhereOrNull((reply) => reply!.replyTo == waves[index]!.id);
        if (_reply != null) {
          _replyPoster =
              users.firstWhereOrNull((user) => user!.id == _reply.senderId)!;
        }
        if (_reply != null) {
          _replyTile = WaveTile(
              wave: _reply,
              poster: _replyPoster!,
              extendBelow: _reply.comments > 0,
              onDeleted: () {
                BlocProvider.of<WaveBloc>(context)
                    .add(DeleteWave(wave: _reply));

                setState(() {
                  replyWaves.remove(_reply);
                });

                Navigator.pop(context);
              },
              showDivider: (_reply.comments > 0) ? false : true);
        }
        User? poster =
            //first where or null
            users.firstWhereOrNull(
                (element) => element!.id == waves[index]!.senderId);
        WaveTile? _waveTile = (poster == null)
            ? null
            : (_reply == null)
                ? WaveTile(
                    wave: waves[index]!,
                    poster: poster,
                    extendBelow: false,
                    onDeleted: () {
                      BlocProvider.of<WaveBloc>(context)
                          .add(DeleteWave(wave: waves[index]!));

                      setState(() {
                        waves.remove(waves[index]);
                      });

                      Navigator.pop(context);
                    },
                  )
                : WaveTile(
                    wave: waves[index]!,
                    poster: poster,
                    extendBelow: true,
                    showDivider: false,
                    onDeleted: () {
                      BlocProvider.of<WaveBloc>(context)
                          .add(DeleteWave(wave: waves[index]!));

                      setState(() {
                        waves.remove(waves[index]);
                      });

                      Navigator.pop(context);
                    },
                  );

        if ((_waveTile == null)) {
          return const SizedBox.shrink();
        } else {
          return (_reply == null)
              ? InkWell(
                  child: _waveTile,
                  onTap: () {
                    sendToWaveReplies(
                        poster!, waves[index]!, widget.waveTileList, context);
                  },
                )
              : Column(
                  children: [
                    InkWell(
                      child: _waveTile,
                      onTap: () {
                        sendToWaveReplies(poster!, waves[index]!,
                            widget.waveTileList, context);
                      },
                    ),
                    InkWell(
                      child: _replyTile!,
                      onTap: () {
                        sendToWaveReplies(_replyPoster!, _reply,
                            widget.waveTileList, context);
                      },
                    ),
                    if (_reply.comments > 0)
                      GetRepliesWidget(
                        waveTileList: widget.waveTileList,
                        waveTile: _replyTile,
                      ),
                  ],
                );
        }
      },
    );
  }

  MediaQuery previousWaves(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.waveTileList.length - 1,
        itemBuilder: (BuildContext context, int index) {
          return
              //return a WaveTile
              InkWell(
            child: WaveTile(
              wave: widget.waveTileList[index].wave,
              poster: widget.waveTileList[index].poster,
              showPopup: false,
            ),
            onTap: () {
              //Navigator.pop for as many times as the index
              for (int i = index; i < widget.waveTileList.length - 1; i++) {
                Navigator.pop(context);
              }
            },
          );
        },
      ),
    );
  }

  void textFieldSearching(String value, BuildContext context) {
    if (value.endsWith('@')) {
      setState(() {
        isSearching = true;
      });
      //if the last value is not typically a character used in a handle, set searching to false
    }

    if (value.endsWith(' ')) {
      if (isSearching) {
        setState(() {
          isSearching = false;
        });
      }
    }

    if (isSearching) {
      context.read<SearchBloc>().add(SearchUsers(
          limit: 4,
          query: value.substring(value.lastIndexOf('@') + 1),
          //get the user from blocprovider of profilebloc state as profile loaded
          searcher: (context.read<ProfileBloc>().state as ProfileLoaded).user));
    }
  }

  Future<List<User?>> getPosters(List<Wave?> waves) async {
    if (waves.every((wave) => wave!.type == Wave.yip_yap_type)) {
      //Make a list of users. for every wave, add a user of User.anon(wave.posterid)
      List<User> _anonUsers = waves.map((e) => User.anon(e!.senderId)).toList();
      return _anonUsers;
    } else {
      List<String> posterIds = waves.map((e) => e!.senderId).toList();
      final results =
          TypesenseRepository().getUsersFromWaves(posterIds: posterIds);

      return results;
    }
  }

  Future<List<Wave?>> getWaves() async {
    User user =
        (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;
    TypesenseRepository _typesenseRepository = TypesenseRepository();

    List<Wave> _ignoreWaves = [];

    for (int i = 0; i < waves.length; i++) {
      _ignoreWaves.add(waves[i]!);
    }

    for (int i = 0; i < threads.length; i++) {
      _ignoreWaves.add(threads[i]!);
    }

    List<Wave?> _waves = await _typesenseRepository.getWaveReplies(
        user, _ignoreWaves, widget.waveTile.wave);

    //set _lastDocument to the last document in the results

    if (_waves.length < 5) {
      setState(() {
        hasMore = false;
      });
    }

    return _waves;
  }

  Future<List<Wave?>> getWaveReplies(Wave _wave) async {
    User user =
        (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;
    TypesenseRepository _typesenseRepository = TypesenseRepository();

    List<Wave> _ignoreWaves = [];

    List<Wave?> _waves =
        await _typesenseRepository.getWaveReplySquared(user, _wave);

    return _waves;
  }

  Future<List<Wave?>> getThreadWaves() async {
    final QuerySnapshot results =
        await FirestoreRepository().getThreadWaves(widget.waveTile.wave);

    //set _lastDocument to the last document in the results

    List<Wave?> waves = Wave.waveListFromQuerySnapshot(results);

    //sort waves by date
    waves.sort((a, b) => a!.createdAt.compareTo(b!.createdAt));

    return waves;
  }
}
