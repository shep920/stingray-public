import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/helpers/pick_file.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../helpers/compress_to_shit.dart';
import '../../../../../../widgets/custom_widgets.dart';

class ComposeBottomIconWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(File) onImageIconSelected;
  final void Function()? onAddWave;
  final bool canAddFile;
  final bool threadable;
  const ComposeBottomIconWidget(
      {Key? key,
      required this.textEditingController,
      required this.onImageIconSelected,
      this.canAddFile = true,
      this.onAddWave,
      this.threadable = false})
      : super(key: key);

  @override
  _ComposeBottomIconWidgetState createState() =>
      _ComposeBottomIconWidgetState();
}

class _ComposeBottomIconWidgetState extends State<ComposeBottomIconWidget> {
  bool reachToWarning = false;
  bool reachToOver = false;
  bool uploading = false;
  late Color wordCountColor;
  String tweet = '';

  @override
  void initState() {
    wordCountColor = ExtraColors.highlightColor;
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
          wordCountColor = ExtraColors.highlightColor;
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
          color: Theme.of(context).dividerColor),
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () {
                (widget.canAddFile)
                    ? setImage(ImageSource.gallery, false)
                    : null;
              },
              icon: customIcon(context,
                  // icon: AppIcon.image,
                  icon: Icons.image,
                  size: 30,
                  isTwitterIcon: true,
                  iconColor: (widget.canAddFile)
                      ? Theme.of(context).colorScheme.primary
                      : null)),
          IconButton(
              onPressed: () {
                (widget.canAddFile)
                    ? setImage(ImageSource.gallery, true)
                    : null;
              },
              icon: customIcon(context,
                  // icon: AppIcon.image,
                  icon: Icons.video_library,
                  size: 30,
                  isTwitterIcon: true,
                  iconColor: (widget.canAddFile)
                      ? Theme.of(context).colorScheme.primary
                      : null)),
          if (widget.threadable)
            IconButton(
                onPressed: () {
                  tweet.isEmpty ? null : widget.onAddWave!();
                },
                icon: customIcon(context,
                    icon: Icons.add,
                    size: 30,
                    isTwitterIcon: true,
                    iconColor: //if the tweet is empty, then have it greyed out. else, primary color
                        tweet.isEmpty
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).colorScheme.primary)),
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

  Future<void> setImage(ImageSource source, bool isVideo) async {
    File? _file = await PickFile.setImage(
        source: ImageSource.gallery, context: context, isVideo: isVideo);

    if (mounted) {
      setState(() {
        widget.onImageIconSelected(_file!);
      });
    }
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
