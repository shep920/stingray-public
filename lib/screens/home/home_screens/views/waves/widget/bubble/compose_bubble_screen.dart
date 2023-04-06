import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/blocs/wave/wave_bloc.dart';
import 'package:hero/blocs/wave_replies/wave_replies_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/helpers/diceroll_avatars.dart';
import 'package:hero/helpers/pick_file.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/composeBottomIconWidget.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/screens/home/home_screens/votes/leaderboard_screen.dart';
import 'package:hero/widgets/dismiss_keyboard.dart';
import 'package:hero/widgets/top_appBar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ComposeBubbleScreen extends StatefulWidget {
  final File firstImage;
  ComposeBubbleScreen({Key? key, required this.firstImage}) : super(key: key);

  //add the route name here
  static const routeName = '/compose-bubble';
  static Route route({required File firstImage}) {
    return MaterialPageRoute(
      builder: (_) => ComposeBubbleScreen(
        firstImage: firstImage,
      ),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  State<ComposeBubbleScreen> createState() => _ComposeBubbleScreenState();
}

class _ComposeBubbleScreenState extends State<ComposeBubbleScreen> {
  bool isSearching = false;
  int editingIndex = 0;
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  List<File> images = [];
  String message = '';

  void _removeImage(File image) {
    setState(() {
      images.remove(image);
    });
  }

  initState() {
    super.initState();
    focusNode.requestFocus();
    images.add(widget.firstImage);
  }

  @override
  void dispose() {
    textEditingController.dispose();

    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
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
                        currentlyEditingWave(
                          user,
                          context,
                          focusNode,
                          textEditingController,
                          images,
                        ),
                        //an icon button that ssays add new photo
                        if (images.length < 9)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: [
                                //test saying add new photo

                                Text(
                                  'Add another photo?',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      File? _image = await PickFile.setImage(
                                          source: ImageSource.gallery,
                                          context: context);

                                      CroppedFile? _croppedFile =
                                          await ImageCropper().cropImage(
                                        sourcePath: _image!.path,
                                        aspectRatio: CropAspectRatio(
                                          ratioX: 1,
                                          ratioY: 1,
                                        ),
                                        maxWidth: 1080,
                                        maxHeight: 1080,
                                      );

                                      if (_croppedFile != null) {
                                        setState(() {
                                          images.add(File(_croppedFile.path));
                                        });
                                      } else {
                                        //snackbar saying no image selected

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('No image selected'),
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.add_a_photo, size: 40)),
                              ],
                            ),
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
                      if (message != '') {
                        Navigator.of(context).pop();

                        BlocProvider.of<WaveBloc>(context).add(
                          CreateWave(
                            sender: user,
                            message: message,
                            file: null,
                            style: Wave.bubbleStyle,
                            bubbleImages: images,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'Bubble Posted!',
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
                                color: (message != '')
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
    List<File> images,
  ) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(user.imageUrls[0]),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
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
                                query:
                                    value.substring(value.lastIndexOf('@') + 1),
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
                          hintText: 'Add a caption...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        for (int i = 0; i < images.length; i++)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                //increment the editing index. if it is greater than the length of the images, set it to 0
                                editingIndex =
                                    editingIndex + 1 > images.length - 1
                                        ? 0
                                        : editingIndex + 1;
                              });
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Image.file(
                                      images[editingIndex],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                //if images>1, show the next image peeking out
                                if (images.length > 1)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: ClipRRect(
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Image.file(
                                          images[
                                              (editingIndex < images.length - 1)
                                                  ? editingIndex + 1
                                                  : 0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        if (images.length > 1)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  images.removeAt(editingIndex);
                                  editingIndex = 0;
                                });
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.xmark,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    )
                    //icon button of x
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
