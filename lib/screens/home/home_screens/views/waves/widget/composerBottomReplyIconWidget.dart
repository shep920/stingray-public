import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../helpers/compress_to_shit.dart';
import '../../../../../../widgets/custom_widgets.dart';

class ComposeBottomReplyIconWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(File) onImageIconSelected;
  const ComposeBottomReplyIconWidget(
      {Key? key,
      required this.textEditingController,
      required this.onImageIconSelected})
      : super(key: key);

  @override
  _ComposeBottomReplyIconWidgetState createState() =>
      _ComposeBottomReplyIconWidgetState();
}

class _ComposeBottomReplyIconWidgetState
    extends State<ComposeBottomReplyIconWidget> {
  bool reachToWarning = false;
  bool reachToOver = false;
  bool uploading = false;
  late Color wordCountColor;
  String tweet = '';

  @override
  void initState() {
    wordCountColor = Colors.blue;
    widget.textEditingController.addListener(updateUI);
    super.initState();
  }

  void updateUI() {
    setState(() {
      tweet = widget.textEditingController.text;
      if (widget.textEditingController.text.isNotEmpty) {
        if (widget.textEditingController.text.length > 259 &&
            widget.textEditingController.text.length < 280) {
          wordCountColor = Colors.orange;
        } else if (widget.textEditingController.text.length >= 280) {
          wordCountColor = Theme.of(context).errorColor;
        } else {
          wordCountColor = Colors.blue;
        }
      }
    });
  }

  Widget _bottomIconWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor)),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () {
                setImage(ImageSource.gallery);
              },
              icon: customIcon(context,
                  // icon: AppIcon.image,
                  icon: Icons.image,
                  size: 30,
                  isTwitterIcon: true,
                  iconColor: //primary color
                      Theme.of(context).colorScheme.primary)),
          Expanded(
              child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: /*tweet != null &&*/ tweet.length > 289
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: customText('${280 - tweet.length}',
                            style:
                                TextStyle(color: Theme.of(context).errorColor)),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            value: getTweetLimit(),
                            backgroundColor: //scaffold background color
                                Theme.of(context).scaffoldBackgroundColor,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(wordCountColor),
                          ),
                          tweet.length > 259
                              ? customText('${280 - tweet.length}',
                                  style: TextStyle(color: wordCountColor))
                              : customText('',
                                  style: TextStyle(color: wordCountColor))
                        ],
                      )),
          ))
        ],
      ),
    );
  }

  Future<void> setImage(ImageSource source) async {
    ImagePicker _picker = ImagePicker();
    final XFile? _image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No image was selected.')));
    }

    if (_image != null) {
      File? compressedFile =
          await CompressToShit.compressToShit(File(_image.path));
      if (compressedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your image exceeded the 1mb limit.')));
      } else {
        setState(() {
          widget.onImageIconSelected(File(compressedFile.path));
        });
      }
    }

    // ImagePicker()
    //     .pickImage(source: source, imageQuality: 20)
    //     .then((XFile? file) {
    //   setState(() {
    //     // _image = file;
    //     widget.onImageIconSelected(File(file!.path));
    //   });
    // }).onError((error, stackTrace) => print(error));
  }

  double getTweetLimit() {
    if (/*tweet == null || */ tweet.isEmpty) {
      return 0.0;
    }
    if (tweet.length > 280) {
      return 1.0;
    }
    var length = tweet.length;
    var val = length * 100 / 28000.0;
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _bottomIconWidget(),
    );
  }
}
