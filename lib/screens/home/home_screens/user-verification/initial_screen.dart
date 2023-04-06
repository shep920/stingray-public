import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';
import 'package:hero/helpers/pick_file.dart';
import 'package:hero/models/user-verification/user_verification_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
//import flutter test from package:test/test.dart
import 'package:flutter_test/flutter_test.dart';

class InitialVerificationScreen extends StatefulWidget {
  const InitialVerificationScreen({Key? key}) : super(key: key);

  @override
  State<InitialVerificationScreen> createState() =>
      _InitialVerificationScreenState();
}

class _InitialVerificationScreenState extends State<InitialVerificationScreen> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "You need to take a picture of yourself to verify yourself. Here are the rules:",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "1: Your profile must have at least 1 picture of yourself.\n 2: Your handle or name must refer to yourself in some way.",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Image.asset(
            "assets/stingray_logo.png",
            height: 200,
            width: 200,
          ),
          SizedBox(
            height: 50,
          ),
          if (_image != null)
            Padding(
              padding: EdgeInsets.all(10),
              child: Image.file(_image!),
            ),
          if (_image == null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    File? _file = await PickFile.setImage(
                        source: ImageSource.camera, context: context);

                    if (_file != null) {
                      setState(() {
                        _image = _file;
                      });
                    }
                  }, //This prop for beautiful expressions
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Upload"),
                      SizedBox(
                        width: 10,
                      ),
                      FaIcon(
                        FontAwesomeIcons.cameraRetro,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 40,
                      ),
                    ],
                  ), // This child can be everything. I want to choose a beautiful Text Widget
                  style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    minimumSize: Size(MediaQuery.of(context).size.width * .8,
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
          if (_image != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String _imageUrl = "";

                    User _user = (BlocProvider.of<ProfileBloc>(context).state
                            as ProfileLoaded)
                        .user;
                    UserVerification _userVerification =
                        UserVerification.genericVerification(_user.id!);
                    BlocProvider.of<UserVerificationBloc>(context).add(
                        SendUserVerification(
                            verification: _userVerification, image: _image!));
                  }, //This prop for beautiful expressions
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Send"),
                      SizedBox(
                        width: 10,
                      ),
                      FaIcon(
                        FontAwesomeIcons.paperPlane,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 40,
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    minimumSize: Size(MediaQuery.of(context).size.width * .8,
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
        ],
      ),
    );
  }
}

//write some tests
