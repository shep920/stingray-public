import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/views/make_story/camera_page.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_editor_plus/image_editor_plus.dart' as img;
import 'package:path_provider/path_provider.dart';

class NewStoryScreen extends StatefulWidget {
  //add a route and route method

  static const String routeName = '/newStory';

  //make a route method
  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => NewStoryScreen(),
    );
  }

  const NewStoryScreen({Key? key}) : super(key: key);

  @override
  State<NewStoryScreen> createState() => _NewStoryScreenState();
}

class _NewStoryScreenState extends State<NewStoryScreen> {
  File? _file;
  List<TextWidgetData> _textWidgets = [];
  int _activeTextIndex = 0;

  final TextEditingController _controller =
      TextEditingController(text: " bruh");

  //define a method that will take a photo and save it to a file
  void _takePhoto(File _newFile) async {
    //take a photo and save it to a file

    //set the file to the file that was taken
    setState(() {
      _file = _newFile;
    });
  }

  void _createOverlayEntry() {
    OverlayEntry _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              left: 0.0,
              right: 0.0,
              child: Container(
                height: MediaQuery.of(context).size.height * .1,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.5),
              ),
            ));
    Overlay.of(context).insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return
        //make a widget that will return a view similar to taking a photo in snapchat
        Scaffold(
      body: (_file == null)
          ? CameraScreen(
              onCameraSwitchPressed: _takePhoto,
            )
          : Stack(
              children: [
                //show the image full screen

                GestureDetector(
                  child: Container(
                    //show the _file image full screen

                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      _file!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () async {
                    var editedImage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => img.ImageEditor(
                          image: _file!.readAsBytesSync(),
                        ),
                      ),
                    );

                    Uint8List? result = await editedImage;

                    final tempDir = await getTemporaryDirectory();
                    final path = tempDir.path;

                    //save result to path
                    File('$path/image.jpg').writeAsBytesSync(result!);

                    //get it
                    File? esult = File('$path/image.jpg');

                    //change result to a file

                    // replace with edited image
                    if (esult != null) {
                      setState(() {
                        _file = esult;
                      });
                    }
                  },
                ),

                Positioned(
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _file = null;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 70,
                      )),
                  top: 50,
                  left: 10,
                ),

                Positioned(
                  child: ElevatedButton(
                    onPressed: () {
                      User _user = (BlocProvider.of<ProfileBloc>(context).state
                              as ProfileLoaded)
                          .user;
                      BlocProvider.of<StingrayBloc>(context).add(
                          UploadStory(file: _file!, stingrayId: _user.id!));
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          "Story",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  bottom: 10,
                  right: 10,
                )

                //make a bottom row that has a gallery button and a camera button that looks like snapchat
              ],
            ),
    );
  }

  Future addText() async {
    const int size = 120;
    final ImageEditorOption option = ImageEditorOption();
    final AddTextOption textOption = AddTextOption();
    textOption.addText(
      EditorText(
        offset: const Offset(0, 0),
        text: _controller.text,
        fontSizePx: size,
        textColor: const Color(0xFF995555),
        fontName: 'Roboto',
      ),
    );
    option.outputFormat = const OutputFormat.jpeg(100);

    option.addOption(textOption);

    //add the text to _file
    final Uint8List? result = await ImageEditor.editImage(
      image: _file!.readAsBytesSync(),
      imageEditorOption: option,
    );

    //save the file
    setState(() {
      _file = File.fromRawPath(result!);
    });
  }
}

class TextWidgetData {
  double position = 0;
  bool visible = true;
  String text = '';
}
