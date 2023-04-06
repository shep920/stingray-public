import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user-verification/user_verification_bloc.dart';
import 'package:hero/models/user-verification/user_verification_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:path_provider/path_provider.dart';

class PendingVerificationScreen extends StatelessWidget {
  const PendingVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children:
            //make some children so that it shows the user that their verification is pending and that a mod will review it.
            <Widget>[
          Text(
            "Your verification is pending. A moderator will review it soon.",
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<UserVerificationBloc>(context)
                      .add(CancelUserVerification());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("CANCEL"),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.xmark,
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
                  elevation: 5, // we can set elevation of this beautiful button
                  side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, //change border color
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
