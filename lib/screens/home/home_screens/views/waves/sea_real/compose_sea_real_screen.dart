import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/sea_real/sea_real_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/helpers/get.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/views/make_story/camera_page.dart';
import 'package:hero/screens/home/home_screens/views/waves/sea_real/sea_real_camera_page.dart';
import 'package:hero/screens/home/home_screens/views/waves/sea_real/sea_real_countdown.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_editor_plus/image_editor_plus.dart' as img;
import 'package:path_provider/path_provider.dart';

class ComposeSeaRealScreen extends StatefulWidget {
  //add a route and route method

  static const String routeName = '/composeSeaReal';

  //make a route method
  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => ComposeSeaRealScreen(),
    );
  }

  const ComposeSeaRealScreen({Key? key}) : super(key: key);

  @override
  State<ComposeSeaRealScreen> createState() => _NewStoryScreenState();
}

class _NewStoryScreenState extends State<ComposeSeaRealScreen> {
  File? _frontImage;
  File? _backImage;

  bool loadingFront = false;
  bool loadingBack = false;
  bool retaken = false;

  void _takePhoto(File _newfrontFile) async {
    setState(() {
      _frontImage = _newfrontFile;
      loadingFront = false;
    });
  }

  void _takeSecondPhoto(File _newbackFile) async {
    setState(() {
      _backImage = _newbackFile;
    });
  }

  void _setLoadingFront(bool _loadingFront) {
    setState(() {
      loadingFront = _loadingFront;
    });
  }

  void _setLoadingBack(bool _loadingBack) {
    setState(() {
      loadingBack = _loadingBack;
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
        SafeArea(
      child: Scaffold(
          body: (_frontImage == null)
              ? SeaRealCameraScreen(
                  takeFirstImage: _takePhoto,
                  getSecondImage: _takeSecondPhoto,
                  setLoadingFront: _setLoadingFront,
                  setLoadingBack: _setLoadingBack,
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SeaRealCountDown(),
                          Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .8,
                                child: AspectRatio(
                                  aspectRatio: //make it a square
                                      1 / 1,
                                  child: Container(
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          _frontImage!,
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                                ),
                              ),
                              if (loadingBack)
                                //return text that says' stay still...' and a circular progress indicator
                                Align(
                                  //center
                                  alignment: Alignment.bottomCenter,

                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Stay still...',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        CircularProgressIndicator()
                                      ]),
                                ),
                              if (_backImage != null)
                                Positioned(
                                  top: 30,
                                  left: 30,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        File _temp = _frontImage!;
                                        _frontImage = _backImage;
                                        _backImage = _temp;
                                      });
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .35,
                                        margin: EdgeInsets.all(20),
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.black),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.file(
                                            _backImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (loadingFront)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (!loadingBack && _backImage != null)
                      //align in the upper right corner an icon that will allow the user to retake the photo. Make the icon a white x with a gray circle around it with opacity .5
                      Positioned(
                        top: MediaQuery.of(context).size.height * .15,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _frontImage = null;
                              _backImage = null;
                              retaken = true;
                            });
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.5),
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    if (!loadingBack && _backImage != null)
                      _sendButton(context),
                  ],
                )),
    );
  }

  Positioned _sendButton(BuildContext context) {
    return Positioned(
      bottom: //bottom padding
          MediaQuery.of(context).size.height * .05,
      //center it

      child: ElevatedButton(
        onPressed: () {
          User _user = Get.blocUser(context);
          BlocProvider.of<SeaRealBloc>(context).add(CreateSeaReal(
              sender: _user,
              frontImage: _frontImage!,
              retaken: retaken,
              backImage: _backImage!));

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('SeaReal sent, vote added!'),
            duration: Duration(seconds: 2),
          ));

          if (!_user.sentFirstSeaReal) {
            AwesomeDialog(
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
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
              headerAnimationLoop: false,
              animType: AnimType.bottomSlide,
              title: "Discovery Unlocked!",
              desc:
                  "Congrats on the first SeaReal! Now you can meet some new people!",
              showCloseIcon: false,
              btnOkOnPress: () {
                Navigator.pushReplacementNamed(context, MainPage.routeName);
              },
            ).show();
          } else {
            Navigator.pop(context);
          }
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Send",
                style: TextStyle(
                    color: Colors.white, fontSize: 55, fontFamily: 'Pacifico'),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 55,
              ),
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
