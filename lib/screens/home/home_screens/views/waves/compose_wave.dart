import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/wave/wave_bloc.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/composeBottomIconWidget.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/wave_video_preview.dart';
import 'package:hero/widgets/top_appBar.dart';

import '../../../../../blocs/profile/profile_bloc.dart';
import '../../../../../blocs/typesense/bloc/search_bloc.dart';
import '../../../../../models/user_model.dart';
import '../../../../../models/posts/wave_model.dart';
import '../../../../../widgets/dismiss_keyboard.dart';
import '../../votes/leaderboard_screen.dart';

class ComposeWaveScreen extends StatefulWidget {
  final String waveType;
  ComposeWaveScreen({Key? key, required this.waveType}) : super(key: key);

  //add the route name here
  static const routeName = '/compose-wave';
  static Route route({required String waveType}) {
    return MaterialPageRoute(
      builder: (_) => ComposeWaveScreen(
        waveType: waveType,
      ),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  @override
  State<ComposeWaveScreen> createState() => _ComposeWaveScreenState();
}

class _ComposeWaveScreenState extends State<ComposeWaveScreen> {
  bool isSearching = false;
  late bool visible;
  int editingIndex = 0;
  bool isValid = false;
  late String _avatarUri;
  List<FocusNode> focusNodes = [FocusNode()];
  List<TextEditingController> textEditingControllers = [
    TextEditingController()
  ];
  List<File?> images = [null];

  late Widget _avatarImage;

  List<String> waves = [''];
  void _onImageIconSelected(File file) {
    setState(() {
      images[editingIndex] = file;
    });
  }

  void _addWaveToThread() {
    if (editingIndex > 9) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You can only add 10 waves to a thread'),
        duration: Duration(seconds: 2),
      ));
    } else {
      setState(() {
        waves.add('');
        images.add(null);

        textEditingControllers.add(TextEditingController());
        focusNodes.add(FocusNode());
        focusNodes[editingIndex].unfocus();
        focusNodes.last.requestFocus();
        editingIndex = waves.length - 1;
      });
    }
  }

  void _changeEditingIndex(int index) {
    setState(() {
      editingIndex = index;
      //set the focus to the chosen index
      FocusScope.of(context).requestFocus(focusNodes[editingIndex]);
    });
  }

  @override
  void initState() {
    User _user =
        (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;
    Avatar _avatar = DiceBearBuilder(
      size: 40,
      sprite: DiceBearSprite.bottts,
      seed: _user.id!,
    ).build();

    _avatarImage = _avatar.toImage(width: 40, height: 40);
    setState(() {
      visible = false;
    });

    //wait for the user to type something before showing the search results
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        visible = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in textEditingControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }

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
              appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  title: SizedBox(
                    //width of screen
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                  BlocProvider.of<WaveBloc>(context).add(
                                      CreateWaveThread(
                                          sender: user,
                                          messages: textEditingControllers
                                              .map((e) => e.text)
                                              .toList(),
                                          files: images,
                                          waveType: widget.waveType));
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Send',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      //copy with color
                                      !
                                      .copyWith(
                                          color: (isValid)
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context).primaryColor),
                                ),
                              ))
                        ]),
                  )),
              body: Column(
                children: [
                  if (widget.waveType == Wave.yip_yap_type)
                    AnimatedOpacity(
                      opacity: (visible) ? .75 : 0,
                      duration: Duration(milliseconds: 500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'This wave will be sent secretly',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Flexible(
                            child: IconButton(
                              onPressed: () {
                                explainYipYap(context).show();
                              },
                              icon: Icon(Icons.help),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: waves.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: currentlyEditingWave(
                                user,
                                context,
                                waves[index],
                                focusNodes[index],
                                textEditingControllers[index],
                                images[index],
                                index,
                              ),
                              onTap: () {
                                setState(() {
                                  editingIndex = index;
                                  focusNodes[editingIndex].requestFocus();
                                });
                              },
                            );
                          },
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
                                      textEditingControllers[editingIndex]
                                              .text =
                                          textEditingControllers[editingIndex]
                                              .text
                                              .substring(
                                                  0,
                                                  textEditingControllers[
                                                          editingIndex]
                                                      .text
                                                      .lastIndexOf('@'));
                                      //add the handle
                                      textEditingControllers[editingIndex]
                                              .text +=
                                          searchState.users[index]!.handle;

                                      //set the textfield's focus to the end
                                      textEditingControllers[editingIndex]
                                              .selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset:
                                                      textEditingControllers[
                                                              editingIndex]
                                                          .text
                                                          .length));
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
                    textEditingController: textEditingControllers[0],
                    onAddWave: _addWaveToThread,
                    threadable: (widget.waveType == Wave.default_type),
                    canAddFile: (images[editingIndex] == null),
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

  static AwesomeDialog explainYipYap(BuildContext context) {
    return AwesomeDialog(
      titleTextStyle: Theme.of(context).textTheme.headline2,
      descTextStyle: Theme.of(context).textTheme.headline5,
      context: context,
      dialogType: DialogType.info,
      borderSide: const BorderSide(
        color: Colors.green,
        width: 2,
      ),
      width: 680,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Yaps',
      desc:
          'Yaps show up in the Yip Yap tab. They will not have any information about who sent them besides the randomly assigned avatar.',
      showCloseIcon: true,
      btnOkOnPress: () {},
    );
  }

  IntrinsicHeight currentlyEditingWave(
      User user,
      BuildContext context,
      String message,
      FocusNode _focusNode,
      TextEditingController _textEditingController,
      File? _image,
      int index) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (index > 0)
                    SizedBox(
                      height: 10,
                      child: VerticalDivider(
                        color: Color.fromARGB(255, 207, 207, 207),
                        thickness: 2,
                        width: 10,
                      ),
                    ),
                  //make a widget that looks like twitter composing tweet
                  (widget.waveType == Wave.default_type)
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              CachedNetworkImageProvider(user.imageUrls[0]))
                      : _avatarImage,

                  if (index < waves.length - 1)
                    Expanded(
                      child: VerticalDivider(
                        color: Color.fromARGB(255, 207, 207, 207),
                        thickness: 2,
                        width: 10,
                      ),
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
                              //if the last value is not typically a character used in a handle, set searching to false
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
                            if (value != '') {
                              setState(() {
                                isValid = true;
                              });
                            }
                            if (value == '') {
                              setState(() {
                                isValid = false;
                              });
                            }
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
                      if (index > 0)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              waves.removeAt(index);
                              textEditingControllers.removeAt(index);
                              focusNodes.removeAt(index);
                            });
                          },
                        ),
                    ],
                  ),
                  if (_image != null)

                    //if the file is not .mp4
                    (_image.path.endsWith('mp4'))
                        ? Stack(
                            children: [
                              WaveVideoPreview(
                                videoFile: _image,
                              ),
                              
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      images[index] = null;
                                    });
                                  },
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                            color:
                                                Theme.of(context).dividerColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.close,
                                              color: Colors.red),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            images[index] = null;
                                          });
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
